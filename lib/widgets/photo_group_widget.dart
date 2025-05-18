import 'package:flutter/material.dart';
import '../models/photo_group.dart';
import '../models/photo.dart';
import '../models/recommendation_settings.dart';
import 'photo_card_widget.dart';

class PhotoGroupWidget extends StatelessWidget {
  final PhotoGroup group;
  final Set<String> selectedPhotoIds;
  final RecommendationSettings settings;
  final void Function(String photoId, bool selected) onPhotoSelect;
  final List<Photo> Function(List<Photo> photos) getBestPhotos;

  const PhotoGroupWidget({
    Key? key,
    required this.group,
    required this.selectedPhotoIds,
    required this.settings,
    required this.onPhotoSelect,
    required this.getBestPhotos,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bestPhotos = getBestPhotos(group.photos);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(group.date, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text('共${group.photos.length}张', style: const TextStyle(color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 8),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: group.photos.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 6,
                mainAxisSpacing: 6,
                childAspectRatio: 1,
              ),
              itemBuilder: (context, idx) {
                final photo = group.photos[idx];
                final isBest = bestPhotos.contains(photo);
                final isSelected = selectedPhotoIds.contains(photo.id);
                return PhotoCardWidget(
                  photo: photo,
                  isBest: isBest,
                  isSelected: isSelected,
                  bestIndex: isBest && bestPhotos.length > 1 ? bestPhotos.indexOf(photo) + 1 : null,
                  onSelect: (selected) => onPhotoSelect(photo.id, selected),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
} 