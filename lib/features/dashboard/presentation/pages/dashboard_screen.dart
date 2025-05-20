import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_wonderous_app/core/widgets/gradient_button.dart';
import 'package:flutter_wonderous_app/routes/app_router.dart';

import 'package:flutter_wonderous_app/features/dashboard/presentation/providers/navigation_provider.dart';
import 'package:flutter_wonderous_app/features/photo_cleanup/presentation/providers/clustering_view_provider.dart';
import 'package:flutter_wonderous_app/core/constants/index.dart';
import 'package:flutter_wonderous_app/core/widgets/index.dart';
import 'package:flutter_wonderous_app/features/photo_cleanup/domain/providers/photo_data_provider.dart';

// 页面索引常量
const int kDashboardPageIndex = 0;
const int kClusteringPageIndex = 1;
const int kSettingsPageIndex = 2;

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(localizations.dashboardTitle, style: AppStyles.headline),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFF3F6FA),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: CustomCard(
            elevation: 14,
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const FlutterLogo(size: 56),
                    const SizedBox(height: 20),
                    Text(
                    localizations.dashboardAppName,
                    style: AppStyles.headline.copyWith(fontSize: 28, fontWeight: FontWeight.w800, letterSpacing: 1.1),
                    ),
                    const SizedBox(height: 8),
                    Text(
                    localizations.dashboardSlogan,
                    style: AppStyles.caption.copyWith(letterSpacing: 0.1),
                    ),
                    const SizedBox(height: 28),
                    GradientButton(
                      text: localizations.dashboardScanAndClean, 
                      height: 48,
                      textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, letterSpacing: 0.5),
                      onPressed: () async {
                        await Provider.of<PhotoDataProvider>(context, listen: false).loadPhotosFromDevice();
                        await Provider.of<ClusteringViewProvider>(context, listen: false).fetchPhotoGroups(context);
                        Provider.of<NavigationProvider>(context, listen: false).setPage(kClusteringPageIndex);
                      },
                    ),
                    const SizedBox(height: 16),
                    
                    // 为示范页面添加按钮
                    GradientButton(
                      text: '查看组件示例',
                      height: 48,
                      onPressed: () {
                        Navigator.pushNamed(context, AppRouter.example);
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('上次扫描：', style: AppStyles.caption),
                        Text('2024-06-01 14:23', style: AppStyles.caption.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('预计可优化：', style: AppStyles.caption),
                        Text('1.2 GB', style: AppStyles.caption.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
              ),
          ),
        ),
      ),
    );
  }
} 