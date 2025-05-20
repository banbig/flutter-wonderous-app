/// 照片墙生成参数
class GeneratePhotoWallParams {
  final List<String> imagePaths; // 原始图片路径
  final int photoCount; // 照片数量
  final double randomness; // 布局随意度

  GeneratePhotoWallParams({
    required this.imagePaths,
    required this.photoCount,
    required this.randomness,
  });
}

/// 照片墙生成用例，负责调度生成逻辑
class GeneratePhotoWallUseCase {
  // TODO: 注入MediaProcessingService等依赖

  /// 执行生成逻辑，返回生成结果文件路径
  Future<String> call(GeneratePhotoWallParams params) async {
    // TODO: 调用MediaProcessingService进行图片拼接
    throw UnimplementedError();
  }
} 