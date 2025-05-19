import 'photo.dart';

class PhotoGroup {
  final String id;
  final DateTime date;
  final List<Photo> photos;

  PhotoGroup({
    required this.id,
    required this.date,
    required this.photos,
  });
} 