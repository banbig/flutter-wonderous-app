import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_view_provider.dart';
import '../../domain/entities/recommendation_settings.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../providers/locale_provider.dart';
import '../../widgets/settings_criteria_item_widget.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _topNController = TextEditingController();

  @override
  void dispose() {
    _topNController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    Locale currentLocale = Localizations.localeOf(context);
    return Consumer<SettingsViewProvider>(
      builder: (context, provider, _) {
        final RecommendationSettings settings = provider.settings;
        _topNController.text = settings.topNValue.toString();
        return Scaffold(
          appBar: AppBar(title: Text(localizations.settingsTitle)),
          body: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(localizations.recommendationCriteria, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<RecommendationMode>(
                          value: settings.mode,
                          decoration: InputDecoration(labelText: localizations.recommendationMode),
                          items: [
                            DropdownMenuItem(
                              value: RecommendationMode.singleBest,
                              child: Text(localizations.singleBest),
                            ),
                            DropdownMenuItem(
                              value: RecommendationMode.topN,
                              child: Text(localizations.topN),
                            ),
                          ],
                          onChanged: (v) {
                            if (v != null) provider.setMode(v);
                          },
                        ),
                        if (settings.mode == RecommendationMode.topN)
                          Padding(
                            padding: const EdgeInsets.only(top: 12.0),
                            child: TextFormField(
                              controller: _topNController,
                              decoration: InputDecoration(labelText: localizations.topNValue),
                              keyboardType: TextInputType.number,
                              validator: (val) {
                                final n = int.tryParse(val ?? '');
                                if (n == null || n < 1) {
                                  return localizations.topNValue;
                                }
                                return null;
                              },
                              onChanged: (val) {
                                final n = int.tryParse(val) ?? 1;
                                provider.setTopNValue(n);
                              },
                            ),
                          ),
                        const SizedBox(height: 16),
                        ...settings.criteria.keys.map((key) {
                          final criterion = settings.criteria[key]!;
                          return SettingsCriteriaItemWidget(
                            label: _criterionName(key, localizations),
                            enabled: criterion.enabled,
                            weight: criterion.weight,
                            onEnabledChanged: (v) => provider.setCriterionEnabled(key, v),
                            onWeightChanged: (v) => provider.setCriterionWeight(key, v),
                          );
                        }).toList(),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                await provider.saveSettings();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(localizations.applySettings)),
                                );
                              }
                            },
                            child: Text(localizations.applySettings),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: ListTile(
                    title: Text(localizations.smartSelectDefault),
                    trailing: Switch(value: true, onChanged: (_) {}),
                  ),
                ),
                Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      children: [
                        const Icon(Icons.language),
                        const SizedBox(width: 12),
                        Text(localizations.language),
                        const Spacer(),
                        DropdownButton<Locale>(
                          value: currentLocale,
                          items: [
                            DropdownMenuItem(
                              value: const Locale('zh', 'CN'),
                              child: Text(localizations.chinese),
                            ),
                            DropdownMenuItem(
                              value: const Locale('en', 'US'),
                              child: Text(localizations.english),
                            ),
                          ],
                          onChanged: (locale) {
                            if (locale != null) {
                              context.read<LocaleProvider>().setLocale(locale);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Card(
                  child: ListTile(
                    title: Text(localizations.version),
                    subtitle: const Text('1.0.0'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _criterionName(String key, AppLocalizations localizations) {
    switch (key) {
      case 'clarity':
        return localizations.clarity;
      case 'exposure':
        return localizations.exposure;
      case 'faces':
        return localizations.faces;
      case 'composition':
        return localizations.composition;
      case 'colorfulness':
        return localizations.colorfulness;
      default:
        return key;
    }
  }
} 