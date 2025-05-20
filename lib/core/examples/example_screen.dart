import 'package:flutter/material.dart';
import 'package:flutter_wonderous_app/core/constants/index.dart';
import 'package:flutter_wonderous_app/core/widgets/index.dart';
import 'package:flutter_wonderous_app/core/utils/index.dart';

/// 示例页面，展示如何使用barrel文件和项目组件
class ExampleScreen extends StatelessWidget {
  const ExampleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 使用工具类方法
    final formattedDate = AppUtils.formatDate(DateTime.now());
    final formattedSize = AppUtils.formatFileSize(15.7);

    return Scaffold(
      appBar: AppBar(
        title: Text('示例页面', style: AppStyles.headline),
      ),
      body: Container(
        color: AppColors.background,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // 使用CustomCard组件
            CustomCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('使用barrel文件导入', style: AppStyles.subtitle),
                  const SizedBox(height: 8),
                  Text(
                    '通过index.dart文件导入，可以简化导入路径，避免导入过多单独文件。',
                    style: AppStyles.body,
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // 使用GradientButton组件
            GradientButton(
              text: '渐变按钮示例',
              onPressed: () {
                AppUtils.showToast(context, '按钮被点击');
              },
              icon: const Icon(Icons.check, color: Colors.white),
            ),
            
            const SizedBox(height: 16),
            
            // 再次使用CustomCard
            CustomCard(
              elevation: 2,
              onTap: () {
                AppUtils.showToast(context, '卡片被点击');
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('卡片可点击示例', style: AppStyles.subtitle),
                  const SizedBox(height: 8),
                  Text('今天是: $formattedDate', style: AppStyles.body),
                  Text('文件大小: $formattedSize', style: AppStyles.body),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // 混合使用多种组件
            Row(
              children: [
                Expanded(
                  child: CustomCard(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        const Icon(Icons.photo, size: 32, color: AppColors.primary),
                        const SizedBox(height: 8),
                        Text('照片', style: AppStyles.caption),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomCard(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        const Icon(Icons.clean_hands, size: 32, color: AppColors.primary),
                        const SizedBox(height: 8),
                        Text('清理', style: AppStyles.caption),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomCard(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        const Icon(Icons.settings, size: 32, color: AppColors.primary),
                        const SizedBox(height: 8),
                        Text('设置', style: AppStyles.caption),
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