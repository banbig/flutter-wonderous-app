class Photo {
  final String id;
  final String url;
  final String name;
  final double size;
  final DateTime? dateTimeOriginal;
  final double? latitude;
  final double? longitude;
  double clarity;
  double exposure;
  int faces;
  double composition;
  double colorfulness;
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
    this.clarity = 0.0,
    this.exposure = 0.0,
    this.faces = 0,
    this.composition = 0.0,
    this.colorfulness = 0.0,
    this.recommendationScore = 0.0,
    this.isBestCandidate = false,
  });
} 