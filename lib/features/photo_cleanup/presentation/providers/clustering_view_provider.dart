import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_wonderous_app/features/photo_cleanup/domain/entities/photo_group.dart';
import 'package:flutter_wonderous_app/features/photo_cleanup/domain/entities/photo.dart';
import 'package:flutter_wonderous_app/features/photo_cleanup/domain/entities/recommendation_settings.dart';
import 'package:flutter_wonderous_app/features/photo_cleanup/domain/providers/photo_data_provider.dart';
import 'package:flutter_wonderous_app/features/settings/presentation/providers/settings_view_provider.dart';

class ClusteringViewProvider extends ChangeNotifier {
  // 简化构造函数，移除之前的复杂依赖
  ClusteringViewProvider();
  
  bool _isSmartSelectEnabled = false;
  bool _isLoading = false;
  Set<String> _selectedPhotoIds = {};
  
  // Photo数据提供者
  PhotoDataProvider? _photoDataProvider;
  
  set photoDataProvider(PhotoDataProvider provider) {
    _photoDataProvider = provider;
  }
  
  List<PhotoGroup> get displayedGroups => _photoDataProvider?.photoGroups ?? [];
  
  bool get isSmartSelectEnabled => _isSmartSelectEnabled;
  bool get isLoading => _isLoading;
  Set<String> get selectedPhotoIds => _selectedPhotoIds;
  
  Future<void> fetchPhotoGroups(BuildContext context) async {
    _setLoading(true);
    
    try {
      // 简化版本，不做实际操作
      await Future.delayed(Duration(milliseconds: 500));
      
      if (_isSmartSelectEnabled) {
        applySmartSelect();
      }
    } catch (e) {
      debugPrint('获取照片组失败: $e');
    } finally {
      _setLoading(false);
    }
  }
  
  void setSmartSelectEnabled(bool value) {
    if (_isSmartSelectEnabled == value) return;
    
    _isSmartSelectEnabled = value;
    
    if (_isSmartSelectEnabled) {
      applySmartSelect();
    } else {
      _selectedPhotoIds = {};
    }
    
    notifyListeners();
  }
  
  void applySmartSelect() {
    if (_photoDataProvider == null) return;
    
    _selectedPhotoIds = {};
    
    // 简化版本，模拟选中一些照片
    for (var group in displayedGroups) {
      for (var photo in group.photos) {
        // 随机选择照片（模拟）
        if (DateTime.now().millisecondsSinceEpoch % 2 == 0) {
          _selectedPhotoIds.add(photo.id);
        }
      }
    }
    
    notifyListeners();
  }
  
  void togglePhotoSelection(String photoId) {
    if (_selectedPhotoIds.contains(photoId)) {
      _selectedPhotoIds.remove(photoId);
    } else {
      _selectedPhotoIds.add(photoId);
    }
    notifyListeners();
  }
  
  Future<void> performCleanup(BuildContext context) async {
    if (_selectedPhotoIds.isEmpty) return;
    
    _setLoading(true);
    
    try {
      // 简化版本，直接调用PhotoDataProvider
      if (_photoDataProvider != null) {
        _photoDataProvider!.cleanSelectedPhotos(_selectedPhotoIds);
      }
      
      // 清除选择
      _selectedPhotoIds = {};
      
      // 显示成功消息
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('清理成功')),
      );
    } catch (e) {
      // 显示错误消息
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('清理失败: $e')),
      );
    } finally {
      _setLoading(false);
    }
  }
  
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
  
  List<Photo> getBestPhotosInGroup(List<Photo> photos, RecommendationSettings settings) {
    // 简化版本，仅返回前1-3张照片
    if (photos.isEmpty) return [];
    
    if (settings.mode == RecommendationMode.singleBest) {
      return [photos.first];
    } else {
      int n = settings.topNValue.clamp(1, 3);
      n = n.clamp(1, photos.length);
      return photos.take(n).toList();
    }
  }
}