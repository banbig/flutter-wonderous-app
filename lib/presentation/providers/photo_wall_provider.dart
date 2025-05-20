import 'package:flutter/material.dart';

/// 照片墙生成状态
enum PhotoWallStatus { idle, generating, success, failure }

/// 照片墙Provider，管理参数、状态、进度、结果文件路径等
class PhotoWallProvider extends ChangeNotifier {
  // 选中的照片数量
  int photoCount;
  // 布局随意度（0-100）
  double randomness;
  // 当前生成状态
  PhotoWallStatus status;
  // 生成进度（0.0-1.0）
  double progress;
  // 生成结果文件路径（临时/正式）
  String? resultFilePath;
  // 错误信息
  String? errorMessage;

  PhotoWallProvider({
    this.photoCount = 9,
    this.randomness = 50.0,
    this.status = PhotoWallStatus.idle,
    this.progress = 0.0,
    this.resultFilePath,
    this.errorMessage,
  });

  void setPhotoCount(int count) {
    photoCount = count;
    notifyListeners();
  }

  void setRandomness(double value) {
    randomness = value;
    notifyListeners();
  }

  void reset() {
    photoCount = 9;
    randomness = 50.0;
    status = PhotoWallStatus.idle;
    progress = 0.0;
    resultFilePath = null;
    errorMessage = null;
    notifyListeners();
  }

  Future<void> generatePhotoWall(List<String> imagePaths) async {
    status = PhotoWallStatus.generating;
    progress = 0.0;
    errorMessage = null;
    notifyListeners();
    try {
      // TODO: 调用UseCase进行生成，更新progress和resultFilePath
      await Future.delayed(Duration(seconds: 2)); // 模拟耗时
      resultFilePath = '/tmp/fake_photo_wall.jpg'; // TODO: 替换为真实路径
      status = PhotoWallStatus.success;
    } catch (e) {
      status = PhotoWallStatus.failure;
      errorMessage = e.toString();
    }
    progress = 1.0;
    notifyListeners();
  }

  // TODO: 添加参数变更、生成、重置等方法
} 