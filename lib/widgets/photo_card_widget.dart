import 'package:flutter/material.dart';
import '../models/photo.dart';
import 'dart:io';

class PhotoCardWidget extends StatelessWidget {
  final Photo photo;
  final bool isBest;
  final int? bestIndex; // Top-N时显示排名
  final bool isSelected;
  final ValueChanged<bool> onSelect;

  const PhotoCardWidget({
    Key? key,
    required this.photo,
    required this.isBest,
    this.bestIndex,
    required this.isSelected,
    required this.onSelect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onSelect(!isSelected),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: isSelected
                  ? Border.all(color: Theme.of(context).primaryColor, width: 2)
                  : null,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.file(
                File(photo.url),
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                errorBuilder: (c, e, s) => Container(
                  color: Colors.grey[200],
                  child: const Icon(Icons.broken_image, size: 32, color: Colors.grey),
                ),
              ),
            ),
          ),
          if (isBest)
            Positioned(
              left: 4,
              top: 4,
              child: bestIndex == null
                  ? const Icon(Icons.emoji_events, color: Colors.amber, size: 20)
                  : Chip(
                      label: Text('Top $bestIndex', style: const TextStyle(fontSize: 10)),
                      backgroundColor: Colors.amber.withOpacity(0.8),
                      padding: EdgeInsets.zero,
                    ),
            ),
          Positioned(
            right: 2,
            top: 2,
            child: Checkbox(
              value: isSelected,
              onChanged: (v) => onSelect(v ?? false),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
          if (isSelected)
            Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
        ],
      ),
    );
  }
} 