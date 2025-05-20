import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/navigation_provider.dart';

class BottomNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final navigationProvider = Provider.of<NavigationProvider>(context);
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: navigationProvider.currentIndex,
      onTap: navigationProvider.changePage,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: '首页',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.cleaning_services_outlined),
          activeIcon: Icon(Icons.cleaning_services),
          label: '清理',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.recommend_outlined),
          activeIcon: Icon(Icons.recommend),
          label: '推荐',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings_outlined),
          activeIcon: Icon(Icons.settings),
          label: '设置',
        ),
      ],
    );
  }
} 