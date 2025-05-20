import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/photo_data_provider.dart';
import '../../domain/entities/photo.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_wonderous_app/core/constants/app_colors.dart';
import 'package:flutter_wonderous_app/core/constants/app_styles.dart';
import 'dart:io';

class RecommendedScreen extends StatelessWidget {
  const RecommendedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final keptPhotos = context.watch<PhotoDataProvider>().allPhotosKeptAfterCleaning;
    final localizations = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text('推荐保留的照片', style: AppStyles.headline),
      ),
      body: keptPhotos.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.photo_library_outlined, size: 64, color: AppColors.textSecondary),
                  const SizedBox(height: 16),
                  Text(
                    '尚未保留任何照片',
                    style: AppStyles.title,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '清理照片并保留推荐的照片后，它们会显示在这里',
                    style: AppStyles.caption,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.75,
              ),
              itemCount: keptPhotos.length,
              itemBuilder: (context, index) {
                final photo = keptPhotos[index];
                return _buildPhotoCard(photo);
              },
            ),
    );
  }

  Widget _buildPhotoCard(Photo photo) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Image.file(
                File(photo.url),
                fit: BoxFit.cover,
                width: double.infinity,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[300],
                    child: const Icon(Icons.broken_image, color: Colors.grey),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    photo.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '${photo.size.toStringAsFixed(2)} MB',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}