import '../../domain/repositories/i_photo_repository.dart';
import '../../domain/entities/photo_group.dart';
import '../../core/error/failures.dart';
import 'package:dartz/dartz.dart';
import '../data_sources/local/local_photo_data_source.dart';
import '../../domain/use_cases/photo_analysis/calculate_similarity_use_case.dart';
import '../../domain/use_cases/collection_management/cluster_similar_photos_use_case.dart';

class PhotoRepositoryImpl implements IPhotoRepository {
  final LocalPhotoDataSource localDataSource;
  PhotoRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<PhotoGroup>>> getPhotoGroups() async {
    try {
      final groups = await localDataSource.getMockPhotoGroups();
      if (groups.isNotEmpty) {
        return Right(groups);
      }
      final photos = await localDataSource.fetchPhotosFromDevice();
      // MVP8: 计算相似度和聚类分组
      final similarityUseCase = CalculateSimilarityUseCase();
      final clusterUseCase = ClusterSimilarPhotosUseCase();
      final similarityResult = await similarityUseCase.call(photos);
      final List<SimilarityPair> similarityData = similarityResult.fold((l) => <SimilarityPair>[], (r) => r);
      final clusterResult = await clusterUseCase.call(ClusterParams(photos: photos, similarityData: similarityData));
      final List<PhotoGroup> photoGroups = clusterResult.fold((l) => <PhotoGroup>[], (r) => r);
      return Right(photoGroups);
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