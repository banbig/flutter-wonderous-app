import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/photo.dart';
import 'models/photo_group.dart';
import 'providers/navigation_provider.dart';
import 'providers/photo_data_provider.dart';
import 'widgets/bottom_nav_bar.dart';
import 'presentation/providers/settings_view_provider.dart';
import 'presentation/providers/clustering_view_provider.dart';
import 'data/data_sources/local/local_settings_data_source.dart';
import 'data/data_sources/local/local_photo_data_source.dart';
import 'data/repositories_impl/settings_repository_impl.dart';
import 'data/repositories_impl/photo_repository_impl.dart';
import 'domain/use_cases/collection_management/get_photo_recommendations_use_case.dart';
import 'domain/use_cases/storage_management/cleanup_photos_use_case.dart';
import 'package:logger/logger.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'providers/locale_provider.dart';
import 'presentation/screens/dashboard_screen.dart';
// import 'presentation/screens/album_screen.dart';
import 'presentation/screens/clustering_screen.dart';
import 'presentation/screens/recommended_screen.dart';
import 'presentation/screens/settings_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  Logger.level = Level.debug;
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
          create: (context) => ClusteringViewProvider(
            photoRepository: photoRepository,
            getPhotoRecommendationsUseCase: getPhotoRecommendationsUseCase,
            settingsProvider: Provider.of<SettingsViewProvider>(context, listen: false),
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
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
      ],
      child: Consumer<LocaleProvider>(
        builder: (context, localeProvider, child) {
          return MaterialApp(
            title: 'Wonderous Photo App',
            theme: ThemeData(
              colorSchemeSeed: Colors.blue,
              useMaterial3: true,
              fontFamily: 'Inter',
              scaffoldBackgroundColor: Color(0xFFF3F4F6),
            ),
            home: MainScaffold(),
            debugShowCheckedModeBanner: false,
            locale: localeProvider.locale,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('zh', 'CN'),
              Locale('en', 'US'),
            ],
          );
        },
      ),
    ),
  );
}

class MainScaffold extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentIndex = Provider.of<NavigationProvider>(context, listen: true).currentPageIndex;
    final List<Widget> screens = [
      DashboardScreen(),
      // AlbumScreen(), // 移除相册页面
      ClusteringScreen(),
      RecommendedScreen(),
      SettingsScreen(),
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

