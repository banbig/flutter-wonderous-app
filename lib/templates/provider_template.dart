import 'package:flutter/foundation.dart';
import 'package:flutter_wonderous_app/core/utils/app_utils.dart';

/// Provider模板
/// 用于创建新的功能模块的状态管理
class ProviderTemplate extends ChangeNotifier {
  // 状态变量
  bool _isLoading = false;
  String _message = '';
  List<String> _items = [];
  
  // Getter
  bool get isLoading => _isLoading;
  String get message => _message;
  List<String> get items => _items;
  bool get hasItems => _items.isNotEmpty;
  
  /// 初始化数据
  Future<void> initialize() async {
    _setLoading(true);
    try {
      // 模拟加载数据
      await Future.delayed(const Duration(seconds: 1));
      _items = ['项目 1', '项目 2', '项目 3'];
      _message = '数据加载成功';
    } catch (e) {
      AppUtils.log('初始化失败: $e', level: LogLevel.error);
      _message = '数据加载失败';
    } finally {
      _setLoading(false);
    }
  }
  
  /// 添加项目
  void addItem(String item) {
    if (item.isEmpty) return;
    
    _items.add(item);
    _message = '已添加: $item';
    notifyListeners();
  }
  
  /// 删除项目
  void removeItem(String item) {
    final removed = _items.remove(item);
    if (removed) {
      _message = '已删除: $item';
      notifyListeners();
    }
  }
  
  /// 清空项目
  void clearItems() {
    if (_items.isEmpty) return;
    
    _items = [];
    _message = '已清空所有项目';
    notifyListeners();
  }
  
  /// 设置加载状态
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}