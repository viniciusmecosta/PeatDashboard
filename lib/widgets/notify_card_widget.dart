import 'package:flutter/material.dart';
import 'package:peatdashboard/utils/app_colors.dart';

class NotifyIconCardWidget extends StatelessWidget {
  final VoidCallback onTap;

  const NotifyIconCardWidget({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLargeScreen = MediaQuery.of(context).size.width > 600;
    final size = isLargeScreen ? 250.0 : 150.0;

    final isDarkMode = theme.brightness == Brightness.dark;
    final backgroundColor =
        isDarkMode
            ? AppColors.metricWidgetDarkBackgroundColor
            : AppColors.lightBackgroundColor;
    final borderColor =
        isDarkMode
            ? AppColors.metricWidgetDarkBorderColor.withOpacity(0.1)
            : AppColors.lightBorderColor.withOpacity(0.1);
    final iconColor =
        isDarkMode
            ? AppColors.lightBackgroundColor
            : AppColors.darkBackgroundColor;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: size,
        width: size,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: borderColor),
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Icon(
            Icons.notifications_none_sharp,
            color: iconColor,
            size: isLargeScreen ? 60 : 40,
          ),
        ),
      ),
    );
  }
}
