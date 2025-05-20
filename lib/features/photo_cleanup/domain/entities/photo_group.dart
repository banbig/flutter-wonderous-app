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

  factory PhotoGroup.fromStringDate({
    required String date,
    required List<Photo> photos,
  }) {
    DateTime parsedDate;
    try {
      parsedDate = DateTime.parse(date);
    } catch (e) {
      parsedDate = DateTime.now();
    }
    return PhotoGroup(
      id: date,
      date: parsedDate,
      photos: photos,
    );
  }
}