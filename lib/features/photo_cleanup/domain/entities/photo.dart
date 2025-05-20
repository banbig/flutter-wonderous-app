class Photo {
  final String id;
  final String url;
  final String name;
  final double size; // 单位MB
  final DateTime? dateTimeOriginal;
  final double? latitude;
  final double? longitude;
  final double clarity;
  final double exposure;
  final int faces;
  final double composition;
  final double colorfulness;
  double recommendationScore;
  bool isBestCandidate;

  Photo({
    required this.id,
    required this.url,
    required this.name,
    required this.size,
    this.dateTimeOriginal,
    this.latitude,
    this.longitude,
    required this.clarity,
    required this.exposure,
    required this.faces,
    required this.composition,
    required this.colorfulness,
    this.recommendationScore = 0.0,
    this.isBestCandidate = false,
  });

  // 可选：数据库序列化方法
  factory Photo.fromMap(Map<String, dynamic> map) {
    return Photo(
      id: map['id'] as String,
      url: map['url'] as String,
      name: map['name'] as String,
      size: (map['size'] as num).toDouble(),
      dateTimeOriginal: map['dateTimeOriginal'] != null ? DateTime.parse(map['dateTimeOriginal']) : null,
      latitude: map['latitude'] != null ? (map['latitude'] as num).toDouble() : null,
      longitude: map['longitude'] != null ? (map['longitude'] as num).toDouble() : null,
      clarity: (map['clarity'] as num).toDouble(),
      exposure: (map['exposure'] as num).toDouble(),
      faces: map['faces'] as int,
      composition: (map['composition'] as num).toDouble(),
      colorfulness: (map['colorfulness'] as num).toDouble(),
      recommendationScore: map['recommendationScore'] != null ? (map['recommendationScore'] as num).toDouble() : 0.0,
      isBestCandidate: map['isBestCandidate'] == 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'url': url,
      'name': name,
      'size': size,
      'dateTimeOriginal': dateTimeOriginal?.toIso8601String(),
      'latitude': latitude,
      'longitude': longitude,
      'clarity': clarity,
      'exposure': exposure,
      'faces': faces,
      'composition': composition,
      'colorfulness': colorfulness,
      'recommendationScore': recommendationScore,
      'isBestCandidate': isBestCandidate ? 1 : 0,
    };
  }
}