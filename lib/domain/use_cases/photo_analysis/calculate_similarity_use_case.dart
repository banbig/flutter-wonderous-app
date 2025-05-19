import '../../../core/usecase/usecase.dart';
import '../../entities/photo.dart';
import 'package:dartz/dartz.dart';

class SimilarityPair {
  final Photo photoA;
  final Photo photoB;
  final double score;
  SimilarityPair({required this.photoA, required this.photoB, required this.score});
}

class CalculateSimilarityUseCase implements UseCase<List<SimilarityPair>, List<Photo>> {
  @override
  Future<Either<void, List<SimilarityPair>>> call(List<Photo> photos) async {
    List<SimilarityPair> pairs = [];
    for (int i = 0; i < photos.length; i++) {
      for (int j = i + 1; j < photos.length; j++) {
        final a = photos[i];
        final b = photos[j];
        double score = 0.0;
        // 时间相似度（5分钟内为高分）
        if (a.dateTimeOriginal != null && b.dateTimeOriginal != null) {
          final diff = (a.dateTimeOriginal!.difference(b.dateTimeOriginal!).inSeconds).abs();
          if (diff < 300) {
            score += 1.0 - (diff / 300.0); // 0~1
          }
        }
        // 地理相似度（1km内为高分）
        if (a.latitude != null && b.latitude != null && a.longitude != null && b.longitude != null) {
          final dLat = a.latitude! - b.latitude!;
          final dLon = a.longitude! - b.longitude!;
          final dist = (dLat * dLat + dLon * dLon).sqrt();
          if (dist < 0.01) {
            score += 1.0 - (dist / 0.01); // 0~1
          }
        }
        pairs.add(SimilarityPair(photoA: a, photoB: b, score: score));
      }
    }
    return Right(pairs);
  }
} 