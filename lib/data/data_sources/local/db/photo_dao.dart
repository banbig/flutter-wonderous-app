import 'package:sqflite/sqflite.dart';
import '../../../domain/entities/photo.dart';

class PhotoDao {
  final Database db;
  PhotoDao(this.db);

  Future<void> insertPhoto(Photo photo) async {
    await db.insert('photos', _toMap(photo), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> insertPhotos(List<Photo> photos) async {
    final batch = db.batch();
    for (var photo in photos) {
      batch.insert('photos', _toMap(photo), conflictAlgorithm: ConflictAlgorithm.replace);
    }
    await batch.commit(noResult: true);
  }

  Future<Photo?> getPhotoById(String id) async {
    final maps = await db.query('photos', where: 'id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return _fromMap(maps.first);
    }
    return null;
  }

  Future<List<Photo>> getAllPhotos() async {
    final maps = await db.query('photos');
    return maps.map(_fromMap).toList();
  }

  Future<List<Photo>> getPhotosByGroupId(String groupId) async {
    final maps = await db.query('photos', where: 'groupId = ?', whereArgs: [groupId]);
    return maps.map(_fromMap).toList();
  }

  Future<void> updatePhoto(Photo photo) async {
    await db.update('photos', _toMap(photo), where: 'id = ?', whereArgs: [photo.id]);
  }

  Future<int> deletePhoto(String id) async {
    return await db.delete('photos', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deletePhotos(List<String> ids) async {
    final batch = db.batch();
    for (var id in ids) {
      batch.delete('photos', where: 'id = ?', whereArgs: [id]);
    }
    await batch.commit(noResult: true);
    return ids.length;
  }

  Map<String, dynamic> _toMap(Photo photo) {
    return {
      'id': photo.id,
      'url': photo.url,
      'name': photo.name,
      'size': photo.size,
      'dateTimeOriginal': photo.dateTimeOriginal?.toIso8601String(),
      'latitude': photo.latitude,
      'longitude': photo.longitude,
      'clarity': photo.clarity,
      'exposure': photo.exposure,
      'faces': photo.faces,
      'composition': photo.composition,
      'colorfulness': photo.colorfulness,
      'recommendationScore': photo.recommendationScore,
      'isBestCandidate': photo.isBestCandidate ? 1 : 0,
      'groupId': null, // 可后续完善
    };
  }

  Photo _fromMap(Map<String, dynamic> map) {
    return Photo(
      id: map['id'],
      url: map['url'],
      name: map['name'],
      size: map['size'],
      dateTimeOriginal: map['dateTimeOriginal'] != null ? DateTime.parse(map['dateTimeOriginal']) : null,
      latitude: map['latitude'],
      longitude: map['longitude'],
      clarity: map['clarity'],
      exposure: map['exposure'],
      faces: map['faces'],
      composition: map['composition'],
      colorfulness: map['colorfulness'],
      recommendationScore: map['recommendationScore'],
      isBestCandidate: map['isBestCandidate'] == 1,
    );
  }
} 