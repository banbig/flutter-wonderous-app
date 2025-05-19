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
// import 'presentation/screens/main_screen.dart';
import 'presentation/providers/settings_view_provider.dart';
import 'presentation/providers/clustering_view_provider.dart';
import 'data/data_sources/local/local_settings_data_source.dart';
import 'data/data_sources/local/local_photo_data_source.dart';
import 'data/repositories_impl/settings_repository_impl.dart';
import 'data/repositories_impl/photo_repository_impl.dart';

void main() {
  final localSettingsDataSource = LocalSettingsDataSourceImpl();
  final settingsRepository = SettingsRepositoryImpl(localDataSource: localSettingsDataSource);
  final localPhotoDataSource = LocalPhotoDataSourceImpl();
  final photoRepository = PhotoRepositoryImpl(localDataSource: localPhotoDataSource);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
        ChangeNotifierProvider(create: (_) => SettingsViewProvider(repository: settingsRepository)),
        ChangeNotifierProvider(create: (_) => ClusteringViewProvider(photoRepository: photoRepository)),
        ChangeNotifierProvider(create: (_) => PhotoDataProvider()),
        ChangeNotifierProvider(create: (_) => RecommendationSettingsProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wonderous Photo App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        fontFamily: 'Inter',
        scaffoldBackgroundColor: Color(0xFFF3F4F6),
      ),
      home: MainScaffold(),
      debugShowCheckedModeBanner: false,
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
