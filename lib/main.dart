import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:flutter_wonderous_app/features/dashboard/presentation/providers/navigation_provider.dart';
import 'package:flutter_wonderous_app/features/dashboard/presentation/widgets/bottom_nav_bar.dart';
import 'package:flutter_wonderous_app/features/dashboard/presentation/pages/dashboard_screen.dart';
import 'package:flutter_wonderous_app/features/photo_cleanup/presentation/pages/clustering_screen.dart';
import 'package:flutter_wonderous_app/features/settings/presentation/pages/settings_screen.dart';
import 'package:flutter_wonderous_app/features/photo_cleanup/presentation/providers/clustering_view_provider.dart';
import 'package:flutter_wonderous_app/features/photo_cleanup/domain/providers/photo_data_provider.dart';
import 'package:flutter_wonderous_app/providers/locale_provider.dart';
import 'package:flutter_wonderous_app/core/di/provider_setup.dart';
import 'package:flutter_wonderous_app/core/theme/app_theme.dart';
import 'package:flutter_wonderous_app/routes/app_router.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  runApp(
    MultiProvider(
      providers: ProviderSetup.getProviders(),
      child: Consumer<LocaleProvider>(
        builder: (context, localeProvider, child) {
          return MaterialApp(
            navigatorKey: navigatorKey,
            title: 'Wonderous Photo App',
            theme: AppTheme.lightTheme,
            // 使用新的路由系统
            initialRoute: AppRouter.dashboard,
            routes: AppRouter.routes,
            onGenerateRoute: AppRouter.generateRoute,
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

// MainScaffold 不在需要，已经移到 core/widgets/main_scaffold.dart
