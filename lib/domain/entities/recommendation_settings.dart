enum RecommendationMode { singleBest, topN }

class RecommendationCriterion {
  bool enabled;
  double weight;
  RecommendationCriterion({required this.enabled, required this.weight});
}

class RecommendationSettings {
  RecommendationMode mode;
  int topNValue;
  Map<String, RecommendationCriterion> criteria;
  bool smartSelectDefaultEnabled;

  RecommendationSettings({
    this.mode = RecommendationMode.singleBest,
    this.topNValue = 1,
    Map<String, RecommendationCriterion>? criteria,
    this.smartSelectDefaultEnabled = true,
  }) : criteria = criteria ?? {
    'clarity': RecommendationCriterion(enabled: true, weight: 1.0),
    '曝光': RecommendationCriterion(enabled: true, weight: 1.0),
    'faces': RecommendationCriterion(enabled: true, weight: 1.0),
    'composition': RecommendationCriterion(enabled: true, weight: 1.0),
    'colorfulness': RecommendationCriterion(enabled: true, weight: 1.0),
  };
} 