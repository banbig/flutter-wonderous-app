import 'package:flutter/material.dart';
import '../../domain/entities/photo.dart';

class PhotoCardWidget extends StatelessWidget {
  final Photo photo;
  final bool selected;
  final VoidCallback onTap;

  const PhotoCardWidget({
    required this.photo,
    required this.selected,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: selected ? Colors.blue : Colors.grey[300]!,
                width: selected ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                photo.url,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
          ),
          if (photo.isBestCandidate)
            Positioned(
              left: 4,
              top: 4,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '最佳',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          Positioned(
            top: 4,
            right: 4,
            child: Checkbox(
              value: selected,
              onChanged: (_) => onTap(),
            ),
          ),
        ],
      ),
    );
  }
} 