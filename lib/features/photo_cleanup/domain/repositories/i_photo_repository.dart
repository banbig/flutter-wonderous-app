import 'package:flutter_wonderous_app/features/photo_cleanup/domain/entities/index.dart';

abstract class IPhotoRepository {
  Future<List<PhotoGroup>> getPhotoGroups();
  Future<void> cleanupPhotos(Set<String> photoIds);
}