import 'package:flutter_wonderous_app/data/data_sources/local/local_photo_data_source.dart';
import 'package:flutter_wonderous_app/features/photo_cleanup/domain/entities/photo_group.dart';
import 'package:flutter_wonderous_app/features/photo_cleanup/domain/repositories/i_photo_repository.dart';

class PhotoRepositoryImpl implements IPhotoRepository {
  final LocalPhotoDataSource localDataSource;
  
  PhotoRepositoryImpl({required this.localDataSource});
  
  @override
  Future<List<PhotoGroup>> getPhotoGroups() async {
    return await localDataSource.getPhotoGroups();
  }
  
  @override
  Future<void> cleanupPhotos(Set<String> photoIds) async {
    await localDataSource.cleanupPhotos(photoIds);
  }
}