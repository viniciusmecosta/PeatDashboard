import 'package:flutter/material.dart';
import 'package:peatdashboard/utils/app_colors.dart';

class NotifyIconCardWidget extends StatelessWidget {
  final VoidCallback onTap;

  const NotifyIconCardWidget({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLargeScreen = MediaQuery.of(context).size.width > 600;

    final size = isLargeScreen ? 250.0 : 135.0;
    final iconSize = isLargeScreen ? 50.0 : 32.0;
    final titleFontSize = isLargeScreen ? 18.0 : 12.0;
    final subtitleFontSize = isLargeScreen ? 14.0 : 10.0;

    final isDarkMode = theme.brightness == Brightness.dark;
    final backgroundColor =
        isDarkMode
            ? AppColors.metricWidgetDarkBackgroundColor
            : AppColors.lightBackgroundColor;
    final borderColor =
        isDarkMode
            ? AppColors.metricWidgetDarkBorderColor.withOpacity(0.1)
            : AppColors.lightBorderColor.withOpacity(0.1);
    final iconColor = theme.colorScheme.primary;
    final textColor = theme.colorScheme.onSurface;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: size,
        width: size,
        padding: const EdgeInsets.all(16),
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.pets, color: iconColor, size: iconSize),
            const SizedBox(height: 12),
            Text(
              "Receber Alertas", // Novo Título
              style: theme.textTheme.titleMedium?.copyWith(
                color: textColor,
                fontWeight: FontWeight.bold,
                fontSize: titleFontSize,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              "Seja um colaborador", // Novo Subtítulo
              style: theme.textTheme.bodySmall?.copyWith(
                color: textColor.withOpacity(0.7),
                fontSize: subtitleFontSize,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
