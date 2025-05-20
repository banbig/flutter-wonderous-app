import 'package:flutter/foundation.dart';
import 'package:flutter_wonderous_app/features/settings/domain/entities/index.dart';
import 'package:flutter_wonderous_app/features/settings/domain/repositories/i_settings_repository.dart';

class SettingsViewProvider extends ChangeNotifier {
  final Object repository;
  RecommendationSettings _settings;

  SettingsViewProvider({
    required this.repository,
  }) : _settings = RecommendationSettings.defaultSettings() {
    _loadSettings();
  }

  RecommendationSettings get settings => _settings;

  Future<void> _loadSettings() async {
    // 简化版本，直接使用默认设置
    _settings = RecommendationSettings.defaultSettings();
    notifyListeners();
  }

  void updateMode(RecommendationMode mode) {
    if (_settings.mode == mode) return;
    _settings = _settings.copyWith(mode: mode);
    _saveSettings();
    notifyListeners();
  }

  void updateTopNValue(int value) {
    if (_settings.topNValue == value) return;
    _settings = _settings.copyWith(topNValue: value);
    _saveSettings();
    notifyListeners();
  }

  void toggleCriterion(String key, bool enabled) {
    if (!_settings.criteria.containsKey(key)) return;
    
    final updatedCriteria = Map<String, RecommendationCriterion>.from(_settings.criteria);
    updatedCriteria[key] = RecommendationCriterion(
      enabled: enabled,
      weight: _settings.criteria[key]!.weight,
    );
    
    _settings = _settings.copyWith(criteria: updatedCriteria);
    _saveSettings();
    notifyListeners();
  }

  void updateCriterionWeight(String key, double weight) {
    if (!_settings.criteria.containsKey(key)) return;
    
    final updatedCriteria = Map<String, RecommendationCriterion>.from(_settings.criteria);
    updatedCriteria[key] = RecommendationCriterion(
      enabled: _settings.criteria[key]!.enabled,
      weight: weight,
    );
    
    _settings = _settings.copyWith(criteria: updatedCriteria);
    _saveSettings();
    notifyListeners();
  }

  void resetToDefaults() {
    _settings = RecommendationSettings.defaultSettings();
    _saveSettings();
    notifyListeners();
  }

  Future<void> _saveSettings() async {
    // 简化版本，不实际保存
  }
}