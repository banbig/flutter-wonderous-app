import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/recommendation_settings.dart';
import 'models/photo.dart';
import 'models/photo_group.dart';
import 'providers/navigation_provider.dart';
import 'providers/photo_data_provider.dart';
import 'providers/recommendation_settings_provider.dart';
import 'pages/dashboard_page.dart';
import 'pages/album_page.dart';
import 'pages/clustering_page.dart';
import 'pages/recommended_page.dart';
import 'pages/settings_page.dart';
import 'widgets/bottom_nav_bar.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
        ChangeNotifierProvider(create: (_) => PhotoDataProvider()),
        ChangeNotifierProvider(create: (_) => RecommendationSettingsProvider()),
      ],
      child: MaterialApp(
        title: '极简照片管家',
        theme: ThemeData(
          brightness: Brightness.light,
          primarySwatch: Colors.blue,
          useMaterial3: true,
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 0,
          ),
        ),
        home: const MainScaffold(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class MainScaffold extends StatelessWidget {
  const MainScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    final navProvider = Provider.of<NavigationProvider>(context);
    final pages = const [
      DashboardPage(),
      AlbumPage(),
      ClusteringPage(),
      RecommendedPage(),
      SettingsPage(),
    ];
    return Scaffold(
      body: pages[navProvider.currentPageIndex],
      bottomNavigationBar: BottomNavBar(
        currentIndex: navProvider.currentPageIndex,
        onTap: (index) => navProvider.setPage(index),
      ),
    );
  }
}
