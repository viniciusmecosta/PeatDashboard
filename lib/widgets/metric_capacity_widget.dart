import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

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

  String _formatDate(String dateString) {
    try {
      final dateTime = DateTime.parse(dateString);
      return DateFormat('HH:mm dd/MM/yyyy').format(dateTime);
    } catch (_) {
      return 'Data inválida';
    }
  }

  double _parseValue(String value) {
    try {
      return double.parse(value.replaceAll(RegExp(r'[^0-9.]'), '')).clamp(0, 100);
    } catch (_) {
      return 0.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formattedDate = _formatDate(subtitle);
    final double numericValue = _parseValue(value);

    Color valueTextColor = theme.brightness == Brightness.dark ? Colors.white : Colors.black;

    Color dateTextColor = theme.brightness == Brightness.dark
        ? Colors.white54
        : Colors.black87;

    return Container(
      padding: const EdgeInsets.all(1),
      height: 200,
      width: 200,
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: theme.dividerColor.withOpacity(0.1)),
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
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 1),

          Flexible(
            flex: 3,
            child: SizedBox(
              height: 190,
              width: 190,
              child: SleekCircularSlider(
                appearance: CircularSliderAppearance(
                  size: 190,
                  angleRange: 290,
                  startAngle: 126,
                  customWidths: CustomSliderWidths(trackWidth: 13, progressBarWidth: 15),
                  customColors: CustomSliderColors(progressBarColor: chartColor, trackColor: theme.dividerColor),
                  infoProperties: InfoProperties(
                    mainLabelStyle: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: valueTextColor,
                      fontSize: 28,
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

          const SizedBox(height: 1),

          Flexible(
            child: Text(
              formattedDate,
              style: theme.textTheme.bodySmall?.copyWith(
                color: dateTextColor,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
