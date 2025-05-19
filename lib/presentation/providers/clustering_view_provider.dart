import 'package:flutter/material.dart';
import '../../domain/entities/photo_group.dart';
import '../../domain/repositories/i_photo_repository.dart';
import '../../domain/entities/recommendation_settings.dart';
import '../../domain/use_cases/collection_management/get_photo_recommendations_use_case.dart';
import '../providers/settings_view_provider.dart';
import '../../domain/use_cases/storage_management/cleanup_photos_use_case.dart';

class ClusteringViewProvider extends ChangeNotifier {
  final IPhotoRepository photoRepository;
  final GetPhotoRecommendationsUseCase getPhotoRecommendationsUseCase;
  final SettingsViewProvider settingsProvider;
  final CleanupPhotosUseCase cleanupPhotosUseCase;
  ClusteringViewProvider({
    required this.photoRepository,
    required this.getPhotoRecommendationsUseCase,
    required this.settingsProvider,
    required this.cleanupPhotosUseCase,
  });

  bool isLoading = false;
  String? error;
  List<PhotoGroup> displayedGroups = [];
  Set<String> selectedPhotoIds = {};
  bool isSmartSelectEnabled = false;

  Future<void> fetchPhotoGroups() async {
    isLoading = true;
    error = null;
    notifyListeners();
    final result = await photoRepository.getPhotoGroups(settings: settingsProvider.settings);
    result.fold((failure) {
      error = failure.message;
      displayedGroups = [];
    }, (groups) async {
      displayedGroups = groups;
      await _applyRecommendationToGroups();
      applySmartSelection();
    });
    isLoading = false;
    notifyListeners();
  }

  Future<void> _applyRecommendationToGroups() async {
    for (var group in displayedGroups) {
      await getPhotoRecommendationsUseCase.call(
        GetRecommendationsParams(
          photosInGroup: group.photos,
          settings: settingsProvider.settings,
        ),
      );
    }
  }

  void applySmartSelection() {
    selectedPhotoIds.clear();
    if (isSmartSelectEnabled) {
      for (var group in displayedGroups) {
        for (var photo in group.photos) {
          if (!photo.isBestCandidate) {
            selectedPhotoIds.add(photo.id);
          }
        }
      }
    }
    notifyListeners();
  }

  void togglePhotoSelection(String photoId) {
    if (selectedPhotoIds.contains(photoId)) {
      selectedPhotoIds.remove(photoId);
    } else {
      selectedPhotoIds.add(photoId);
    }
    notifyListeners();
  }

  void setSmartSelectEnabled(bool value) {
    isSmartSelectEnabled = value;
    applySmartSelection();
  }

  Future<void> performCleanup(BuildContext context) async {
    if (selectedPhotoIds.isEmpty) return;
    isLoading = true;
    notifyListeners();
    final result = await cleanupPhotosUseCase.call(
      CleanupPhotosParams(photoIdsToClean: selectedPhotoIds.toList()),
    );
    result.fold((failure) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('清理失败：${failure.message}')),
      );
    }, (_) async {
      selectedPhotoIds.clear();
      await fetchPhotoGroups();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('清理成功')),
      );
    });
    isLoading = false;
    notifyListeners();
  }
} 