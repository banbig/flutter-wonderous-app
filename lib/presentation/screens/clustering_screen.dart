import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/photo_data_provider.dart';
import '../../models/photo_group.dart';
import '../../models/photo.dart';
import '../../widgets/photo_group_widget.dart';
import '../../presentation/providers/settings_view_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ClusteringScreen extends StatelessWidget {
  const ClusteringScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
      appBar: AppBar(
        title: Text(localizations.cleanTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(localizations.cleanFoundGroups(groups.length, totalPhotos), style: const TextStyle(fontSize: 16)),
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
                Text(localizations.cleanSelected(totalSelected, totalSelectedSize.toStringAsFixed(2)), style: const TextStyle(fontSize: 16)),
                ElevatedButton(
                  onPressed: totalSelected == 0
                      ? null
                      : () {
                          photoProvider.cleanSelectedPhotos();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(localizations.cleanDone)),
                          );
                        },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Text(localizations.cleanNow),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 