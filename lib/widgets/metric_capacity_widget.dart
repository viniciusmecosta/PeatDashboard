import 'package:flutter/material.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:peatdashboard/utils/app_colors.dart';

class MetricCapacityWidget extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final Color chartColor;

  const MetricCapacityWidget({
    super.key,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.chartColor,
  });

  double _parseValue(String value) {
    try {
      return double.parse(
        value.replaceAll(RegExp(r'[^0-9.]'), ''),
      ).clamp(0, 100);
    } catch (_) {
      return 0.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formattedDate = subtitle;
    final double numericValue = _parseValue(value);
    final isLargeScreen = MediaQuery.of(context).size.width > 600;
    final size = isLargeScreen ? 250.0 : 150.0;
    final trackWidth = isLargeScreen ? 20.0 : 13.0;
    final progressBarWidth = isLargeScreen ? 23.0 : 15.0;
    final titleFontSize = isLargeScreen ? 16.0 : 12.0;
    final dateFontSize = isLargeScreen ? 14.0 : 10.0;
    final valueFontSize = isLargeScreen ? 30.0 : 20.0;

    final isDarkMode = theme.brightness == Brightness.dark;
    final backgroundColor =
        isDarkMode
            ? AppColors.metricWidgetDarkBackgroundColor
            : AppColors.lightBackgroundColor;
    final borderColor =
        isDarkMode
            ? AppColors.metricWidgetDarkBorderColor.withOpacity(0.1)
            : AppColors.lightBorderColor.withOpacity(0.1);
    final valueTextColor =
        isDarkMode
            ? AppColors.lightBackgroundColor
            : AppColors.darkBackgroundColor;
    final dateTextColor =
        isDarkMode ? AppColors.lightDateColor : AppColors.darkDateColor;

    return Container(
      padding: const EdgeInsets.all(1),
      height: size,
      width: size,
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
          Flexible(
            child: Text(
              title,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontSize: titleFontSize,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 4),
          Flexible(
            flex: 3,
            child: SizedBox(
              height: size,
              width: size,
              child: SleekCircularSlider(
                appearance: CircularSliderAppearance(
                  size: size,
                  angleRange: 290,
                  startAngle: 126,
                  customWidths: CustomSliderWidths(
                    trackWidth: trackWidth,
                    progressBarWidth: progressBarWidth,
                  ),
                  customColors: CustomSliderColors(
                    progressBarColor: chartColor,
                    trackColor: theme.dividerColor,
                  ),
                  infoProperties: InfoProperties(
                    mainLabelStyle: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: valueTextColor,
                      fontSize: valueFontSize,
                    ),
                    modifier: (double value) {
                      return '${value.toInt()}%';
                    },
                  ),
                ),
                min: 0,
                max: 100,
                initialValue: numericValue,
              ),
            ),
          ),
          Flexible(
            child: Text(
              formattedDate,
              style: theme.textTheme.bodySmall?.copyWith(
                color: dateTextColor,
                fontSize: dateFontSize,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
