import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

/// 工具类，包含各种辅助方法
class AppUtils {
  static final Logger _logger = Logger();
  
  /// 获取格式化的日期字符串
  static String formatDate(DateTime date, {String format = 'yyyy-MM-dd'}) {
    try {
      return DateFormat(format).format(date);
    } catch (e) {
      _logger.e('格式化日期错误: $e');
      return '';
    }
  }
  
  /// 格式化文件大小
  static String formatFileSize(double sizeInMB) {
    if (sizeInMB < 1) {
      return '${(sizeInMB * 1024).toStringAsFixed(0)} KB';
    } else if (sizeInMB < 1024) {
      return '${sizeInMB.toStringAsFixed(2)} MB';
    } else {
      return '${(sizeInMB / 1024).toStringAsFixed(2)} GB';
    }
  }
  
  /// 简化日志打印
  static void log(String message, {LogLevel level = LogLevel.debug}) {
    switch (level) {
      case LogLevel.debug:
        _logger.d(message);
        break;
      case LogLevel.info:
        _logger.i(message);
        break;
      case LogLevel.warning:
        _logger.w(message);
        break;
      case LogLevel.error:
        _logger.e(message);
        break;
    }
  }
  
  /// 显示简单的提示信息
  static void showToast(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
  
  /// 创建圆角装饰
  static BoxDecoration roundedDecoration({
    Color color = Colors.white,
    double radius = 16,
    List<BoxShadow>? shadows,
  }) {
    return BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(radius),
      boxShadow: shadows,
    );
  }
  
  /// 防抖函数，避免短时间内多次调用
  static Function debounce(Function fn, {Duration duration = const Duration(milliseconds: 500)}) {
    DateTime? lastCall;
    return () {
      final now = DateTime.now();
      if (lastCall == null || now.difference(lastCall!) > duration) {
        lastCall = now;
        fn();
      }
    };
  }
}

/// 日志级别
enum LogLevel {
  debug,
  info,
  warning,
  error,
}