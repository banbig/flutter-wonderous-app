import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/photo_data_provider.dart';
import '../models/photo_group.dart';
import '../models/photo.dart';
import '../widgets/photo_group_widget.dart';
import '../presentation/providers/settings_view_provider.dart';

class ClusteringPage extends StatelessWidget {
  const ClusteringPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final photoProvider = context.watch<PhotoDataProvider>();
    final settings = context.watch<SettingsViewProvider>().settings;
    final groups = photoProvider.photoGroups;
    final selected = photoProvider.selectedPhotos;
    final totalPhotos = groups.fold<int>(0, (sum, g) => sum + g.photos.length);
    final totalSelected = selected.length;
    final totalSelectedSize = groups
        .expand((g) => g.photos)
        .where((p) => selected.contains(p.id))
        .fold<double>(0, (sum, p) => sum + p.size);
    return Scaffold(
      appBar: AppBar(
        title: const Text('相似照片清理', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('发现 ${groups.length} 组, 共 $totalPhotos 张照片', style: const TextStyle(fontSize: 16)),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: groups.length,
              itemBuilder: (context, idx) {
                final group = groups[idx];
                return PhotoGroupWidget(
                  group: group,
                  selectedPhotoIds: selected,
                  settings: settings,
                  onPhotoSelect: (photoId, selected) {
                    photoProvider.selectPhoto(photoId, selected);
                  },
                  getBestPhotos: (photos) => photoProvider.getBestPhotosInGroup(photos, settings),
                );
              },
            ),
          ),
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('已选 $totalSelected 张, 共 ${totalSelectedSize.toStringAsFixed(2)} MB', style: const TextStyle(fontSize: 16)),
                ElevatedButton(
                  onPressed: totalSelected == 0
                      ? null
                      : () {
                          photoProvider.cleanSelectedPhotos();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('清理完成！已移除选中照片。')),
                          );
                        },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('立即清理'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 