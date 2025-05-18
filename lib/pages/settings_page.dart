import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/recommendation_settings.dart';
import '../providers/recommendation_settings_provider.dart';
import '../widgets/settings_criteria_item_widget.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late RecommendationSettings _settings;
  final _formKey = GlobalKey<FormState>();
  final _topNController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final provider = context.read<RecommendationSettingsProvider>();
    _settings = provider.settings.copyWith();
    _topNController.text = _settings.topN.toString();
  }

  @override
  void dispose() {
    _topNController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RecommendationSettingsProvider>();
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
                      value: _settings.mode,
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
                        setState(() {
                          _settings = _settings.copyWith(mode: v);
                        });
                      },
                    ),
                    if (_settings.mode == RecommendationMode.topN)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: TextFormField(
                          controller: _topNController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: 'Top-N 数量 (1-5)'),
                          validator: (v) {
                            final n = int.tryParse(v ?? '');
                            if (n == null || n < 1 || n > 5) {
                              return '请输入1-5之间的数字';
                            }
                            return null;
                          },
                          onChanged: (v) {
                            final n = int.tryParse(v);
                            if (n != null && n >= 1 && n <= 5) {
                              setState(() {
                                _settings = _settings.copyWith(topN: n);
                              });
                            }
                          },
                        ),
                      ),
                    const SizedBox(height: 16),
                    ..._settings.weights.keys.map((key) => SettingsCriteriaItemWidget(
                          label: _criteriaLabel(key),
                          enabled: _settings.enabledCriteria[key] ?? true,
                          weight: _settings.weights[key] ?? 1.0,
                          onEnabledChanged: (v) {
                            setState(() {
                              _settings.enabledCriteria[key] = v;
                            });
                          },
                          onWeightChanged: (v) {
                            setState(() {
                              _settings.weights[key] = v;
                            });
                          },
                        )),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            provider.updateSettings(_settings);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('设置已应用')),);
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
                    Switch(
                      value: _settings.smartSelectEnabled,
                      onChanged: (v) {
                        setState(() {
                          _settings = _settings.copyWith(smartSelectEnabled: v);
                        });
                        provider.updateSmartSelect(v);
                      },
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
            Card(
              child: Column(
                children: const [
                  ListTile(
                    title: Text('版本号'),
                    subtitle: Text('v1.0.0'),
                    leading: Icon(Icons.info_outline),
                  ),
                  ListTile(
                    title: Text('用户协议'),
                    leading: Icon(Icons.article_outlined),
                  ),
                  ListTile(
                    title: Text('隐私政策'),
                    leading: Icon(Icons.privacy_tip_outlined),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _criteriaLabel(String key) {
    switch (key) {
      case 'clarity':
        return '清晰度';
      case 'exposure':
        return '曝光';
      case 'faces':
        return '人脸';
      case 'composition':
        return '构图';
      case 'colorfulness':
        return '色彩丰富度';
      default:
        return key;
    }
  }
} 