# Flutter Wonderous App

一个基于Flutter实现的照片管理应用，使用Feature-First架构组织代码。

## 项目架构

项目采用Feature-First（基于功能的）模块化架构，每个功能模块包含自己的数据、领域和表现层。

```
lib/
├── core/                # 核心功能和通用代码
│   ├── constants/       # 应用常量（颜色、尺寸等）
│   ├── di/              # 依赖注入
│   └── widgets/         # 共享组件
├── features/            # 功能模块
│   ├── dashboard/       # 首页功能
│   ├── photo_cleanup/   # 照片清理功能
│   ├── settings/        # 设置功能
│   └── ...              # 其他功能模块
├── l10n/                # 国际化资源
├── routes/              # 路由管理
└── main.dart            # 应用入口
```

### 功能模块结构

每个功能模块采用Clean Architecture分层：

```
features/feature_name/
├── data/                # 数据层
│   ├── datasources/     # 数据源
│   ├── models/          # 数据模型
│   └── repositories/    # 仓库实现
├── domain/              # 领域层
│   ├── entities/        # 实体
│   ├── repositories/    # 仓库接口
│   └── usecases/        # 用例
└── presentation/        # 表现层
    ├── pages/           # 页面
    ├── providers/       # 状态管理
    └── widgets/         # UI组件
```

## 导入路径

项目使用包导入（Package Imports）方式组织导入路径，避免使用相对路径：

```dart
// ❌ 不要使用相对路径
import '../../domain/entities/photo.dart';

// ✅ 使用包导入
import 'package:flutter_wonderous_app/features/photo_cleanup/domain/entities/photo.dart';

// ✅ 更好：使用barrel文件
import 'package:flutter_wonderous_app/features/photo_cleanup/domain/entities/index.dart';
```

## 依赖注入

依赖注入通过`provider_setup.dart`集中管理：

```dart
// 在main.dart中使用
void main() {
  runApp(
    MultiProvider(
      providers: ProviderSetup.getProviders(),
      child: MyApp(),
    ),
  );
}
```

## 路由管理

路由管理通过`app_router.dart`集中配置：

```dart
// 在MaterialApp中使用
MaterialApp(
  initialRoute: AppRouter.dashboard,
  routes: AppRouter.routes,
  onGenerateRoute: AppRouter.generateRoute,
);
```

## 国际化

应用支持多语言，通过Flutter的国际化机制实现：

```dart
MaterialApp(
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
```

## 样式和主题

应用样式集中在`core/constants`目录下管理：

```dart
// 使用预定义颜色
Text(
  'Hello',
  style: TextStyle(color: AppColors.primary),
)

// 使用预定义样式
Text(
  'Hello',
  style: AppStyles.headline,
)
```