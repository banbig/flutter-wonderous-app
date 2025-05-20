import 'package:flutter/material.dart';
import '../../domain/entities/photo_group.dart';
import '../../domain/entities/photo.dart';
import '../../domain/entities/recommendation_settings.dart';
import '../../domain/repositories/i_photo_repository.dart';
import '../../domain/use_cases/collection_management/get_photo_recommendations_use_case.dart';
import '../providers/settings_view_provider.dart';
import '../../domain/use_cases/storage_management/cleanup_photos_use_case.dart';
import 'package:logger/logger.dart';
import '../../providers/photo_data_provider.dart';
import 'package:provider/provider.dart';

class ClusteringViewProvider extends ChangeNotifier {
  final IPhotoRepository photoRepository;
  final GetPhotoRecommendationsUseCase getPhotoRecommendationsUseCase;
  final SettingsViewProvider settingsProvider;
  final CleanupPhotosUseCase cleanupPhotosUseCase;
  final Logger _logger = Logger();
  ClusteringViewProvider({
    required this.photoRepository,
    required this.getPhotoRecommendationsUseCase,
    required this.settingsProvider,
    required this.cleanupPhotosUseCase,
  }) {
    _logger.i('ClusteringViewProvider 构造: 初始化并同步 SettingsViewProvider');
    syncSmartSelectWithSettings();
  }

  @override
  void dispose() {
    _logger.i('ClusteringViewProvider dispose');
    super.dispose();
  }

  bool isLoading = false;
  String? error;
  Set<String> selectedPhotoIds = {};
  bool isSmartSelectEnabled = false;
  PhotoDataProvider? _photoDataProvider;

  set photoDataProvider(PhotoDataProvider provider) {
    _photoDataProvider = provider;
  }

  List<PhotoGroup> get displayedGroups => _photoDataProvider?.photoGroups ?? [];

  void syncSmartSelectWithSettings() {
    _logger.i('syncSmartSelectWithSettings: settingsProvider.smartSelectDefaultEnabled = $isSmartSelectEnabled');
    isSmartSelectEnabled = settingsProvider.smartSelectDefaultEnabled;
  }

  Future<void> fetchPhotoGroups(BuildContext context) async {
    isLoading = true;
    error = null;
    notifyListeners();
    final photoDataProvider = Provider.of<PhotoDataProvider>(context, listen: false);
    await _applyRecommendationToGroups();
    applySmartSelection();
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
    print('Provider setSmartSelectEnabled: $value');
    _logger.i('setSmartSelectEnabled: value = $value');
    isSmartSelectEnabled = value;
    settingsProvider.setSmartSelectDefaultEnabled(value);
    applySmartSelection();
    notifyListeners();
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
      await fetchPhotoGroups(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('清理成功')),
      );
    });
    isLoading = false;
    notifyListeners();
  }

  List<Photo> getBestPhotosInGroup(List<Photo> photos, RecommendationSettings settings) {
    List<Photo> sorted = List.from(photos);
    sorted.sort((a, b) => (b.recommendationScore ?? 0).compareTo(a.recommendationScore ?? 0));
    if (settings.mode == RecommendationMode.singleBest) {
      return sorted.isNotEmpty ? [sorted.first] : [];
    } else {
      int n = settings.topNValue.clamp(1, 5);
      return sorted.take(n).toList();
    }
  }
} 