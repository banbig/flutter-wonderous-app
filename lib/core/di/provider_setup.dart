import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:logger/logger.dart';

import 'package:flutter_wonderous_app/features/dashboard/presentation/providers/navigation_provider.dart';
import 'package:flutter_wonderous_app/features/photo_cleanup/presentation/providers/clustering_view_provider.dart';
import 'package:flutter_wonderous_app/features/settings/presentation/providers/settings_view_provider.dart';
import 'package:flutter_wonderous_app/features/photo_cleanup/domain/providers/photo_data_provider.dart';
import 'package:flutter_wonderous_app/providers/locale_provider.dart';

import 'package:flutter_wonderous_app/data/data_sources/local/local_settings_data_source.dart';
import 'package:flutter_wonderous_app/data/data_sources/local/local_photo_data_source.dart';
import 'package:flutter_wonderous_app/data/repositories_impl/settings_repository_impl.dart';
import 'package:flutter_wonderous_app/data/repositories_impl/photo_repository_impl.dart';
import 'package:flutter_wonderous_app/domain/use_cases/collection_management/get_photo_recommendations_use_case.dart';
import 'package:flutter_wonderous_app/domain/use_cases/storage_management/cleanup_photos_use_case.dart';

class ProviderSetup {
  static List<SingleChildWidget> getProviders() {
    Logger.level = Level.debug;
    final localSettingsDataSource = LocalSettingsDataSourceImpl();
    final settingsRepository = SettingsRepositoryImpl(localDataSource: localSettingsDataSource);
    final localPhotoDataSource = LocalPhotoDataSourceImpl();
    final photoRepository = PhotoRepositoryImpl(localDataSource: localPhotoDataSource);
    final getPhotoRecommendationsUseCase = GetPhotoRecommendationsUseCase();
    final cleanupPhotosUseCase = CleanupPhotosUseCase(photoRepository);

    return [
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
    ];
  }
}