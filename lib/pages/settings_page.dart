import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/settings_criteria_item_widget.dart';
import '../domain/entities/recommendation_settings.dart';
import '../presentation/providers/settings_view_provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _formKey = GlobalKey<FormState>();
  final _topNController = TextEditingController();

  @override
  void dispose() {
    _topNController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SettingsViewProvider>();
    final RecommendationSettings settings = provider.settings;
    _topNController.text = settings.topNValue.toString();
    return Scaffold(
      appBar: AppBar(
        title: const Text('设置', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
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
                    const Text('推荐标准设置', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<RecommendationMode>(
                      value: settings.mode,
                      decoration: const InputDecoration(labelText: '推荐模式'),
                      items: const [
                        DropdownMenuItem(
                          value: RecommendationMode.singleBest,
                          child: Text('单张最佳'),
                        ),
                        DropdownMenuItem(
                          value: RecommendationMode.topN,
                          child: Text('Top-N'),
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
                          decoration: const InputDecoration(labelText: 'Top-N 数量'),
                          keyboardType: TextInputType.number,
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
                        label: key,
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
                              const SnackBar(content: Text('设置已保存')),
                            );
                          }
                        },
                        child: const Text('应用设置'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Card(
              margin: const EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('智能选择默认开启', style: TextStyle(fontSize: 16)),
                    // 这里如需持久化智能选择开关，可扩展 provider
                    Switch(
                      value: true,
                      onChanged: (v) {},
                    ),
                  ],
                ),
              ),
            ),
            Card(
              margin: const EdgeInsets.only(bottom: 16),
              child: const ListTile(
                title: Text('语言'),
                subtitle: Text('简体中文'),
                leading: Icon(Icons.language),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 