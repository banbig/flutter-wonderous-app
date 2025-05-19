import 'package:photo_gallery/photo_gallery.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:typed_data';

class PhotoGalleryService {
  Future<List<Medium>> fetchDevicePhotos() async {
    final status = await Permission.photos.request();
    if (!status.isGranted) return [];
    final media = await PhotoGallery.listMedia(
      mediumType: MediumType.image,
      newest: true,
    );
    return media.items;
  }

  Future<Uint8List?> getThumbnail({required String mediumId, int width = 200, int height = 200}) async {
    return await PhotoGallery.getThumbnail(
      mediumId: mediumId,
      width: width,
      height: height,
    );
  }
} 