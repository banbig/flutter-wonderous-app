import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_wonderous_app/features/dashboard/presentation/providers/navigation_provider.dart';
import 'package:flutter_wonderous_app/features/dashboard/presentation/widgets/bottom_nav_bar.dart';
import 'package:flutter_wonderous_app/features/dashboard/presentation/pages/dashboard_screen.dart';
import 'package:flutter_wonderous_app/features/photo_cleanup/presentation/pages/clustering_screen.dart';
import 'package:flutter_wonderous_app/features/settings/presentation/pages/settings_screen.dart';
import 'package:flutter_wonderous_app/features/photo_cleanup/presentation/providers/clustering_view_provider.dart';
import 'package:flutter_wonderous_app/features/photo_cleanup/domain/providers/photo_data_provider.dart';

class MainScaffold extends StatelessWidget {
  const MainScaffold({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final photoDataProvider = Provider.of<PhotoDataProvider>(context, listen: false);
    final clusteringViewProvider = Provider.of<ClusteringViewProvider>(context, listen: false);
    clusteringViewProvider.photoDataProvider = photoDataProvider;
    final currentIndex = Provider.of<NavigationProvider>(context, listen: true).currentPageIndex;
    
    final List<Widget> screens = [
      const DashboardScreen(),    // 首页
      const ClusteringScreen(),   // 清理
      const SettingsScreen(),     // 设置
    ];
    
    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: currentIndex,
        onTap: (index) => Provider.of<NavigationProvider>(context, listen: false).setPage(index),
      ),
    );
  }
}