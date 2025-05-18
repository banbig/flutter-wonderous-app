class Photo {
  final String id;
  final String url;
  final double size; // 单位MB
  final String name;
  final double clarity;
  final double exposure;
  final int faces;
  final double composition;
  final double colorfulness;
  double recommendationScore;

  Photo({
    required this.id,
    required this.url,
    required this.size,
    required this.name,
    required this.clarity,
    required this.exposure,
    required this.faces,
    required this.composition,
    required this.colorfulness,
    this.recommendationScore = 0,
  });
} 