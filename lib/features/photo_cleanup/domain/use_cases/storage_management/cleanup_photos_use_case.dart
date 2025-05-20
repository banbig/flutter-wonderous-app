import 'package:flutter_wonderous_app/features/photo_cleanup/domain/repositories/i_photo_repository.dart';

class CleanupPhotosUseCase {
  final IPhotoRepository photoRepository;

  CleanupPhotosUseCase(this.photoRepository);

  Future<void> call(Set<String> photoIds) async {
    if (photoIds.isEmpty) return;
    await photoRepository.cleanupPhotos(photoIds);
  }
}