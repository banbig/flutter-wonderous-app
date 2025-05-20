import '../../domain/repositories/i_settings_repository.dart';
import '../../domain/entities/recommendation_settings.dart';
import '../../core/error/failures.dart';
import '../../core/error/exceptions.dart';
import 'package:dartz/dartz.dart';
import '../data_sources/local/local_settings_data_source.dart';

class SettingsRepositoryImpl implements ISettingsRepository {
  final LocalSettingsDataSource localDataSource;
  SettingsRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, RecommendationSettings>> getRecommendationSettings() async {
    try {
      final settings = await localDataSource.getLastRecommendationSettings();
      return Right(settings);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> saveRecommendationSettings(RecommendationSettings settings) async {
    try {
      await localDataSource.cacheRecommendationSettings(settings);
      return Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }
} 