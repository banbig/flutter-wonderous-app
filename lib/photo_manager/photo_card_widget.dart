import 'package:flutter/material.dart';
import 'photo.dart';
import 'dart:io';

/// 单张照片卡片组件，支持选中/取消选中和大图预览
class PhotoCardWidget extends StatelessWidget {
  final Photo photo;
  final VoidCallback onTap;
  final VoidCallback? onPreview;

  const PhotoCardWidget({Key? key, required this.photo, required this.onTap, this.onPreview}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: onPreview,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: photo.isSelected ? Theme.of(context).colorScheme.primary : Colors.grey.shade300,
                width: photo.isSelected ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: _fileOrNetworkImage(photo.url),
            ),
          ),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: GestureDetector(
            onTap: onTap,
            child: Icon(
              photo.isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
              color: photo.isSelected ? Theme.of(context).colorScheme.primary : Colors.white,
              size: 24,
              shadows: [Shadow(color: Colors.black.withOpacity(0.2), blurRadius: 2)],
            ),
          ),
        ),
        Positioned(
          left: 8,
          bottom: 8,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              photo.name,
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _fileOrNetworkImage(String url) {
    if (url.startsWith('http')) {
      return Image.network(
        url,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (c, e, s) => Container(
          color: Colors.grey.shade200,
          child: const Icon(Icons.broken_image, size: 40, color: Colors.grey),
        ),
      );
    } else if (url.isNotEmpty) {
      return Image.file(
        File(url),
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (c, e, s) => Container(
          color: Colors.grey.shade200,
          child: const Icon(Icons.broken_image, size: 40, color: Colors.grey),
        ),
      );
    } else {
      return Container(
        color: Colors.grey.shade200,
        child: const Icon(Icons.broken_image, size: 40, color: Colors.grey),
      );
    }
  }
} 