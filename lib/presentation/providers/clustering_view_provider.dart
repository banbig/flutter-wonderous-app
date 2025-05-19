import 'package:flutter/material.dart';
import '../../domain/entities/photo_group.dart';
import '../../domain/repositories/i_photo_repository.dart';

class ClusteringViewProvider extends ChangeNotifier {
  final IPhotoRepository photoRepository;
  ClusteringViewProvider({required this.photoRepository});

  bool isLoading = false;
  String? error;
  List<PhotoGroup> displayedGroups = [];
  Set<String> selectedPhotoIds = {};
  bool isSmartSelectEnabled = false;

  Future<void> fetchPhotoGroups() async {
    isLoading = true;
    error = null;
    notifyListeners();
    final result = await photoRepository.getPhotoGroups();
    result.fold((failure) {
      error = failure.message;
      displayedGroups = [];
    }, (groups) {
      displayedGroups = groups;
    });
    isLoading = false;
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
    notifyListeners();
  }
} 