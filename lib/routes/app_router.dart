import 'package:flutter/material.dart';
import 'package:flutter_wonderous_app/core/examples/example_screen.dart';

// 导入页面
import 'package:flutter_wonderous_app/features/dashboard/presentation/pages/index.dart';
import 'package:flutter_wonderous_app/features/photo_cleanup/presentation/pages/index.dart';
import 'package:flutter_wonderous_app/features/settings/presentation/pages/index.dart';
import 'package:flutter_wonderous_app/core/widgets/main_scaffold.dart';

class AppRouter {
  // 路由名称
  static const String dashboard = '/';
  static const String photoCleanup = '/photo-cleanup';
  static const String settings = '/settings';
  static const String photoWall = '/photo-wall';
  static const String example = '/example';
  
  // 路由生成器
  // 用于注册到主应用
  static Map<String, WidgetBuilder> routes = {
    dashboard: (context) => const MainScaffold(),
    example: (context) => const ExampleScreen(),
  };
  
  // 路由生成器
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case dashboard:
        return MaterialPageRoute(builder: (_) => const DashboardScreen());
      case photoCleanup:
        return MaterialPageRoute(builder: (_) => const ClusteringScreen());
      case settings:
        return MaterialPageRoute(builder: (_) => const SettingsScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('未找到路由: ${settings.name}'),
            ),
          ),
        );
    }
  }
}
