import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_view_provider.dart';
import '../../domain/entities/recommendation_settings.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsViewProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          appBar: AppBar(title: Text('设置')),
          body: ListView(
            padding: EdgeInsets.all(16),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('推荐标准设置', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 16),
                      DropdownButtonFormField<RecommendationMode>(
                        value: provider.currentMode,
                        decoration: InputDecoration(labelText: '推荐模式'),
                        items: [
                          DropdownMenuItem(
                            value: RecommendationMode.singleBest,
                            child: Text('单张最佳'),
                          ),
                          DropdownMenuItem(
                            value: RecommendationMode.topN,
                            child: Text('Top-N'),
                          ),
                        ],
                        onChanged: (mode) {
                          if (mode != null) provider.setMode(mode);
                        },
                      ),
                      if (provider.currentMode == RecommendationMode.topN)
                        Padding(
                          padding: const EdgeInsets.only(top: 12.0),
                          child: TextFormField(
                            initialValue: provider.topNValue.toString(),
                            decoration: InputDecoration(labelText: 'Top-N 数量'),
                            keyboardType: TextInputType.number,
                            onChanged: (val) {
                              final n = int.tryParse(val) ?? 1;
                              provider.setTopNValue(n);
                            },
                          ),
                        ),
                      SizedBox(height: 16),
                      ...provider.settings.criteria.keys.map((key) {
                        final criterion = provider.settings.criteria[key]!;
                        return Row(
                          children: [
                            Expanded(child: Text(_criterionName(key))),
                            Checkbox(
                              value: criterion.enabled,
                              onChanged: (v) => provider.setCriterionEnabled(key, v ?? false),
                            ),
                            Expanded(
                              flex: 2,
                              child: Slider(
                                value: criterion.weight,
                                min: 0.0,
                                max: 2.0,
                                divisions: 20,
                                label: criterion.weight.toStringAsFixed(2),
                                onChanged: criterion.enabled
                                    ? (v) => provider.setCriterionWeight(key, v)
                                    : null,
                              ),
                            ),
                            SizedBox(width: 40, child: Text(criterion.weight.toStringAsFixed(2))),
                          ],
                        );
                      }).toList(),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () async {
                          await provider.saveSettings();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('设置已保存')),
                          );
                        },
                        child: Text('应用推荐设置'),
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                child: ListTile(
                  title: Text('智能选择默认开启'),
                  trailing: Switch(value: true, onChanged: (_) {}),
                ),
              ),
              Card(
                child: ListTile(
                  title: Text('语言'),
                  subtitle: Text('简体中文'),
                ),
              ),
              Card(
                child: ListTile(
                  title: Text('版本号'),
                  subtitle: Text('1.0.0'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _criterionName(String key) {
    switch (key) {
      case 'clarity':
        return '清晰度';
      case 'exposure':
        return '曝光';
      case 'faces':
        return '人脸数';
      case 'composition':
        return '构图';
      case 'colorfulness':
        return '色彩丰富度';
      default:
        return key;
    }
  }
} 