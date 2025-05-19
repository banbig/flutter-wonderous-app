import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/photo.dart';
import 'models/photo_group.dart';
import 'providers/navigation_provider.dart';
import 'providers/photo_data_provider.dart';
import 'pages/dashboard_page.dart';
import 'pages/album_page.dart';
import 'pages/clustering_page.dart';
import 'pages/recommended_page.dart';
import 'pages/settings_page.dart';
import 'widgets/bottom_nav_bar.dart';
import 'presentation/providers/settings_view_provider.dart';
import 'presentation/providers/clustering_view_provider.dart';
import 'data/data_sources/local/local_settings_data_source.dart';
import 'data/data_sources/local/local_photo_data_source.dart';
import 'data/repositories_impl/settings_repository_impl.dart';
import 'data/repositories_impl/photo_repository_impl.dart';
import 'domain/use_cases/collection_management/get_photo_recommendations_use_case.dart';
import 'domain/use_cases/storage_management/cleanup_photos_use_case.dart';

void main() {
  final localSettingsDataSource = LocalSettingsDataSourceImpl();
  final settingsRepository = SettingsRepositoryImpl(localDataSource: localSettingsDataSource);
  final localPhotoDataSource = LocalPhotoDataSourceImpl();
  final photoRepository = PhotoRepositoryImpl(localDataSource: localPhotoDataSource);
  final getPhotoRecommendationsUseCase = GetPhotoRecommendationsUseCase();
  final cleanupPhotosUseCase = CleanupPhotosUseCase(photoRepository);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
        ChangeNotifierProvider(create: (_) => SettingsViewProvider(repository: settingsRepository)),
        ChangeNotifierProxyProvider2<SettingsViewProvider, NavigationProvider, ClusteringViewProvider>(
          create: (_) => ClusteringViewProvider(
            photoRepository: photoRepository,
            getPhotoRecommendationsUseCase: getPhotoRecommendationsUseCase,
            settingsProvider: SettingsViewProvider(repository: settingsRepository),
            cleanupPhotosUseCase: cleanupPhotosUseCase,
          ),
          update: (_, settingsProvider, __, previous) => ClusteringViewProvider(
            photoRepository: photoRepository,
            getPhotoRecommendationsUseCase: getPhotoRecommendationsUseCase,
            settingsProvider: settingsProvider,
            cleanupPhotosUseCase: cleanupPhotosUseCase,
          ),
        ),
        ChangeNotifierProvider(create: (_) => PhotoDataProvider()),
      ],
      child: MaterialApp(
        title: 'Wonderous Photo App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
          fontFamily: 'Inter',
          scaffoldBackgroundColor: Color(0xFFF3F4F6),
        ),
        home: MainScaffold(),
        debugShowCheckedModeBanner: false,
      ),
    ),
  );
}

class MainScaffold extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentIndex = Provider.of<NavigationProvider>(context, listen: true).currentPageIndex;
    final List<Widget> screens = [
      DashboardPage(),
      AlbumPage(),
      ClusteringPage(),
      RecommendedPage(),
      SettingsPage(),
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

