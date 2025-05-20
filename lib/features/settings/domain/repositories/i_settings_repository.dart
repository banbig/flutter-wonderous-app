import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/recommendation_settings.dart';

abstract class ISettingsRepository {
  Future<Either<Failure, RecommendationSettings>> getRecommendationSettings();
  Future<Either<Failure, void>> saveRecommendationSettings(RecommendationSettings settings);
}