import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/photo_data_provider.dart';
import '../../models/photo.dart';
import 'dart:io';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AlbumScreen extends StatelessWidget {
  const AlbumScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final photoProvider = context.watch<PhotoDataProvider>();
    final photoGroups = photoProvider.photoGroups;
    final List<Photo> allPhotos = photoGroups.expand((g) => g.photos).toList();
    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.albumTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.file_upload_outlined),
            tooltip: localizations.albumImport,
            onPressed: () async {
              await photoProvider.loadPhotosFromDevice();
            },
          ),
        ],
      ),
      body: allPhotos.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.photo_library_outlined, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(localizations.albumEmpty, style: const TextStyle(color: Colors.grey, fontSize: 16)),
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                itemCount: allPhotos.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 1,
                ),
                itemBuilder: (context, index) {
                  final photo = allPhotos[index];
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      File(photo.url),
                      fit: BoxFit.cover,
                      errorBuilder: (c, e, s) => Container(
                        color: Colors.grey[200],
                        child: const Icon(Icons.broken_image, size: 40, color: Colors.grey),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
} 