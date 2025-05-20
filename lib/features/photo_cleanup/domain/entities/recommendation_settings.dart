class RecommendationCriterion {
  final bool enabled;
  final double weight;

  RecommendationCriterion({
    required this.enabled,
    required this.weight,
  });
}

enum RecommendationMode {
  singleBest,
  topN,
}

class RecommendationSettings {
  final RecommendationMode mode;
  final int topNValue;
  final Map<String, RecommendationCriterion> criteria;

  RecommendationSettings({
    required this.mode,
    required this.topNValue,
    required this.criteria,
  });

  factory RecommendationSettings.defaultSettings() {
    return RecommendationSettings(
      mode: RecommendationMode.singleBest,
      topNValue: 3,
      criteria: {
        'clarity': RecommendationCriterion(enabled: true, weight: 1.0),
        'exposure': RecommendationCriterion(enabled: true, weight: 0.8),
        'faces': RecommendationCriterion(enabled: true, weight: 1.0),
        'composition': RecommendationCriterion(enabled: true, weight: 0.7),
        'colorfulness': RecommendationCriterion(enabled: true, weight: 0.6),
      },
    );
  }

  RecommendationSettings copyWith({
    RecommendationMode? mode,
    int? topNValue,
    Map<String, RecommendationCriterion>? criteria,
  }) {
    return RecommendationSettings(
      mode: mode ?? this.mode,
      topNValue: topNValue ?? this.topNValue,
      criteria: criteria ?? this.criteria,
    );
  }
}