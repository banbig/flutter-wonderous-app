import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:flutter_wonderous_app/core/di/provider_setup.dart';
import 'package:flutter_wonderous_app/core/theme/app_theme.dart';
import 'package:flutter_wonderous_app/routes/app_router.dart';
import 'package:flutter_wonderous_app/providers/locale_provider.dart';

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
