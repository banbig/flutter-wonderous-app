import 'package:flutter_wonderous_app/features/photo_cleanup/domain/entities/index.dart';

class GetPhotoRecommendationsUseCase {
  GetPhotoRecommendationsUseCase();

  List<Photo> call(RecommendationSettings settings, List<Photo> photos) {
    List<Photo> sorted = List.from(photos);
    
    // 计算推荐分数
    for (var photo in sorted) {
      photo.recommendationScore = _calculateRecommendationScore(photo, settings);
    }
    
    sorted.sort((a, b) => b.recommendationScore.compareTo(a.recommendationScore));
    
    // 根据模式返回结果
    if (settings.mode == RecommendationMode.singleBest) {
      return sorted.isNotEmpty ? [sorted.first] : [];
    } else {
      int n = settings.topNValue.clamp(1, 5);
      return sorted.take(n).toList();
    }
  }

  double _calculateRecommendationScore(Photo photo, RecommendationSettings settings) {
    double score = 0;
    if (settings.criteria['clarity']?.enabled == true) {
      score += photo.clarity * (settings.criteria['clarity']?.weight ?? 1.0);
    }
    if (settings.criteria['exposure']?.enabled == true) {
      score += photo.exposure * (settings.criteria['exposure']?.weight ?? 1.0);
    }
    if (settings.criteria['faces']?.enabled == true) {
      score += photo.faces * (settings.criteria['faces']?.weight ?? 1.0);
    }
    if (settings.criteria['composition']?.enabled == true) {
      score += photo.composition * (settings.criteria['composition']?.weight ?? 1.0);
    }
    if (settings.criteria['colorfulness']?.enabled == true) {
      score += photo.colorfulness * (settings.criteria['colorfulness']?.weight ?? 1.0);
    }
    return score;
  }
}