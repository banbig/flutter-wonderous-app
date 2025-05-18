import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/photo_data_provider.dart';
import '../models/photo.dart';

class RecommendedPage extends StatelessWidget {
  const RecommendedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final keptPhotos = context.watch<PhotoDataProvider>().allPhotosKeptAfterCleaning;
    return Scaffold(
      appBar: AppBar(
        title: const Text('推荐照片', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: keptPhotos.isEmpty
          ? const Center(
              child: Text('暂无推荐照片，请先完成一次清理操作。', style: TextStyle(color: Colors.grey, fontSize: 16)),
            )
          : Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '根据当前推荐标准，为您保留的照片如下：',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: GridView.builder(
                      itemCount: keptPhotos.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        childAspectRatio: 1,
                      ),
                      itemBuilder: (context, index) {
                        final photo = keptPhotos[index];
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            photo.url,
                            fit: BoxFit.cover,
                            errorBuilder: (c, e, s) => Container(
                              color: Colors.grey[200],
                              child: const Icon(Icons.broken_image, size: 40, color: Colors.grey),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
} 