import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_wonderous_app/core/constants/index.dart';
import 'package:flutter_wonderous_app/core/widgets/index.dart';

/// 功能模块页面模板
/// 用于创建新的功能页面
class FeatureTemplate extends StatelessWidget {
  const FeatureTemplate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text('新功能页面', style: AppStyles.headline),
      ),
      body: Container(
        color: AppColors.background,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            CustomCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('功能标题', style: AppStyles.title),
                  const SizedBox(height: 8),
                  Text(
                    '这是功能描述文本，应该简明扼要地说明该功能的用途和使用方法。',
                    style: AppStyles.body,
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            GradientButton(
              text: '主要操作',
              onPressed: () {
                // 主要操作
              },
            ),
            
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: CustomCard(
                    padding: const EdgeInsets.all(16),
                    onTap: () {
                      // 操作1
                    },
                    child: Column(
                      children: [
                        const Icon(Icons.star, color: AppColors.primary, size: 32),
                        const SizedBox(height: 8),
                        Text('选项1', style: AppStyles.caption),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomCard(
                    padding: const EdgeInsets.all(16),
                    onTap: () {
                      // 操作2
                    },
                    child: Column(
                      children: [
                        const Icon(Icons.favorite, color: AppColors.primary, size: 32),
                        const SizedBox(height: 8),
                        Text('选项2', style: AppStyles.caption),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}