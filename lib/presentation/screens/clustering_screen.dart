import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/photo_data_provider.dart';
import '../../domain/entities/photo_group.dart';
import '../../domain/entities/photo.dart';
import '../../widgets/photo_group_widget.dart';
import '../../presentation/providers/settings_view_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../presentation/providers/clustering_view_provider.dart';

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
                                  : () {
                                      clusteringProvider.performCleanup(context);
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