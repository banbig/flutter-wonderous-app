import 'package:flutter/material.dart';
import '../models/recommendation_settings.dart';

class RecommendationSettingsProvider extends ChangeNotifier {
  RecommendationSettings _settings = RecommendationSettings();
  RecommendationSettings get settings => _settings;

  void updateSettings(RecommendationSettings newSettings) {
    _settings = newSettings;
    notifyListeners();
  }

  void updateSmartSelect(bool enabled) {
    _settings = _settings.copyWith(smartSelectEnabled: enabled);
    notifyListeners();
  }
} 