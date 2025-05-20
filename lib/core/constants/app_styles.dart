import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppStyles {
  // 文本样式
  static const TextStyle headline = TextStyle(
    fontSize: 20, 
    fontWeight: FontWeight.bold, 
    color: AppColors.textPrimary
  );
  
  static const TextStyle title = TextStyle(
    fontSize: 16, 
    fontWeight: FontWeight.w700, 
    color: AppColors.textPrimary
  );
  
  static const TextStyle subtitle = TextStyle(
    fontSize: 15, 
    fontWeight: FontWeight.w700, 
    color: AppColors.textPrimary
  );
  
  static const TextStyle body = TextStyle(
    fontSize: 14, 
    color: AppColors.textPrimary
  );
  
  static const TextStyle caption = TextStyle(
    fontSize: 13, 
    color: AppColors.textSecondary,
    fontWeight: FontWeight.w600
  );
  
  // 按钮样式
  static final ButtonStyle primaryButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: Colors.transparent,
    shadowColor: Colors.transparent,
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    elevation: 0,
  );
  
  static final ButtonStyle secondaryButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: AppColors.cardBackground,
    shadowColor: Colors.transparent,
    foregroundColor: AppColors.primary,
    padding: const EdgeInsets.symmetric(vertical: 12),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    elevation: 0,
  );
  
  // 卡片样式
  static final cardDecoration = BoxDecoration(
    color: AppColors.cardBackground,
    borderRadius: BorderRadius.circular(16),
    boxShadow: [BoxShadow(color: AppColors.shadow, blurRadius: 8, offset: Offset(0, 2))],
  );
}
