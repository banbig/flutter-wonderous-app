import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'dart:io';

/// 照片大图预览页面，支持缩放和拖拽
class PhotoPreviewPage extends StatelessWidget {
  final String imageUrl;
  final String? title;

  const PhotoPreviewPage({Key? key, required this.imageUrl, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: title != null ? Text(title!) : null,
      ),
      body: Center(
        child: PhotoView(
          imageProvider: imageUrl.startsWith('http')
              ? NetworkImage(imageUrl)
              : FileImage(File(imageUrl)) as ImageProvider,
          backgroundDecoration: const BoxDecoration(color: Colors.black),
          minScale: PhotoViewComputedScale.contained,
          maxScale: PhotoViewComputedScale.covered * 2.5,
        ),
      ),
    );
  }
} 