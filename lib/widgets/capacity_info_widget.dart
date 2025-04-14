import 'package:flutter/material.dart';
import 'package:peatdashboard/utils/app_colors.dart';

class CapacityInfoWidget extends StatelessWidget {
  final double percentage;

  const CapacityInfoWidget({super.key, required this.percentage});

  Color _getColorForLevel(double percentage) {
    if (percentage > 75) {
      return AppColors.capacityInfoGoodColor;
    } else if (percentage >= 50) {
      return AppColors.capacityInfoMediumColor;
    } else {
      return AppColors.capacityInfoBadColor;
    }
  }

  String _getLevelDescription(double percentage) {
    if (percentage > 75) {
      return "Bom";
    } else if (percentage >= 50) {
      return "Médio";
    } else {
      return "Ruim";
    }
  }

  List<Widget> _buildIcons(double percentage) {
    List<Widget> icons = [];
    Color levelColor = _getColorForLevel(percentage);
    for (int i = 0; i < 5; i++) {
      double fillPercentage = (percentage - (i * 20)).clamp(0, 20);
      if (fillPercentage > 0) {
        icons.add(
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 4.0),
            width: 20,
            height: 20,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.darkBorderColor,
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: fillPercentage / 20.0,
              child: Container(
                decoration: BoxDecoration(
                  color: levelColor,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        );
      } else {
        icons.add(
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 4.0),
            width: 20,
            height: 20,
            decoration: const BoxDecoration(
              color: AppColors.darkBorderColor,
              shape: BoxShape.circle,
            ),
          ),
        );
      }
    }
    return icons;
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor =
        isDarkMode ? AppColors.darkCardColor : AppColors.lightBackgroundColor;
    final textColor =
        isDarkMode
            ? AppColors.lightBackgroundColor
            : AppColors.darkBackgroundColor;
    final borderColor =
        isDarkMode
            ? AppColors.darkBorderColor.withOpacity(0.1)
            : AppColors.lightBorderColor;
    final shadowColor =
        isDarkMode ? AppColors.darkShadowColor : AppColors.lightBorderColor;

    Color levelColor = _getColorForLevel(percentage);
    String levelDescription = _getLevelDescription(percentage);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: borderColor, width: 1),
          boxShadow: [
            BoxShadow(
              color: shadowColor,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Nível',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                Text(
                  '${percentage.toStringAsFixed(0)}%',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Row(children: _buildIcons(percentage)),
                const SizedBox(width: 8),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 6.0,
                      ),
                      decoration: BoxDecoration(
                        color: levelColor,
                        borderRadius: BorderRadius.circular(22.0),
                      ),
                      child: Text(
                        levelDescription,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.lightBackgroundColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
