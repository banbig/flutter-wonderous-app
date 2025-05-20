import 'package:flutter/material.dart';
import '../../domain/entities/recommendation_settings.dart';
import '../../domain/repositories/i_settings_repository.dart';

class SettingsViewProvider extends ChangeNotifier {
  final ISettingsRepository repository;
  SettingsViewProvider({required this.repository}) {
    loadSettings();
  }

  RecommendationSettings _settings = RecommendationSettings();
  RecommendationSettings get settings => _settings;

  RecommendationMode get currentMode => _settings.mode;
  int get topNValue => _settings.topNValue;

  bool isCriterionEnabled(String key) => _settings.criteria[key]?.enabled ?? false;
  double getCriterionWeight(String key) => _settings.criteria[key]?.weight ?? 0.0;

  bool get smartSelectDefaultEnabled => _settings.smartSelectDefaultEnabled;
  void setSmartSelectDefaultEnabled(bool value) {
    _settings.smartSelectDefaultEnabled = value;
    saveSettings();
    notifyListeners();
  }

  Future<void> loadSettings() async {
    final result = await repository.getRecommendationSettings();
    result.fold((failure) {
      // 可以设置错误状态
    }, (settings) {
      _settings = settings;
      notifyListeners();
    });
  }

  Future<void> saveSettings() async {
    final result = await repository.saveRecommendationSettings(_settings);
    result.fold((failure) {
      // 可以设置错误状态
    }, (_) {
      // 保存成功
    });
  }

  void setMode(RecommendationMode mode) {
    _settings.mode = mode;
    saveSettings();
    notifyListeners();
  }

  void setTopNValue(int value) {
    _settings.topNValue = value;
    saveSettings();
    notifyListeners();
  }

  void setCriterionEnabled(String key, bool enabled) {
    if (_settings.criteria.containsKey(key)) {
      _settings.criteria[key]!.enabled = enabled;
      saveSettings();
      notifyListeners();
    }
  }

  void setCriterionWeight(String key, double weight) {
    if (_settings.criteria.containsKey(key)) {
      _settings.criteria[key]!.weight = weight;
      saveSettings();
      notifyListeners();
    }
  }
} 