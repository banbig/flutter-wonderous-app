import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/photo_data_provider.dart';
import '../models/photo.dart';
import 'dart:io';

class AlbumPage extends StatelessWidget {
  const AlbumPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final photoProvider = context.watch<PhotoDataProvider>();
    final photoGroups = photoProvider.photoGroups;
    final List<Photo> allPhotos = photoGroups.expand((g) => g.photos).toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('相册', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.file_upload_outlined),
            tooltip: '导入本地照片',
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
                  const Text('暂无照片，请点击右上角"导入"按钮导入本地照片', style: TextStyle(color: Colors.grey, fontSize: 16)),
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