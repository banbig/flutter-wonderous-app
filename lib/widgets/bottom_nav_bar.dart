import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: currentIndex,
      onTap: onTap,
      selectedItemColor: Theme.of(context).primaryColor,
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard_outlined),
          label: '首页',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.photo_library_outlined),
          label: '相册',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.cleaning_services_outlined),
          label: '清理',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.recommend_outlined),
          label: '推荐',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings_outlined),
          label: '设置',
        ),
      ],
      backgroundColor: Colors.white,
      elevation: 8,
    );
  }
} 