import '../../../domain/entities/photo_group.dart';
import '../../../domain/entities/photo.dart';
import 'dart:math';

abstract class LocalPhotoDataSource {
  Future<List<PhotoGroup>> getMockPhotoGroups();
  Future<void> deleteMockPhotos(List<String> photoIds);
}

class LocalPhotoDataSourceImpl implements LocalPhotoDataSource {
  List<PhotoGroup> _mockGroups = [];

  LocalPhotoDataSourceImpl() {
    _mockGroups = _loadMockData();
  }

  @override
  Future<List<PhotoGroup>> getMockPhotoGroups() async {
    await Future.delayed(Duration(milliseconds: 300));
    return _mockGroups;
  }

  @override
  Future<void> deleteMockPhotos(List<String> photoIds) async {
    for (var group in _mockGroups) {
      group.photos.removeWhere((photo) => photoIds.contains(photo.id));
    }
    _mockGroups.removeWhere((group) => group.photos.isEmpty);
  }

  List<PhotoGroup> _loadMockData() {
    final now = DateTime.now();
    final random = Random();
    return List.generate(3, (g) {
      return PhotoGroup(
        id: 'group$g',
        date: now.subtract(Duration(days: g)),
        photos: List.generate(5, (i) {
          return Photo(
            id: 'g${g}_p$i',
            url: 'https://picsum.photos/seed/${g * 10 + i}/200/200',
            name: '照片${g * 10 + i}',
            size: random.nextDouble() * 5 + 1,
            dateTimeOriginal: now.subtract(Duration(days: g, minutes: i * 5)),
            clarity: random.nextDouble(),
            exposure: random.nextDouble(),
            faces: random.nextInt(3),
            composition: random.nextDouble(),
            colorfulness: random.nextDouble(),
          );
        }),
      );
    });
  }
} 