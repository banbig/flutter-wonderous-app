import 'package:flutter/material.dart';
import 'package:flutter_wonderous_app/features/photo_cleanup/domain/entities/photo_group.dart';
import 'package:flutter_wonderous_app/features/photo_cleanup/domain/entities/photo.dart';
import 'package:flutter_wonderous_app/features/settings/domain/entities/recommendation_settings.dart';
import 'package:intl/intl.dart';
import 'photo_card_widget.dart';

class PhotoGroupWidget extends StatelessWidget {
  final PhotoGroup group;
  final Set<String> selectedPhotoIds;
  final RecommendationSettings settings;
  final void Function(String photoId, bool selected) onPhotoSelect;
  final List<Photo> Function(List<Photo> photos, [RecommendationSettings? settings]) getBestPhotos;

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
    final bestPhotos = getBestPhotos(group.photos, settings);
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
                Text(DateFormat('yyyy-MM-dd').format(group.date), style: const TextStyle(fontWeight: FontWeight.bold)),
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