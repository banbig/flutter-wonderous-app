import 'package:dartz/dartz.dart';
import '../entities/photo_group.dart';
import '../../core/error/failures.dart';

abstract class IPhotoRepository {
  Future<Either<Failure, List<PhotoGroup>>> getPhotoGroups();
  Future<Either<Failure, void>> deletePhotos(List<String> photoIds);
} 