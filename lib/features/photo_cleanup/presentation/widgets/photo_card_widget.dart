import 'package:flutter/material.dart';
import 'package:flutter_wonderous_app/core/constants/app_colors.dart';
import 'package:flutter_wonderous_app/features/photo_cleanup/domain/entities/photo.dart';
import 'dart:io';

class PhotoCardWidget extends StatelessWidget {
  final Photo photo;
  final bool isBest;
  final bool isSelected;
  final int? bestIndex;
  final ValueChanged<bool> onSelect;

  const PhotoCardWidget({
    Key? key,
    required this.photo,
    required this.isBest,
    required this.isSelected,
    this.bestIndex,
    required this.onSelect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // 照片
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: InkWell(
            onTap: () => onSelect(!isSelected),
            child: Image.file(
              File(photo.url),
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[300],
                  child: const Icon(Icons.broken_image, color: Colors.grey),
                );
              },
            ),
          ),
        ),
        
        // 最佳照片指示器
        if (isBest)
          Positioned(
            top: 4,
            left: 4,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.8),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.star, color: Colors.white, size: 12),
                  if (bestIndex != null) ...[
                    const SizedBox(width: 2),
                    Text(
                      '$bestIndex',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        
        // 选择指示器
        Positioned(
          right: 4,
          top: 4,
          child: InkWell(
            onTap: () => onSelect(!isSelected),
            child: Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(11),
                border: Border.all(
                  color: isSelected ? AppColors.primary : Colors.grey.withOpacity(0.5),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: isSelected
                  ? const Icon(
                      Icons.check,
                      size: 16,
                      color: Colors.white,
                    )
                  : null,
            ),
          ),
        ),
      ],
    );
  }
}