import 'package:shared_preferences/shared_preferences.dart';
import '../../../domain/entities/recommendation_settings.dart';
import '../../../core/error/exceptions.dart';
import 'dart:convert';

abstract class LocalSettingsDataSource {
  Future<RecommendationSettings> getLastRecommendationSettings();
  Future<void> cacheRecommendationSettings(RecommendationSettings settings);
}

class LocalSettingsDataSourceImpl implements LocalSettingsDataSource {
  static const String _settingsKey = 'recommendation_settings';

  @override
  Future<RecommendationSettings> getLastRecommendationSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_settingsKey);
    if (jsonString != null) {
      final map = json.decode(jsonString) as Map<String, dynamic>;
      return _fromJson(map);
    } else {
      throw CacheException('No cached settings');
    }
  }

  @override
  Future<void> cacheRecommendationSettings(RecommendationSettings settings) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = json.encode(_toJson(settings));
    await prefs.setString(_settingsKey, jsonString);
  }

  Map<String, dynamic> _toJson(RecommendationSettings settings) {
    return {
      'mode': settings.mode.index,
      'topNValue': settings.topNValue,
      'criteria': settings.criteria.map((k, v) => MapEntry(k, {'enabled': v.enabled, 'weight': v.weight})),
    };
  }

  RecommendationSettings _fromJson(Map<String, dynamic> map) {
    return RecommendationSettings(
      mode: RecommendationMode.values[map['mode'] ?? 0],
      topNValue: map['topNValue'] ?? 1,
      criteria: (map['criteria'] as Map<String, dynamic>).map((k, v) => MapEntry(k, RecommendationCriterion(enabled: v['enabled'], weight: (v['weight'] as num).toDouble()))),
    );
  }
} 