import 'package:flutter/material.dart';
import '../domain/entities/photo_group.dart';
import '../domain/entities/photo.dart';
import '../domain/entities/recommendation_settings.dart';

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            '分组日期: ${group.date.toLocal().toString().split(" ")[0]}',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: group.photos.length,
          itemBuilder: (context, index) {
            final photo = group.photos[index];
            final isSelected = selectedPhotoIds.contains(photo.id);
            final isBest = bestPhotos.contains(photo);
            return ListTile(
              leading: Icon(
                isBest ? Icons.star : Icons.photo,
                color: isBest ? Colors.amber : null,
              ),
              title: Text(photo.name),
              subtitle: Text('${photo.size.toStringAsFixed(2)} MB'),
              trailing: Checkbox(
                value: isSelected,
                onChanged: (v) => onPhotoSelect(photo.id, v ?? false),
              ),
              onTap: () => onPhotoSelect(photo.id, !isSelected),
            );
          },
        ),
      ],
    );
  }
} 