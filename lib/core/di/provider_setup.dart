import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:logger/logger.dart';

import 'package:flutter_wonderous_app/features/dashboard/presentation/providers/navigation_provider.dart';
import 'package:flutter_wonderous_app/features/settings/presentation/providers/settings_view_provider.dart';
import 'package:flutter_wonderous_app/features/photo_cleanup/domain/providers/photo_data_provider.dart';
import 'package:flutter_wonderous_app/providers/locale_provider.dart';
import 'package:flutter_wonderous_app/features/photo_cleanup/presentation/providers/clustering_view_provider.dart';

// 临时的简单仓库实现
class SimpleSettingsRepository {
  Future<Object> getRecommendationSettings() async {
    return {};
  }
  
  Future<void> saveRecommendationSettings(Object settings) async {
    // 临时实现
  }
}

class ProviderSetup {
  static List<SingleChildWidget> getProviders() {
    Logger.level = Level.debug;
    
    // 创建简单的依赖
    final settingsRepository = SimpleSettingsRepository();
    
    return [
      ChangeNotifierProvider(create: (_) => NavigationProvider()),
      ChangeNotifierProvider(create: (_) => SettingsViewProvider(repository: settingsRepository)),
      ChangeNotifierProvider(create: (_) => PhotoDataProvider()),
      ChangeNotifierProvider(create: (_) => LocaleProvider()),
      ChangeNotifierProvider(create: (_) => ClusteringViewProvider()),
    ];
  }
}