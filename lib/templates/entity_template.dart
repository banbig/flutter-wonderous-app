/// 实体模型模板
/// 用于创建新的功能模块的实体类
class EntityTemplate {
  final String id;
  final String title;
  final String description;
  final DateTime createdAt;
  bool isFavorite;
  
  EntityTemplate({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
    this.isFavorite = false,
  });
  
  /// 创建副本
  EntityTemplate copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? createdAt,
    bool? isFavorite,
  }) {
    return EntityTemplate(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
  
  /// 从Map创建实体
  factory EntityTemplate.fromMap(Map<String, dynamic> map) {
    return EntityTemplate(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
      isFavorite: map['isFavorite'] as bool? ?? false,
    );
  }
  
  /// 转换为Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
      'isFavorite': isFavorite,
    };
  }
  
  @override
  String toString() {
    return 'EntityTemplate(id: $id, title: $title, isFavorite: $isFavorite)';
  }
}