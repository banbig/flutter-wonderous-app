import 'photo.dart';

class PhotoGroup {
  final String id;
  final DateTime date;
  final String? dateString;
  final List<Photo> photos;

  PhotoGroup({
    required this.id,
    required this.date,
    required this.photos,
    this.dateString,
  });

  // 兼容旧构造
  factory PhotoGroup.fromStringDate({required String date, required List<Photo> photos}) {
    return PhotoGroup(id: date, date: DateTime.tryParse(date) ?? DateTime.now(), photos: photos, dateString: date);
  }
} 