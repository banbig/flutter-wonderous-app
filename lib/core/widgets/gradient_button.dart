import 'package:flutter/material.dart';
import 'package:flutter_wonderous_app/core/constants/app_colors.dart';

class GradientButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final double width;
  final double height;
  final List<Color> gradientColors;
  final TextStyle? textStyle;
  final BorderRadius? borderRadius;
  final Widget? icon;
  final EdgeInsetsGeometry padding;

  const GradientButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.width = double.infinity,
    this.height = 50,
    this.gradientColors = const [AppColors.primary, AppColors.primaryLight],
    this.textStyle,
    this.borderRadius,
    this.icon,
    this.padding = const EdgeInsets.symmetric(vertical: 12),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final defaultTextStyle = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w700,
      color: Colors.white,
    );

    return SizedBox(
      width: width,
      height: height,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: borderRadius ?? BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: gradientColors.first.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            padding: padding,
            shape: RoundedRectangleBorder(
              borderRadius: borderRadius ?? BorderRadius.circular(12),
            ),
            elevation: 0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                icon!,
                const SizedBox(width: 8),
              ],
              Text(
                text,
                style: textStyle ?? defaultTextStyle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}