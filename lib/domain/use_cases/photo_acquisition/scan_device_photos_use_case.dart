import '../../../core/usecase/usecase.dart';
import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../../core/platform_services/photo_gallery_service.dart';
import '../../entities/photo.dart';

class ScanDevicePhotosUseCase implements UseCase<List<Photo>, NoParams> {
  final PhotoGalleryService service;
  ScanDevicePhotosUseCase(this.service);

  @override
  Future<Either<Failure, List<Photo>>> call(NoParams params) async {
    try {
      final mediaList = await service.fetchDevicePhotos();
      final photos = mediaList.map((m) => Photo(
        id: m.id,
        url: '', // 真实路径/缩略图后续处理
        name: m.filename ?? m.id,
        size: (m.size ?? 0).toDouble(),
        dateTimeOriginal: m.creationDate,
        clarity: 0.5, // 可用EXIF等后续完善
        exposure: 0.5,
        faces: 0,
        composition: 0.5,
        colorfulness: 0.5,
        recommendationScore: 0.0,
        isBestCandidate: false,
      )).toList();
      return Right(photos);
    } catch (e) {
      return Left(CacheFailure('扫描设备照片失败'));
    }
  }
} 