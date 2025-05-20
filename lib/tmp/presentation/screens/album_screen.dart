import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/photo_data_provider.dart';
import '../../domain/entities/photo.dart';
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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(localizations.albumTitle, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black87)),
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
      body: Container(
        color: const Color(0xFFF3F6FA),
        child: allPhotos.isEmpty
            ? Center(
                child: Card(
                  elevation: 8,
                  shadowColor: Color(0x1A000000),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.photo_library_outlined, size: 48, color: Color(0xFFB0B8C9)),
                        const SizedBox(height: 16),
                        Text(localizations.albumEmpty, style: const TextStyle(color: Color(0xFF8A94A6), fontSize: 15, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(12.0),
                child: GridView.builder(
                  itemCount: allPhotos.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1,
                  ),
                  itemBuilder: (context, index) {
                    final photo = allPhotos[index];
                    return Material(
                      elevation: 3,
                      borderRadius: BorderRadius.circular(16),
                      shadowColor: Color(0x1A000000),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.file(
                          File(photo.url),
                          fit: BoxFit.cover,
                          errorBuilder: (c, e, s) => Container(
                            color: Colors.grey[200],
                            child: const Icon(Icons.broken_image, size: 32, color: Colors.grey),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
      ),
    );
  }
} 