import 'package:flutter/material.dart';
import '../../domain/entities/photo_group.dart';
import 'photo_card_widget.dart';

class PhotoGroupWidget extends StatelessWidget {
  final PhotoGroup photoGroup;
  final Set<String> selectedPhotoIds;
  final void Function(String) onPhotoTap;

  const PhotoGroupWidget({
    required this.photoGroup,
    required this.selectedPhotoIds,
    required this.onPhotoTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Text(
            '${photoGroup.date.year}-${photoGroup.date.month.toString().padLeft(2, '0')}-${photoGroup.date.day.toString().padLeft(2, '0')}',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: photoGroup.photos.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 1,
          ),
          padding: EdgeInsets.symmetric(horizontal: 16),
          itemBuilder: (context, index) {
            final photo = photoGroup.photos[index];
            return PhotoCardWidget(
              photo: photo,
              selected: selectedPhotoIds.contains(photo.id),
              onTap: () => onPhotoTap(photo.id),
            );
          },
        ),
      ],
    );
  }
} 