import 'package:flutter/material.dart';
import '../models/photo.dart';
import '../models/photo_group.dart';
import '../models/recommendation_settings.dart';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart';

// 移动端依赖
import 'package:photo_manager/photo_manager.dart';
// 桌面端依赖
import 'package:file_picker/file_picker.dart';

class PhotoDataProvider extends ChangeNotifier {
  List<PhotoGroup> _photoGroups = [];
  Set<String> _selectedPhotos = {};
  List<Photo> _allPhotosKeptAfterCleaning = [];

  List<PhotoGroup> get photoGroups => _photoGroups;
  Set<String> get selectedPhotos => _selectedPhotos;
  List<Photo> get allPhotosKeptAfterCleaning => _allPhotosKeptAfterCleaning;

  Future<void> loadPhotosFromDevice() async {
    // 统一所有端逻辑：多选图片文件（不递归目录），异步处理
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.image,
      dialogTitle: '请选择图片文件',
      initialDirectory: '/Users/', // 可选，指定初始目录
    );
    if (result != null && result.files.isNotEmpty) {
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
        // 按日期分组
        Map<String, List<Photo>> groupMap = {};
        for (final photo in allPhotos) {
          String date = await _getPhotoDate(photo);
          groupMap.putIfAbsent(date, () => []).add(photo);
        }
        _photoGroups = groupMap.entries
            .map((e) => PhotoGroup(date: e.key, photos: e.value))
            .toList()
          ..sort((a, b) => b.date.compareTo(a.date));
        notifyListeners();
      });
      return;
    }
  }

  Future<String> _getPhotoDate(Photo photo) async {
    try {
      final file = File(photo.url);
      final stat = await file.stat();
      return DateFormat('yyyy-MM-dd').format(stat.modified);
    } catch (_) {
      return '未知日期';
    }
  }

  double _randomAttr() => (0.5 + (0.5 * (DateTime.now().microsecond % 100) / 100)).clamp(0.0, 1.0);
  int _randomFaces() => DateTime.now().microsecond % 3;

  void selectPhoto(String photoId, bool selected) {
    if (selected) {
      _selectedPhotos.add(photoId);
    } else {
      _selectedPhotos.remove(photoId);
    }
    notifyListeners();
  }

  void clearSelectedPhotos() {
    _selectedPhotos.clear();
    notifyListeners();
  }

  void cleanSelectedPhotos() {
    for (var group in _photoGroups) {
      group.photos.removeWhere((photo) => _selectedPhotos.contains(photo.id));
    }
    _allPhotosKeptAfterCleaning = _photoGroups.expand((g) => g.photos).toList();
    _selectedPhotos.clear();
    notifyListeners();
  }

  void calculateRecommendationScores(RecommendationSettings settings) {
    for (var group in _photoGroups) {
      for (var photo in group.photos) {
        photo.recommendationScore = calculateRecommendationScore(photo, settings);
      }
    }
    notifyListeners();
  }

  double calculateRecommendationScore(Photo photo, RecommendationSettings settings) {
    double score = 0;
    if (settings.enabledCriteria['clarity'] == true) {
      score += photo.clarity * (settings.weights['clarity'] ?? 1.0);
    }
    if (settings.enabledCriteria['exposure'] == true) {
      score += photo.exposure * (settings.weights['exposure'] ?? 1.0);
    }
    if (settings.enabledCriteria['faces'] == true) {
      score += photo.faces * (settings.weights['faces'] ?? 1.0);
    }
    if (settings.enabledCriteria['composition'] == true) {
      score += photo.composition * (settings.weights['composition'] ?? 1.0);
    }
    if (settings.enabledCriteria['colorfulness'] == true) {
      score += photo.colorfulness * (settings.weights['colorfulness'] ?? 1.0);
    }
    return score;
  }

  List<Photo> getBestPhotosInGroup(List<Photo> photos, RecommendationSettings settings) {
    List<Photo> sorted = List.from(photos);
    sorted.sort((a, b) => b.recommendationScore.compareTo(a.recommendationScore));
    if (settings.mode == RecommendationMode.singleBest) {
      return sorted.isNotEmpty ? [sorted.first] : [];
    } else {
      int n = settings.topN.clamp(1, 5);
      return sorted.take(n).toList();
    }
  }

  void smartSelect(RecommendationSettings settings) {
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
    calculateRecommendationScores(settings);
    if (settings.smartSelectEnabled) {
      smartSelect(settings);
    } else {
      clearSelectedPhotos();
    }
  }
} 