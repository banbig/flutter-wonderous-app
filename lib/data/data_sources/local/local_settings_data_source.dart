import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter_wonderous_app/features/settings/domain/entities/recommendation_settings.dart';

abstract class LocalSettingsDataSource {
  Future<RecommendationSettings> getRecommendationSettings();
  Future<void> saveRecommendationSettings(RecommendationSettings settings);
}

class LocalSettingsDataSourceImpl implements LocalSettingsDataSource {
  static const String _settingsKey = 'recommendation_settings';
  
  @override
  Future<RecommendationSettings> getRecommendationSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final settingsJson = prefs.getString(_settingsKey);
    
    if (settingsJson == null) {
      return RecommendationSettings.defaultSettings();
    }
    
    try {
      final Map<String, dynamic> settingsMap = json.decode(settingsJson);
      
      // 简单实现，实际项目中可能需要更复杂的反序列化逻辑
      final mode = settingsMap['mode'] == 'singleBest' 
          ? RecommendationMode.singleBest 
          : RecommendationMode.topN;
      
      final topNValue = settingsMap['topNValue'] as int? ?? 3;
      
      final criteriaMap = Map<String, RecommendationCriterion>.from(
        (settingsMap['criteria'] as Map<String, dynamic>).map(
          (key, value) => MapEntry(
            key,
            RecommendationCriterion(
              enabled: value['enabled'] as bool,
              weight: (value['weight'] as num).toDouble(),
            ),
          ),
        ),
      );
      
      return RecommendationSettings(
        mode: mode,
        topNValue: topNValue,
        criteria: criteriaMap,
      );
    } catch (e) {
      // 如果解析失败，返回默认设置
      return RecommendationSettings.defaultSettings();
    }
  }
  
  @override
  Future<void> saveRecommendationSettings(RecommendationSettings settings) async {
    final prefs = await SharedPreferences.getInstance();
    
    // 简单实现，实际项目中可能需要更复杂的序列化逻辑
    final settingsMap = {
      'mode': settings.mode == RecommendationMode.singleBest ? 'singleBest' : 'topN',
      'topNValue': settings.topNValue,
      'criteria': settings.criteria.map(
        (key, value) => MapEntry(
          key,
          {
            'enabled': value.enabled,
            'weight': value.weight,
          },
        ),
      ),
    };
    
    final settingsJson = json.encode(settingsMap);
    await prefs.setString(_settingsKey, settingsJson);
  }
}