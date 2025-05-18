import 'package:flutter/material.dart';

enum RecommendationMode { singleBest, topN }

class RecommendationSettings {
  RecommendationMode mode;
  int topN;
  Map<String, bool> enabledCriteria; // 标准启用状态
  Map<String, double> weights; // 标准权重
  bool smartSelectEnabled;

  RecommendationSettings({
    this.mode = RecommendationMode.singleBest,
    this.topN = 1,
    Map<String, bool>? enabledCriteria,
    Map<String, double>? weights,
    this.smartSelectEnabled = true,
  })  : enabledCriteria = enabledCriteria ?? {
          'clarity': true,
          'exposure': true,
          'faces': true,
          'composition': false,
          'colorfulness': false,
        },
        weights = weights ?? {
          'clarity': 1.0,
          'exposure': 1.0,
          'faces': 1.0,
          'composition': 1.0,
          'colorfulness': 1.0,
        };

  RecommendationSettings copyWith({
    RecommendationMode? mode,
    int? topN,
    Map<String, bool>? enabledCriteria,
    Map<String, double>? weights,
    bool? smartSelectEnabled,
  }) {
    return RecommendationSettings(
      mode: mode ?? this.mode,
      topN: topN ?? this.topN,
      enabledCriteria: enabledCriteria ?? Map.from(this.enabledCriteria),
      weights: weights ?? Map.from(this.weights),
      smartSelectEnabled: smartSelectEnabled ?? this.smartSelectEnabled,
    );
  }
} 