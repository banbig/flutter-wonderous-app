/// 照片墙本地数据源，负责临时/正式文件管理
class PhotoWallDataSource {
  /// 保存临时文件，返回路径
  Future<String> saveTempFile(List<int> bytes) async {
    // TODO: 实现临时文件保存逻辑
    throw UnimplementedError();
  }

  /// 保存正式文件，返回路径
  Future<String> saveFinalFile(List<int> bytes) async {
    // TODO: 实现正式文件保存逻辑
    throw UnimplementedError();
  }

  /// 清理临时文件
  Future<void> cleanTempFiles() async {
    // TODO: 实现临时文件清理逻辑
    throw UnimplementedError();
  }
} 