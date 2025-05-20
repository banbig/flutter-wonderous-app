import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/photo_data_provider.dart';
import '../../domain/entities/photo.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RecommendedScreen extends StatelessWidget {
  const RecommendedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final keptPhotos = context.watch<PhotoDataProvider>().allPhotosKeptAfterCleaning;
    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.recommendTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: keptPhotos.isEmpty
          ? Center(
              child: Text(localizations.recommendEmpty, style: const TextStyle(color: Colors.grey, fontSize: 16)),
            )
          : Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    localizations.recommendDesc,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
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