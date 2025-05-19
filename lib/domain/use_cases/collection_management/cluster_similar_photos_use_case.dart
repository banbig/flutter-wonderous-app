import '../../../core/usecase/usecase.dart';
import '../../entities/photo.dart';
import '../../entities/photo_group.dart';
import '../photo_analysis/calculate_similarity_use_case.dart';
import 'package:dartz/dartz.dart';

class ClusterParams {
  final List<Photo> photos;
  final List<SimilarityPair> similarityData;
  ClusterParams({required this.photos, required this.similarityData});
}

class ClusterSimilarPhotosUseCase implements UseCase<List<PhotoGroup>, ClusterParams> {
  @override
  Future<Either<void, List<PhotoGroup>>> call(ClusterParams params) async {
    final photos = List<Photo>.from(params.photos);
    final List<PhotoGroup> groups = [];
    final Set<String> clustered = {};
    for (var photo in photos) {
      if (clustered.contains(photo.id)) continue;
      final group = <Photo>[photo];
      clustered.add(photo.id);
      for (var pair in params.similarityData) {
        if (pair.score > 0.7) {
          if (pair.photoA.id == photo.id && !clustered.contains(pair.photoB.id)) {
            group.add(pair.photoB);
            clustered.add(pair.photoB.id);
          } else if (pair.photoB.id == photo.id && !clustered.contains(pair.photoA.id)) {
            group.add(pair.photoA);
            clustered.add(pair.photoA.id);
          }
        }
      }
      groups.add(PhotoGroup(
        id: photo.id,
        date: photo.dateTimeOriginal ?? DateTime.now(),
        photos: group,
      ));
    }
    return Right(groups);
  }
} 