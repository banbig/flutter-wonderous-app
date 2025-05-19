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
      // 1. 优先从数据库读取
      final cachedPhotos = await localDataSource.getCachedPhotos();
      if (cachedPhotos.isNotEmpty) {
        // 简单按groupId分组（如未实现可按天分组）
        final Map<String, List<Photo>> groupMap = {};
        for (var photo in cachedPhotos) {
          final key = photo.dateTimeOriginal?.toIso8601String().substring(0, 10) ?? '未知';
          groupMap.putIfAbsent(key, () => []).add(photo);
        }
        final photoGroups = groupMap.entries.map((e) => PhotoGroup(
          id: e.key,
          date: e.value.first.dateTimeOriginal ?? DateTime.now(),
          photos: e.value,
        )).toList();
        return Right(photoGroups);
      }
      // 2. 若无缓存则扫描设备、聚类、推荐并缓存
      final photos = await localDataSource.fetchPhotosFromDevice();
      final similarityUseCase = CalculateSimilarityUseCase();
      final clusterUseCase = ClusterSimilarPhotosUseCase();
      final similarityResult = await similarityUseCase.call(photos);
      final similarityData = similarityResult.fold((l) => [], (r) => r);
      final clusterResult = await clusterUseCase.call(ClusterParams(photos: photos, similarityData: similarityData));
      final photoGroups = clusterResult.fold((l) => [], (r) => r);
      // 推荐分数和最佳标记
      for (var group in photoGroups) {
        // 这里可注入GetPhotoRecommendationsUseCase
      }
      // 缓存到数据库
      await localDataSource.cachePhotos(photos);
      return Right(photoGroups);
    } catch (e) {
      return Left(CacheFailure('获取照片分组失败'));
    }
  }

  @override
  Future<Either<Failure, void>> deletePhotos(List<String> photoIds) async {
    try {
      await localDataSource.deleteCachedPhotos(photoIds);
      return Right(null);
    } catch (e) {
      return Left(CacheFailure('删除照片失败'));
    }
  }
} 