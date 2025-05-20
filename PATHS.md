# 项目架构路径映射

本文档展示了项目的Feature-First架构与导入路径的映射关系，帮助开发者快速了解和使用项目结构。

## 核心组件 (Core)

```
// 常量
import 'package:flutter_wonderous_app/core/constants/app_colors.dart';
import 'package:flutter_wonderous_app/core/constants/app_styles.dart';
// 或使用barrel文件
import 'package:flutter_wonderous_app/core/constants/index.dart';

// 工具
import 'package:flutter_wonderous_app/core/utils/app_utils.dart';
// 或使用barrel文件
import 'package:flutter_wonderous_app/core/utils/index.dart';

// 通用组件
import 'package:flutter_wonderous_app/core/widgets/gradient_button.dart';
import 'package:flutter_wonderous_app/core/widgets/custom_card.dart';
import 'package:flutter_wonderous_app/core/widgets/main_scaffold.dart';
// 或使用barrel文件
import 'package:flutter_wonderous_app/core/widgets/index.dart';

// 主题
import 'package:flutter_wonderous_app/core/theme/app_theme.dart';
// 或使用barrel文件
import 'package:flutter_wonderous_app/core/theme/index.dart';

// 依赖注入
import 'package:flutter_wonderous_app/core/di/provider_setup.dart';
```

## 功能模块 (Features)

### 首页模块

```
// 页面
import 'package:flutter_wonderous_app/features/dashboard/presentation/pages/dashboard_screen.dart';
// 或使用barrel文件
import 'package:flutter_wonderous_app/features/dashboard/presentation/pages/index.dart';

// 组件
import 'package:flutter_wonderous_app/features/dashboard/presentation/widgets/bottom_nav_bar.dart';
// 或使用barrel文件
import 'package:flutter_wonderous_app/features/dashboard/presentation/widgets/index.dart';

// Provider
import 'package:flutter_wonderous_app/features/dashboard/presentation/providers/navigation_provider.dart';
// 或使用barrel文件
import 'package:flutter_wonderous_app/features/dashboard/presentation/providers/index.dart';
```

### 照片清理模块

```
// 页面
import 'package:flutter_wonderous_app/features/photo_cleanup/presentation/pages/clustering_screen.dart';
// 或使用barrel文件
import 'package:flutter_wonderous_app/features/photo_cleanup/presentation/pages/index.dart';

// Provider
import 'package:flutter_wonderous_app/features/photo_cleanup/presentation/providers/clustering_view_provider.dart';
// 或使用barrel文件
import 'package:flutter_wonderous_app/features/photo_cleanup/presentation/providers/index.dart';

// 领域模型
import 'package:flutter_wonderous_app/features/photo_cleanup/domain/entities/photo.dart';
import 'package:flutter_wonderous_app/features/photo_cleanup/domain/entities/photo_group.dart';
// 或使用barrel文件
import 'package:flutter_wonderous_app/features/photo_cleanup/domain/entities/index.dart';

// 领域服务
import 'package:flutter_wonderous_app/features/photo_cleanup/domain/providers/photo_data_provider.dart';
```

### 设置模块

```
// 页面
import 'package:flutter_wonderous_app/features/settings/presentation/pages/settings_screen.dart';
// 或使用barrel文件
import 'package:flutter_wonderous_app/features/settings/presentation/pages/index.dart';

// Provider
import 'package:flutter_wonderous_app/features/settings/presentation/providers/settings_view_provider.dart';
// 或使用barrel文件
import 'package:flutter_wonderous_app/features/settings/presentation/providers/index.dart';

// 领域模型
import 'package:flutter_wonderous_app/features/settings/domain/entities/recommendation_settings.dart';
// 或使用barrel文件
import 'package:flutter_wonderous_app/features/settings/domain/entities/index.dart';
```

## 路由与导航

```
import 'package:flutter_wonderous_app/routes/app_router.dart';
```

## 国际化

```
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
```

## 应用入口

```
import 'package:flutter_wonderous_app/main.dart';
```