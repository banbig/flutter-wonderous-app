import '../../../core/usecase/usecase.dart';
import 'package:dartz/dartz.dart';
import '../../repositories/i_photo_repository.dart';
import '../../../core/error/failures.dart';

class CleanupPhotosParams {
  final List<String> photoIdsToClean;
  CleanupPhotosParams({required this.photoIdsToClean});
}

class CleanupPhotosUseCase implements UseCase<void, CleanupPhotosParams> {
  final IPhotoRepository repository;
  CleanupPhotosUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(CleanupPhotosParams params) async {
    return await repository.deletePhotos(params.photoIdsToClean);
  }
} 