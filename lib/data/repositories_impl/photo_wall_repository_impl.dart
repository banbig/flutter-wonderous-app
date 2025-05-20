import '../../core/platform_services/media_processing_service.dart';

/// 照片墙数据仓库实现
class PhotoWallRepositoryImpl {
  final MediaProcessingService mediaProcessingService;

  PhotoWallRepositoryImpl(this.mediaProcessingService);

  /// 生成照片墙，返回文件路径
  Future<String> generatePhotoWall({
    required List<String> imagePaths,
    required int photoCount,
    required double randomness,
  }) async {
    // TODO: 调用mediaProcessingService.generatePhotoWall
    throw UnimplementedError();
  }
} 