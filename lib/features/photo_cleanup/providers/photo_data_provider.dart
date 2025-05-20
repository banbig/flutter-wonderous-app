import 'package:flutter/material.dart';
import '../domain/entities/photo_group.dart';
import '../domain/entities/photo.dart';

class PhotoDataProvider extends ChangeNotifier {
  final List<Photo> _photos = [];
  final List<PhotoGroup> _photoGroups = [];
  final List<Photo> _selectedPhotos = [];
  final List<Photo> _allPhotosKeptAfterCleaning = [];

  List<Photo> get photos => List.unmodifiable(_photos);
  List<PhotoGroup> get photoGroups => List.unmodifiable(_photoGroups);
  List<Photo> get selectedPhotos => List.unmodifiable(_selectedPhotos);
  List<Photo> get allPhotosKeptAfterCleaning => List.unmodifiable(_allPhotosKeptAfterCleaning);

  void addPhoto(Photo photo) {
    _photos.add(photo);
    notifyListeners();
  }

  void removePhoto(Photo photo) {
    _photos.remove(photo);
    notifyListeners();
  }

  void setPhotoGroups(List<PhotoGroup> groups) {
    _photoGroups.clear();
    _photoGroups.addAll(groups);
    notifyListeners();
  }

  void selectPhoto(Photo photo) {
    if (!_selectedPhotos.contains(photo)) {
      _selectedPhotos.add(photo);
      notifyListeners();
    }
  }

  void unselectPhoto(Photo photo) {
    if (_selectedPhotos.remove(photo)) {
      notifyListeners();
    }
  }

  void setAllPhotosKeptAfterCleaning(List<Photo> photos) {
    _allPhotosKeptAfterCleaning.clear();
    _allPhotosKeptAfterCleaning.addAll(photos);
    notifyListeners();
  }
} 