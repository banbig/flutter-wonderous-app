import 'package:flutter/material.dart';
import 'photo.dart';
import 'package:photo_manager/photo_manager.dart';
import 'dart:io';

/// 照片数据与状态管理，支持选中、删除、添加等操作
class PhotoDataModel extends ChangeNotifier {
  List<Photo> _photos = [];

  List<Photo> get photos => _photos;

  // 初始化模拟数据
  void loadMockPhotos() {
    _photos = List.generate(24, (i) => Photo(
      id: 'photo_\u0000$i',
      url: 'https://placehold.co/300x300?text=Photo+$i',
      name: '照片_$i.jpg',
      size: (i % 5 + 1) * 0.8,
    ));
    notifyListeners();
  }

  /// 加载本地相册照片
  Future<void> loadDevicePhotos() async {
    final PermissionState ps = await PhotoManager.requestPermissionExtend();
    if (!ps.isAuth) {
      _photos = [];
      notifyListeners();
      return;
    }
    List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
      type: RequestType.image,
      onlyAll: true,
    );
    if (albums.isEmpty) {
      _photos = [];
      notifyListeners();
      return;
    }
    List<AssetEntity> assets = await albums[0].getAssetListPaged(page: 0, size: 100);
    _photos = await Future.wait(assets.map((asset) async {
      final file = await asset.file;
      return Photo(
        id: asset.id,
        url: file != null ? file.path : '',
        name: asset.title ?? '未知图片',
        size: file != null ? (await file.length()) / 1024 / 1024 : 0.0,
      );
    }).toList());
    notifyListeners();
  }

  void toggleSelect(String id) {
    final idx = _photos.indexWhere((p) => p.id == id);
    if (idx != -1) {
      _photos[idx].isSelected = !_photos[idx].isSelected;
      notifyListeners();
    }
  }

  void selectAll() {
    for (var p in _photos) {
      p.isSelected = true;
    }
    notifyListeners();
  }

  void deselectAll() {
    for (var p in _photos) {
      p.isSelected = false;
    }
    notifyListeners();
  }

  void deleteSelected() {
    _photos.removeWhere((p) => p.isSelected);
    notifyListeners();
  }

  int get selectedCount => _photos.where((p) => p.isSelected).length;
  double get selectedSize => _photos.where((p) => p.isSelected).fold(0.0, (sum, p) => sum + p.size);
} 