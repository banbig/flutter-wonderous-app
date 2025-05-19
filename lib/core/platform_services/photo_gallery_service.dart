import 'package:photo_gallery/photo_gallery.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:typed_data';

class PhotoGalleryService {
  Future<List<Medium>> fetchDevicePhotos() async {
    final status = await Permission.photos.request();
    if (!status.isGranted) return [];
    final albums = await PhotoGallery.listAlbums(mediumType: MediumType.image);
    List<Medium> allMedia = [];
    for (final album in albums) {
      final mediaPage = await album.listMedia();
      allMedia.addAll(mediaPage.items);
    }
    return allMedia;
  }

  Future<Uint8List?> getThumbnail({required String mediumId, int width = 200, int height = 200}) async {
    final data = await PhotoGallery.getThumbnail(
      mediumId: mediumId,
      width: width,
      height: height,
    );
    if (data == null) return null;
    return Uint8List.fromList(data);
  }
} 