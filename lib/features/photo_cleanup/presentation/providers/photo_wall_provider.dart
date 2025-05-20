import 'package:flutter/material.dart';
import 'dart:math';

class PhotoWallProvider extends ChangeNotifier {
  int _photoCount = 12;
  double _randomness = 50.0;
  List<String> _selectedPhotoIds = [];
  
  int get photoCount => _photoCount;
  double get randomness => _randomness;
  List<String> get selectedPhotoIds => _selectedPhotoIds;
  
  void setPhotoCount(int count) {
    _photoCount = count;
    notifyListeners();
  }
  
  void setRandomness(double value) {
    _randomness = value;
    notifyListeners();
  }
  
  Future<void> generatePhotoWall(List<String> photoIds) async {
    _selectedPhotoIds = List.from(photoIds);
    
    // 在实际应用中，这里可能会加载照片并生成照片墙
    await Future.delayed(const Duration(milliseconds: 500));
    
    notifyListeners();
  }
}