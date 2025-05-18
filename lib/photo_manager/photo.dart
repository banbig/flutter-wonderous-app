/// 照片数据结构，包含基本属性和可扩展元数据
class Photo {
  final String id;
  final String url;
  final String name;
  final double size; // 单位：MB
  bool isSelected;
  // 可扩展元数据
  final Map<String, dynamic>? meta;

  Photo({
    required this.id,
    required this.url,
    required this.name,
    required this.size,
    this.isSelected = false,
    this.meta,
  });
} 