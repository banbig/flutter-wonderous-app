import 'package:flutter/material.dart';
import 'package:flutter_wonderous_app/domain/entities/photo.dart';

class PhotoCardWidget extends StatelessWidget {
  final Photo photo;
  final bool isSelected;
  final VoidCallback? onTap;

  const PhotoCardWidget({
    Key? key,
    required this.photo,
    this.isSelected = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 这里只是一个简单示例，实际可根据你的需求美化
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          // 假设 photo.url 是图片路径
          Image.network(photo.url, fit: BoxFit.cover, width: 100, height: 100),
          if (isSelected)
            Positioned(
              top: 4,
              right: 4,
              child: Icon(Icons.check_circle, color: Colors.blue),
            ),
        ],
      ),
    );
  }
} 