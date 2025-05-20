import 'package:flutter/material.dart';
import '../domain/entities/photo.dart';
import '../domain/entities/photo_group.dart';
import '../domain/entities/recommendation_settings.dart';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

// 移动端依赖
import 'package:photo_manager/photo_manager.dart';
// 桌面端依赖
import 'package:file_picker/file_picker.dart';

import '../main.dart';
import '../presentation/providers/clustering_view_provider.dart';

class PhotoDataProvider extends ChangeNotifier {
  final Logger _logger = Logger();
  List<PhotoGroup> _photoGroups = [];
  Set<String> _selectedPhotos = {};
  List<Photo> _allPhotosKeptAfterCleaning = [];

  List<PhotoGroup> get photoGroups => _photoGroups;
  Set<String> get selectedPhotos => _selectedPhotos;
  List<Photo> get allPhotosKeptAfterCleaning => _allPhotosKeptAfterCleaning;

  Future<void> loadPhotosFromDevice() async {
    _logger.d('调用 loadPhotosFromDevice');
    // 统一所有端逻辑：多选图片文件（不递归目录），异步处理
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.image,
      dialogTitle: '请选择图片文件',
      initialDirectory: '/Users/', // 可选，指定初始目录
    );
    if (result != null && result.files.isNotEmpty) {
      _logger.d('选择了 [32m${result.files.length}[0m 张图片');
      // 先清空分组并立即刷新UI，提示正在导入
      _photoGroups = [];
      notifyListeners();
      // 后台异步处理文件，避免主线程卡顿
      Future(() async {
        List<Photo> allPhotos = [];
        for (final f in result.files) {
          if (f.path == null) continue;
          final file = File(f.path!);
          final stat = await file.stat();
          allPhotos.add(Photo(
            id: f.identifier ?? f.path ?? UniqueKey().toString(),
            url: f.path!,
            size: stat.size / 1024 / 1024,
            name: p.basename(f.path!),
            clarity: _randomAttr(),
            exposure: _randomAttr(),
            faces: _randomFaces(),
            composition: _randomAttr(),
            colorfulness: _randomAttr(),
          ));
        }
        _logger.d('实际导入Photo对象数量: [32m${allPhotos.length}[0m');
        // 按日期分组
        Map<String, List<Photo>> groupMap = {};
        for (final photo in allPhotos) {
          String date = await _getPhotoDate(photo);
          groupMap.putIfAbsent(date, () => []).add(photo);
        }
        _photoGroups = groupMap.entries
            .map((e) => PhotoGroup.fromStringDate(date: e.key, photos: e.value))
            .toList()
          ..sort((a, b) => b.date.compareTo(a.date));
        _logger.d('分组后PhotoGroup数量: [32m${_photoGroups.length}[0m');
        notifyListeners();
      });
      return;
    } else {
      _logger.d('未选择任何图片');
    }
  }

  Future<String> _getPhotoDate(Photo photo) async {
    _logger.d('调用 _getPhotoDate, photo.url=${photo.url}');
    try {
      final file = File(photo.url);
      final stat = await file.stat();
      return DateFormat('yyyy-MM-dd').format(stat.modified);
    } catch (e) {
      _logger.e('获取图片日期失败: $e');
      return '未知日期';
    }
  }

  double _randomAttr() => (0.5 + (0.5 * (DateTime.now().microsecond % 100) / 100)).clamp(0.0, 1.0);
  int _randomFaces() => DateTime.now().microsecond % 3;

  void selectPhoto(String photoId, bool selected) {
    _logger.d('调用 selectPhoto, photoId=$photoId, selected=$selected');
    if (selected) {
      _selectedPhotos.add(photoId);
    } else {
      _selectedPhotos.remove(photoId);
    }
    notifyListeners();
  }

  void clearSelectedPhotos() {
    _logger.d('调用 clearSelectedPhotos');
    _selectedPhotos.clear();
    notifyListeners();
  }

  void cleanSelectedPhotos(Set<String> photoIds) {
    _logger.d('待删除的照片ID: $photoIds');
    for (var group in _photoGroups) {
      _logger.d('分组${group.id} 初始照片数: ${group.photos.length}');
      group.photos.removeWhere((photo) {
        if (photoIds.contains(photo.id)) {
          _logger.d('准备删除: ${photo.url}');
          try {
            final file = File(photo.url);
            _logger.d('尝试删除文件: ${photo.url}');
            if (file.existsSync()) {
              file.deleteSync();
              _logger.d('已删除: ${photo.url}');
            } else {
              _logger.w('文件不存在: ${photo.url}');
            }
          } catch (e) {
            _logger.w('删除文件失败: ${photo.url}, error: $e');
          }
          return true;
        }
        return false;
      });
      _logger.d('分组${group.id} 删除后照片数: ${group.photos.length}');
    }
    _allPhotosKeptAfterCleaning = _photoGroups.expand((g) => g.photos).toList();
    notifyListeners();
  }

  void calculateRecommendationScores(RecommendationSettings settings) {
    _logger.d('调用 calculateRecommendationScores');
    for (var group in _photoGroups) {
      for (var photo in group.photos) {
        photo.recommendationScore = calculateRecommendationScore(photo, settings);
      }
    }
    notifyListeners();
  }

  double calculateRecommendationScore(Photo photo, RecommendationSettings settings) {
    double score = 0;
    if (settings.criteria['clarity']?.enabled == true) {
      score += photo.clarity * (settings.criteria['clarity']?.weight ?? 1.0);
    }
    if (settings.criteria['exposure']?.enabled == true) {
      score += photo.exposure * (settings.criteria['exposure']?.weight ?? 1.0);
    }
    if (settings.criteria['faces']?.enabled == true) {
      score += photo.faces * (settings.criteria['faces']?.weight ?? 1.0);
    }
    if (settings.criteria['composition']?.enabled == true) {
      score += photo.composition * (settings.criteria['composition']?.weight ?? 1.0);
    }
    if (settings.criteria['colorfulness']?.enabled == true) {
      score += photo.colorfulness * (settings.criteria['colorfulness']?.weight ?? 1.0);
    }
    return score;
  }

  List<Photo> getBestPhotosInGroup(List<Photo> photos, RecommendationSettings settings) {
    List<Photo> sorted = List.from(photos);
    sorted.sort((a, b) => b.recommendationScore.compareTo(a.recommendationScore));
    if (settings.mode == RecommendationMode.singleBest) {
      return sorted.isNotEmpty ? [sorted.first] : [];
    } else {
      int n = settings.topNValue.clamp(1, 5);
      return sorted.take(n).toList();
    }
  }

  void smartSelect(RecommendationSettings settings) {
    _logger.d('调用 smartSelect');
    _selectedPhotos.clear();
    for (var group in _photoGroups) {
      final best = getBestPhotosInGroup(group.photos, settings).map((p) => p.id).toSet();
      for (var photo in group.photos) {
        if (!best.contains(photo.id)) {
          _selectedPhotos.add(photo.id);
        }
      }
    }
    notifyListeners();
  }

  void updateRecommendationAndSmartSelect(RecommendationSettings settings) {
    _logger.d('调用 updateRecommendationAndSmartSelect');
    calculateRecommendationScores(settings);
    smartSelect(settings);
  }
} 