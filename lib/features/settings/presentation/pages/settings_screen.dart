import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'package:flutter_wonderous_app/core/constants/app_colors.dart';
import 'package:flutter_wonderous_app/core/constants/app_styles.dart';
import 'package:flutter_wonderous_app/features/settings/presentation/providers/settings_view_provider.dart';
import 'package:flutter_wonderous_app/features/settings/domain/entities/recommendation_settings.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final provider = Provider.of<SettingsViewProvider>(context);
    
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          localizations.settingsTitle, 
          style: AppStyles.headline
        ),
        centerTitle: true,
      ),
      body: Container(
        color: AppColors.background,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          children: [
            const SizedBox(height: 16),
            // 模式选择
            Card(
              elevation: 2,
              shadowColor: AppColors.shadow,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(localizations.settingsRecommendationMode, style: AppStyles.subtitle),
                    const SizedBox(height: 16),
                    RadioListTile<RecommendationMode>(
                      title: Text(localizations.settingsSingleBestMode),
                      subtitle: Text(localizations.settingsSingleBestDesc, style: AppStyles.caption),
                      value: RecommendationMode.singleBest,
                      groupValue: provider.settings.mode,
                      onChanged: (val) => provider.updateMode(val!),
                      activeColor: AppColors.primary,
                      contentPadding: EdgeInsets.zero,
                    ),
                    RadioListTile<RecommendationMode>(
                      title: Text(localizations.settingsTopNMode),
                      subtitle: Text(localizations.settingsTopNDesc, style: AppStyles.caption),
                      value: RecommendationMode.topN,
                      groupValue: provider.settings.mode,
                      onChanged: (val) => provider.updateMode(val!),
                      activeColor: AppColors.primary,
                      contentPadding: EdgeInsets.zero,
                    ),
                    if (provider.settings.mode == RecommendationMode.topN)
                      Padding(
                        padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
                        child: Row(
                          children: [
                            Text(localizations.settingsKeepCount),
                            Expanded(
                              child: Slider(
                                value: provider.settings.topNValue.toDouble(),
                                min: 1,
                                max: 5,
                                divisions: 4,
                                label: provider.settings.topNValue.toString(),
                                onChanged: (val) => provider.updateTopNValue(val.toInt()),
                                activeColor: AppColors.primary,
                              ),
                            ),
                            Text('${provider.settings.topNValue}'),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(localizations.settingsCriteria, style: AppStyles.subtitle),
            const SizedBox(height: 8),
            // 标准列表
            Card(
              elevation: 2,
              shadowColor: AppColors.shadow,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildCriteriaItem(
                      context,
                      key: 'clarity',
                      title: localizations.settingsClarity,
                      subtitle: localizations.settingsClarityDesc,
                      provider: provider,
                    ),
                    const Divider(),
                    _buildCriteriaItem(
                      context,
                      key: 'exposure',
                      title: localizations.settingsExposure,
                      subtitle: localizations.settingsExposureDesc,
                      provider: provider,
                    ),
                    const Divider(),
                    _buildCriteriaItem(
                      context,
                      key: 'faces',
                      title: localizations.settingsFaces,
                      subtitle: localizations.settingsFacesDesc,
                      provider: provider,
                    ),
                    const Divider(),
                    _buildCriteriaItem(
                      context,
                      key: 'composition',
                      title: localizations.settingsComposition,
                      subtitle: localizations.settingsCompositionDesc,
                      provider: provider,
                    ),
                    const Divider(),
                    _buildCriteriaItem(
                      context,
                      key: 'colorfulness',
                      title: localizations.settingsColorfulness,
                      subtitle: localizations.settingsColorfulnessDesc,
                      provider: provider,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: OutlinedButton(
                onPressed: () => provider.resetToDefaults(),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: BorderSide(color: AppColors.primary),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                ),
                child: Text(localizations.settingsReset),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildCriteriaItem(
    BuildContext context, {
    required String key,
    required String title,
    required String subtitle,
    required SettingsViewProvider provider,
  }) {
    final criterion = provider.settings.criteria[key]!;
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(title, style: AppStyles.title),
                    const SizedBox(width: 8),
                    Switch(
                      value: criterion.enabled,
                      onChanged: (val) => provider.toggleCriterion(key, val),
                      activeColor: AppColors.primary,
                    ),
                  ],
                ),
                Text(subtitle, style: AppStyles.caption),
              ],
            ),
          ),
          if (criterion.enabled)
            SizedBox(
              width: 100,
              child: Slider(
                value: criterion.weight,
                min: 0.1,
                max: 1.0,
                divisions: 9,
                label: criterion.weight.toStringAsFixed(1),
                onChanged: (val) => provider.updateCriterionWeight(key, val),
                activeColor: AppColors.primary,
              ),
            ),
        ],
      ),
    );
  }
}
