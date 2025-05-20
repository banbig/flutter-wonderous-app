import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/photo_data_provider.dart';
import '../../domain/entities/photo_group.dart';
import '../../domain/entities/photo.dart';
import '../../widgets/photo_group_widget.dart';
import '../../presentation/providers/settings_view_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../presentation/providers/clustering_view_provider.dart';
import '../providers/photo_wall_provider.dart';

class ClusteringScreen extends StatelessWidget {
  const ClusteringScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('ClusteringScreen build');
    final localizations = AppLocalizations.of(context)!;
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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(localizations.cleanTitle, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black87)),
        centerTitle: true,
      ),
      body: Container(
        color: const Color(0xFFF3F6FA),
        child: Consumer<ClusteringViewProvider>(
          builder: (context, clusteringProvider, _) {
            print('Consumer rebuild: isSmartSelectEnabled = \x1b[32m"+clusteringProvider.isSmartSelectEnabled+"\x1b[0m');
            final isSmartSelectEnabled = clusteringProvider.isSmartSelectEnabled;
            final selected = clusteringProvider.selectedPhotoIds;
            final groups = clusteringProvider.displayedGroups;
            final totalPhotos = groups.fold<int>(0, (sum, g) => sum + g.photos.length);
            final totalSelected = selected.length;
            final totalSelectedSize = groups
                .expand((g) => g.photos)
                .where((p) => selected.contains(p.id))
                .fold<double>(0, (sum, p) => sum + p.size);
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(localizations.cleanFoundGroups(groups.length, totalPhotos), style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF232B3B))),
                      Row(
                        children: [
                          Text('智能选择', style: TextStyle(fontSize: 13, color: Color(0xFF6A7BFF), fontWeight: FontWeight.w600)),
                          const SizedBox(width: 6),
                          Switch(
                            value: isSmartSelectEnabled,
                            onChanged: (v) {
                              print('Switch onChanged: $v');
                              clusteringProvider.setSmartSelectEnabled(v);
                            },
                            activeColor: Color(0xFF6A7BFF),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.only(bottom: 12),
                    itemCount: groups.length,
                    itemBuilder: (context, idx) {
                      final group = groups[idx];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        elevation: 3,
                        shadowColor: Color(0x1A000000),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: PhotoGroupWidget(
                            group: group,
                            selectedPhotoIds: selected,
                            settings: settings,
                            onPhotoSelect: (photoId, selected) {
                              clusteringProvider.togglePhotoSelection(photoId);
                            },
                            getBestPhotos: (photos, [s]) => clusteringProvider.getBestPhotosInGroup(photos, s ?? settings),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8, top: 4),
                  child: Center(
                    child: SizedBox(
                      width: 340,
                      child: ElevatedButton.icon(
                        icon: Icon(Icons.wallpaper, color: Color(0xFF6A7BFF)),
                        label: Text('生成照片墙', style: TextStyle(fontSize: 15, color: Color(0xFF6A7BFF), fontWeight: FontWeight.w600)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shadowColor: Colors.transparent,
                          foregroundColor: Color(0xFF6A7BFF),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 0,
                        ),
                        onPressed: selected.isEmpty
                            ? null
                            : () async {
                                await showDialog(
                                  context: context,
                                  builder: (ctx) {
                                    int tempPhotoCount = selected.length.clamp(1, 36);
                                    double tempRandomness = 50.0;
                                    return StatefulBuilder(
                                      builder: (context, setState) {
                                        return AlertDialog(
                                          title: Text('照片墙参数设置'),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Row(
                                                children: [
                                                  Text('照片数量'),
                                                  Expanded(
                                                    child: Slider(
                                                      value: tempPhotoCount.toDouble(),
                                                      min: 1,
                                                      max: selected.length.toDouble().clamp(1, 36),
                                                      divisions: (selected.length > 1 ? selected.length - 1 : 1),
                                                      label: tempPhotoCount.toString(),
                                                      onChanged: (v) => setState(() => tempPhotoCount = v.round()),
                                                    ),
                                                  ),
                                                  Text('$tempPhotoCount'),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Text('布局随意度'),
                                                  Expanded(
                                                    child: Slider(
                                                      value: tempRandomness,
                                                      min: 0,
                                                      max: 100,
                                                      divisions: 20,
                                                      label: tempRandomness.toStringAsFixed(0),
                                                      onChanged: (v) => setState(() => tempRandomness = v),
                                                    ),
                                                  ),
                                                  Text('${tempRandomness.toStringAsFixed(0)}'),
                                                ],
                                              ),
                                            ],
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.pop(context),
                                              child: Text('取消'),
                                            ),
                                            ElevatedButton(
                                              onPressed: () async {
                                                final photoWallProvider = Provider.of<PhotoWallProvider>(context, listen: false);
                                                photoWallProvider.setPhotoCount(tempPhotoCount);
                                                photoWallProvider.setRandomness(tempRandomness);
                                                // 仅取选中的前N张图片
                                                final selectedList = selected.toList().take(tempPhotoCount).toList();
                                                await photoWallProvider.generatePhotoWall(selectedList);
                                                Navigator.pop(context);
                                              },
                                              child: Text('生成'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                );
                              },
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 18, top: 4),
                  child: Center(
                    child: Container(
                      width: 340,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [BoxShadow(color: Color(0x1A000000), blurRadius: 8, offset: Offset(0, 2))],
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(localizations.cleanSelected(totalSelected, totalSelectedSize.toStringAsFixed(2)), style: const TextStyle(fontSize: 13, color: Color(0xFF8A94A6), fontWeight: FontWeight.w600)),
                          DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF6A7BFF), Color(0xFF9F5FFF)],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [BoxShadow(color: Color(0x336A7BFF), blurRadius: 4, offset: Offset(0, 1))],
                            ),
                            child: ElevatedButton(
                              onPressed: totalSelected == 0
                                  ? null
                                  : () async {
                                      final confirm = await showDialog<bool>(
                                        context: context,
                                        builder: (ctx) => AlertDialog(
                                          title: Text('确认清除'),
                                          content: Text('确定要清除选中的照片吗？此操作不可恢复。'),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.of(ctx).pop(false),
                                              child: Text('取消'),
                                            ),
                                            ElevatedButton(
                                              onPressed: () => Navigator.of(ctx).pop(true),
                                              child: Text('确认'),
                                            ),
                                          ],
                                        ),
                                      );
                                      if (confirm == true) {
                                        await clusteringProvider.performCleanup(context);
                                      }
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                elevation: 0,
                              ),
                              child: Text(localizations.cleanNow, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
} 