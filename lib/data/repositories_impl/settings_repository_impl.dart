import 'package:dartz/dartz.dart';
import 'package:flutter_wonderous_app/data/data_sources/local/local_settings_data_source.dart';
import 'package:flutter_wonderous_app/features/settings/core/error/failures.dart';
import 'package:flutter_wonderous_app/features/settings/domain/entities/recommendation_settings.dart';
import 'package:flutter_wonderous_app/features/settings/domain/repositories/i_settings_repository.dart';

class SettingsRepositoryImpl implements ISettingsRepository {
  final LocalSettingsDataSource localDataSource;
  
  SettingsRepositoryImpl({required this.localDataSource});
  
  @override
  Future<Either<Failure, RecommendationSettings>> getRecommendationSettings() async {
    try {
      final settings = await localDataSource.getRecommendationSettings();
      return Right(settings);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, void>> saveRecommendationSettings(RecommendationSettings settings) async {
    try {
      await localDataSource.saveRecommendationSettings(settings);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}