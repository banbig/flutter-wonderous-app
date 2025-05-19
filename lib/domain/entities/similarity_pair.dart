import 'photo.dart';

class SimilarityPair {
  final Photo photoA;
  final Photo photoB;
  final double score;

  SimilarityPair({
    required this.photoA,
    required this.photoB,
    required this.score,
  });
} 