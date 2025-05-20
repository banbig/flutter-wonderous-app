import 'package:dartz/dartz.dart';
import '../entities/photo_group.dart';
import '../../core/error/failures.dart';
import '../entities/recommendation_settings.dart';

abstract class IPhotoRepository {
  Future<Either<Failure, List<PhotoGroup>>> getPhotoGroups({required RecommendationSettings settings});
  Future<Either<Failure, void>> deletePhotos(List<String> photoIds);
} 