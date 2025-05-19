import '../../../core/usecase/usecase.dart';
import 'package:dartz/dartz.dart';
import '../../entities/photo.dart';
import '../../entities/recommendation_settings.dart';

class GetRecommendationsParams {
  final List<Photo> photosInGroup;
  final RecommendationSettings settings;
  GetRecommendationsParams({required this.photosInGroup, required this.settings});
}

class GetPhotoRecommendationsUseCase implements UseCase<List<Photo>, GetRecommendationsParams> {
  @override
  Future<Either<void, List<Photo>>> call(GetRecommendationsParams params) async {
    final photos = params.photosInGroup;
    final settings = params.settings;
    // 计算分数
    for (var photo in photos) {
      double score = 0.0;
      settings.criteria.forEach((key, criterion) {
        if (criterion.enabled) {
          switch (key) {
            case 'clarity':
              score += photo.clarity * criterion.weight;
              break;
            case 'exposure':
              score += photo.exposure * criterion.weight;
              break;
            case 'faces':
              score += photo.faces * criterion.weight;
              break;
            case 'composition':
              score += photo.composition * criterion.weight;
              break;
            case 'colorfulness':
              score += photo.colorfulness * criterion.weight;
              break;
          }
        }
      });
      photo.recommendationScore = score;
    }
    // 按分数排序
    photos.sort((a, b) => b.recommendationScore.compareTo(a.recommendationScore));
    // 标记最佳
    for (var photo in photos) {
      photo.isBestCandidate = false;
    }
    List<Photo> best;
    if (settings.mode == RecommendationMode.singleBest) {
      if (photos.isNotEmpty) {
        photos.first.isBestCandidate = true;
        best = [photos.first];
      } else {
        best = [];
      }
    } else {
      final n = settings.topNValue;
      for (int i = 0; i < photos.length && i < n; i++) {
        photos[i].isBestCandidate = true;
      }
      best = photos.take(n).toList();
    }
    return Right(best);
  }
} 