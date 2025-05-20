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
    final settingsProvider = Provider.of<SettingsViewProvider>(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(localizations.settingsTitle, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black87)),
        centerTitle: true,
      ),
      body: Container(
        color: const Color(0xFFF3F6FA),
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 24),
          children: [
            Center(
              child: Card(
                elevation: 10,
                shadowColor: const Color(0x1A000000),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(localizations.recommendationCriteria, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF232B3B))),
                      const SizedBox(height: 4),
                      Text('调整各项参数的权重，找到最适合你的推荐标准。', style: TextStyle(fontSize: 14, color: Color(0xFF8A94A6), fontWeight: FontWeight.w400)),
                      const SizedBox(height: 18),
                      DropdownButtonFormField<RecommendationMode>(
                        value: settingsProvider.settings.mode,
                        decoration: InputDecoration(
                          labelText: localizations.recommendationMode,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Color(0xFF6A7BFF))),
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        ),
                        icon: Icon(Icons.keyboard_arrow_down, color: Color(0xFF6A7BFF)),
                        dropdownColor: Colors.white,
                        style: const TextStyle(fontSize: 15, color: Color(0xFF232B3B)),
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
                          if (v != null) settingsProvider.setMode(v);
                        },
                      ),
                      if (settingsProvider.settings.mode == RecommendationMode.topN)
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: TextFormField(
                            controller: _topNController,
                            decoration: InputDecoration(
                              labelText: localizations.topNValue,
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            ),
                            keyboardType: TextInputType.number,
                            style: const TextStyle(fontSize: 15),
                            validator: (val) {
                              final n = int.tryParse(val ?? '');
                              if (n == null || n < 1) {
                                return localizations.topNValue;
                              }
                              return null;
                            },
                            onChanged: (val) {
                              final n = int.tryParse(val) ?? 1;
                              settingsProvider.setTopNValue(n);
                            },
                          ),
                        ),
                      const SizedBox(height: 18),
                      ...settingsProvider.settings.criteria.keys.map((key) {
                        final criterion = settingsProvider.settings.criteria[key]!;
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Row(
                            children: [
                              Checkbox(
                                value: criterion.enabled,
                                onChanged: (v) => settingsProvider.setCriterionEnabled(key, v ?? false),
                                activeColor: Color(0xFF6A7BFF),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              Expanded(
                                child: Text(_criterionName(key, localizations), style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                              ),
                              SizedBox(
                                width: 180,
                                child: SliderTheme(
                                  data: SliderTheme.of(context).copyWith(
                                    activeTrackColor: Color(0xFF6A7BFF),
                                    inactiveTrackColor: Color(0xFFDFE3F5),
                                    thumbColor: Color(0xFF6A7BFF),
                                    overlayColor: Color(0x336A7BFF),
                                    trackHeight: 4,
                                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
                                  ),
                                  child: Slider(
                                    value: criterion.weight,
                                    min: 0,
                                    max: 1,
                                    divisions: 10,
                                    onChanged: criterion.enabled
                                        ? (v) => settingsProvider.setCriterionWeight(key, v)
                                        : null,
                                  ),
                                ),
                              ),
                              Text(criterion.weight.toStringAsFixed(1), style: const TextStyle(fontSize: 14, color: Color(0xFF6A7BFF), fontWeight: FontWeight.w600)),
                            ],
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: Card(
                elevation: 8,
                shadowColor: const Color(0x1A000000),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('应用设置', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF232B3B))),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('智能选择默认开启', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                              Text('自动判断并优先选择最佳照片', style: TextStyle(fontSize: 13, color: Color(0xFF8A94A6))),
                            ],
                          ),
                          Switch(
                            value: settingsProvider.settings.smartSelectDefaultEnabled,
                            onChanged: (v) => settingsProvider.setSmartSelectDefaultEnabled(v),
                            activeColor: Color(0xFF6A7BFF),
                          ),
                        ],
                      ),
                      const Divider(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('语言', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                          DropdownButton<Locale>(
                            value: currentLocale,
                            items: [
                              DropdownMenuItem(
                                value: const Locale('zh', 'CN'),
                                child: Text('简体中文'),
                              ),
                              DropdownMenuItem(
                                value: const Locale('en', 'US'),
                                child: Text('English'),
                              ),
                            ],
                            onChanged: (locale) {
                              if (locale != null) {
                                context.read<LocaleProvider>().setLocale(locale);
                              }
                            },
                            style: const TextStyle(fontSize: 15, color: Color(0xFF232B3B)),
                            borderRadius: BorderRadius.circular(12),
                            icon: Icon(Icons.keyboard_arrow_down, color: Color(0xFF6A7BFF)),
                            dropdownColor: Colors.white,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
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