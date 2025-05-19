import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/navigation_provider.dart';
import 'dashboard_screen.dart';
import 'album_screen.dart';
import 'clustering_screen.dart';
import 'recommended_screen.dart';
import 'settings_screen.dart';
import '../widgets/bottom_nav_bar.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentIndex = context.watch<NavigationProvider>().currentIndex;
    final List<Widget> screens = [
      DashboardScreen(),
      AlbumScreen(),
      ClusteringScreen(),
      RecommendedScreen(),
      SettingsScreen(),
    ];
    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
} 