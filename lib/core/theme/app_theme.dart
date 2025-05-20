import 'package:flutter/material.dart';
import 'package:flutter_wonderous_app/core/constants/app_colors.dart';

/// 主题配置类，提供全局主题设置
class AppTheme {
  /// 获取亮色主题
  static ThemeData get lightTheme {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        secondary: AppColors.primaryLight,
        background: AppColors.background,
      ),
      useMaterial3: true,
      fontFamily: 'Inter',
      scaffoldBackgroundColor: AppColors.background,
      
      // AppBar主题
      appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontWeight: FontWeight.bold, 
          fontSize: 20, 
          color: AppColors.textPrimary
        ),
        iconTheme: IconThemeData(color: AppColors.textPrimary),
      ),
      
      // 卡片主题
      cardTheme: CardTheme(
        elevation: 3,
        shadowColor: AppColors.shadow,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      
      // 按钮主题
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      
      // 滑块主题
      sliderTheme: SliderThemeData(
        activeTrackColor: AppColors.primary,
        thumbColor: AppColors.primary,
        overlayColor: AppColors.primary.withOpacity(0.2),
      ),
      
      // 文本主题
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 28, 
          fontWeight: FontWeight.w800, 
          color: AppColors.textPrimary,
        ),
        headlineMedium: TextStyle(
          fontSize: 24, 
          fontWeight: FontWeight.bold, 
          color: AppColors.textPrimary,
        ),
        titleLarge: TextStyle(
          fontSize: 20, 
          fontWeight: FontWeight.bold, 
          color: AppColors.textPrimary,
        ),
        titleMedium: TextStyle(
          fontSize: 16, 
          fontWeight: FontWeight.w700, 
          color: AppColors.textPrimary,
        ),
        bodyLarge: TextStyle(
          fontSize: 16, 
          color: AppColors.textPrimary,
        ),
        bodyMedium: TextStyle(
          fontSize: 14, 
          color: AppColors.textPrimary,
        ),
        bodySmall: TextStyle(
          fontSize: 13, 
          color: AppColors.textSecondary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  /// 获取深色主题（如需支持暗黑模式）
  static ThemeData get darkTheme {
    // 这里可以实现暗黑模式的主题，目前只返回浅色主题
    return lightTheme;
  }
}