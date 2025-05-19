import '../../domain/repositories/i_photo_repository.dart';
import '../../domain/entities/photo_group.dart';
import '../../core/error/failures.dart';
import 'package:dartz/dartz.dart';
import '../data_sources/local/local_photo_data_source.dart';

class PhotoRepositoryImpl implements IPhotoRepository {
  final LocalPhotoDataSource localDataSource;
  PhotoRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<PhotoGroup>>> getPhotoGroups() async {
    try {
      final groups = await localDataSource.getMockPhotoGroups();
      return Right(groups);
    } catch (e) {
      return Left(CacheFailure('获取照片分组失败'));
    }
  }

  @override
  Future<Either<Failure, void>> deletePhotos(List<String> photoIds) async {
    try {
      await localDataSource.deleteMockPhotos(photoIds);
      return Right(null);
    } catch (e) {
      return Left(CacheFailure('删除照片失败'));
    }
  }
} 