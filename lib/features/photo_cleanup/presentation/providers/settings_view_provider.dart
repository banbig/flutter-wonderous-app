import 'package:flutter/material.dart';
import '../../domain/entities/recommendation_settings.dart';

class SettingsViewProvider extends ChangeNotifier {
  RecommendationSettings settings = RecommendationSettings.defaultSettings();

  void updateSetting(RecommendationSettings newSettings) {
    settings = newSettings;
    notifyListeners();
  }
} 