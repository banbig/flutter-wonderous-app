import 'package:dartz/dartz.dart';
import '../entities/recommendation_settings.dart';
import '../../core/error/failures.dart';

abstract class ISettingsRepository {
  Future<Either<Failure, RecommendationSettings>> getRecommendationSettings();
  Future<Either<Failure, void>> saveRecommendationSettings(RecommendationSettings settings);
} 