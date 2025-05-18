import 'package:flutter/material.dart';
import 'photo.dart';
import 'package:photo_manager/photo_manager.dart';
import 'dart:io';
import 'dart:developer' as developer;

/// 照片数据与状态管理，支持选中、删除、添加等操作
class PhotoDataModel extends ChangeNotifier {
  List<Photo> _photos = [];
  List<AssetPathEntity> _albums = [];
  AssetPathEntity? _currentAlbum;
  String? _lastAlbumId;

  List<Photo> get photos => _photos;
  List<AssetPathEntity> get albums => _albums;
  AssetPathEntity? get currentAlbum => _currentAlbum;

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

  /// 加载本地相册目录和照片
  Future<void> loadDeviceAlbumsAndPhotos({String? albumId}) async {
    final PermissionState ps = await PhotoManager.requestPermissionExtend();
    if (!ps.isAuth) {
      _photos = [];
      _albums = [];
      _currentAlbum = null;
      notifyListeners();
      return;
    }
    _albums = await PhotoManager.getAssetPathList(
      type: RequestType.image,
      onlyAll: false,
    );
    if (_albums.isEmpty) {
      _photos = [];
      _currentAlbum = null;
      notifyListeners();
      return;
    }
    // 选择指定目录或上次目录，否则默认第一个
    AssetPathEntity album = _albums.first;
    if (albumId != null) {
      final found = _albums.where((a) => a.id == albumId).toList();
      if (found.isNotEmpty) album = found.first;
    } else if (_lastAlbumId != null) {
      final found = _albums.where((a) => a.id == _lastAlbumId).toList();
      if (found.isNotEmpty) album = found.first;
    }
    _currentAlbum = album;
    _lastAlbumId = album.id;
    List<AssetEntity> assets = await album.getAssetListPaged(page: 0, size: 100);
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

  /// 切换相册目录
  Future<void> switchAlbum(AssetPathEntity album) async {
    _currentAlbum = album;
    _lastAlbumId = album.id;
    List<AssetEntity> assets = await album.getAssetListPaged(page: 0, size: 100);
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

  /// 加载指定文件夹下所有图片文件
  Future<void> loadPhotosFromFolder(String folderPath) async {
    developer.log('loadPhotosFromFolder: $folderPath');
    final dir = Directory(folderPath);
    if (!await dir.exists()) {
      developer.log('文件夹不存在: $folderPath');
      _photos = [];
      notifyListeners();
      return;
    }
    final imageExtensions = ['.jpg', '.jpeg', '.png', '.bmp', '.gif', '.webp', '.heic'];
    final files = dir
        .listSync(recursive: true)
        .whereType<File>()
        .where((f) => imageExtensions.any((ext) => f.path.toLowerCase().endsWith(ext)))
        .toList();
    developer.log('找到图片文件数量: ${files.length}');
    _photos = files.map((f) {
      final stat = f.statSync();
      return Photo(
        id: f.path,
        url: f.path,
        name: f.uri.pathSegments.isNotEmpty ? f.uri.pathSegments.last : '图片',
        size: stat.size / 1024 / 1024,
      );
    }).toList();
    notifyListeners();
  }

  /// 从图片文件路径列表加载照片
  Future<void> loadPhotosFromFiles(List<String> filePaths) async {
    developer.log('loadPhotosFromFiles: $filePaths');
    _photos = filePaths.map((path) {
      final file = File(path);
      final stat = file.existsSync() ? file.statSync() : null;
      return Photo(
        id: path,
        url: path,
        name: file.uri.pathSegments.isNotEmpty ? file.uri.pathSegments.last : '图片',
        size: stat != null ? stat.size / 1024 / 1024 : 0.0,
      );
    }).toList();
    developer.log('实际加载图片数量: ${_photos.length}');
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

  Future<void> deleteSelected() async {
    // 找到所有选中照片的id
    final ids = _photos.where((p) => p.isSelected).map((p) => p.id).toList();
    if (ids.isNotEmpty) {
      // 调用photo_manager删除本地照片
      await PhotoManager.editor.deleteWithIds(ids);
      // 删除后刷新相册
      await loadDeviceAlbumsAndPhotos();
    }
  }

  int get selectedCount => _photos.where((p) => p.isSelected).length;
  double get selectedSize => _photos.where((p) => p.isSelected).fold(0.0, (sum, p) => sum + p.size);
} 