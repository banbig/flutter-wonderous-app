# 创建新功能模块指南

本指南将帮助你在项目中创建一个符合Feature-First架构的新功能模块。

## 功能模块结构

每个功能模块应该遵循以下结构：

```
lib/features/your_feature_name/
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

## 步骤1：创建目录结构

```bash
# 创建主目录
mkdir -p lib/features/your_feature_name

# 创建数据层目录
mkdir -p lib/features/your_feature_name/data/datasources
mkdir -p lib/features/your_feature_name/data/models
mkdir -p lib/features/your_feature_name/data/repositories

# 创建领域层目录
mkdir -p lib/features/your_feature_name/domain/entities
mkdir -p lib/features/your_feature_name/domain/repositories
mkdir -p lib/features/your_feature_name/domain/usecases

# 创建表现层目录
mkdir -p lib/features/your_feature_name/presentation/pages
mkdir -p lib/features/your_feature_name/presentation/providers
mkdir -p lib/features/your_feature_name/presentation/widgets
```

## 步骤2：创建实体(Entities)

创建你的实体类，可以参考 `/lib/templates/entity_template.dart`：

```dart
// lib/features/your_feature_name/domain/entities/item.dart
class Item {
  final String id;
  final String name;
  final String description;
  
  Item({
    required this.id,
    required this.name,
    required this.description,
  });
}
```

然后创建barrel文件:

```dart
// lib/features/your_feature_name/domain/entities/index.dart
export 'item.dart';
```

## 步骤3：创建Provider

创建状态管理Provider，可以参考 `/lib/templates/provider_template.dart`：

```dart
// lib/features/your_feature_name/presentation/providers/item_provider.dart
import 'package:flutter/foundation.dart';
import 'package:flutter_wonderous_app/features/your_feature_name/domain/entities/index.dart';

class ItemProvider extends ChangeNotifier {
  List<Item> _items = [];
  bool _isLoading = false;
  
  List<Item> get items => _items;
  bool get isLoading => _isLoading;
  
  Future<void> loadItems() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      // 加载数据...
      await Future.delayed(const Duration(seconds: 1));
      _items = [
        Item(id: '1', name: '项目1', description: '描述1'),
        Item(id: '2', name: '项目2', description: '描述2'),
      ];
    } catch (e) {
      // 处理错误...
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
```

创建barrel文件:

```dart
// lib/features/your_feature_name/presentation/providers/index.dart
export 'item_provider.dart';
```

## 步骤4：创建页面

创建功能页面，可以参考 `/lib/templates/feature_template.dart`：

```dart
// lib/features/your_feature_name/presentation/pages/items_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_wonderous_app/core/constants/index.dart';
import 'package:flutter_wonderous_app/core/widgets/index.dart';
import 'package:flutter_wonderous_app/features/your_feature_name/presentation/providers/index.dart';
import 'package:flutter_wonderous_app/features/your_feature_name/domain/entities/index.dart';

class ItemsPage extends StatelessWidget {
  const ItemsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('我的项目', style: AppStyles.headline),
      ),
      body: Consumer<ItemProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: provider.items.length,
            itemBuilder: (context, index) {
              final item = provider.items[index];
              return CustomCard(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  title: Text(item.name, style: AppStyles.title),
                  subtitle: Text(item.description, style: AppStyles.caption),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // 添加新项目...
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
```

创建barrel文件:

```dart
// lib/features/your_feature_name/presentation/pages/index.dart
export 'items_page.dart';
```

## 步骤5：注册Provider

在 `lib/core/di/provider_setup.dart` 中注册你的Provider：

```dart
import 'package:flutter_wonderous_app/features/your_feature_name/presentation/providers/index.dart';

// 在 getProviders() 方法中添加:
ChangeNotifierProvider(create: (_) => ItemProvider()),
```

## 步骤6：添加路由

在 `lib/routes/app_router.dart` 中添加路由：

```dart
import 'package:flutter_wonderous_app/features/your_feature_name/presentation/pages/index.dart';

// 在 AppRouter 类中添加路由常量:
static const String items = '/items';

// 在 routes Map 中添加:
static Map<String, WidgetBuilder> routes = {
  // ...
  items: (context) => const ItemsPage(),
};

// 在 generateRoute 方法中添加:
static Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    // ...
    case items:
      return MaterialPageRoute(builder: (_) => const ItemsPage());
    // ...
  }
}
```

## 步骤7：创建测试

```dart
// test/features/your_feature_name/presentation/providers/item_provider_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_wonderous_app/features/your_feature_name/presentation/providers/index.dart';

void main() {
  group('ItemProvider Tests', () {
    test('should load items correctly', () async {
      final provider = ItemProvider();
      
      expect(provider.items, isEmpty);
      expect(provider.isLoading, isFalse);
      
      await provider.loadItems();
      
      expect(provider.items, isNotEmpty);
      expect(provider.items.length, 2);
      expect(provider.isLoading, isFalse);
    });
  });
}
```

## 完成

现在你已经创建了一个完整的功能模块！你可以继续扩展这个模块，添加更多的实体、用例、数据源和UI组件来实现更复杂的功能。