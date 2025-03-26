import 'package:flutter/material.dart';

class CapacityInfoWidget extends StatelessWidget {
  final double percentage;

  const CapacityInfoWidget({super.key, required this.percentage});

  Color _getColorForLevel(double percentage) {
    if (percentage > 75) {
      return Colors.green;
    } else if (percentage >= 50) {
      return Colors.amber;
    } else {
      return Colors.red;
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
    int filledIcons = (percentage / 20)
        .floor(); 
    double partialFill = percentage % 20; 

    List<Widget> icons = [];
    for (int i = 0; i < 5; i++) {
      if (i < filledIcons) {
        icons.add(Container(
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: _getColorForLevel(percentage),
            shape: BoxShape.circle,
          ),
        ));
      } else if (i == filledIcons && partialFill > 0) {
        icons.add(Container(
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: _getColorForLevel(percentage).withOpacity(0.5),
            shape: BoxShape.circle,
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: partialFill / 100,
            child: Container(
              decoration: BoxDecoration(
                color: _getColorForLevel(percentage),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ));
      } else {
        icons.add(Container(
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: Colors.grey,
            shape: BoxShape.circle,
          ),
        ));
      }
    }
    return icons;
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? const Color(0xFF18181B) : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final borderColor = isDarkMode ? Colors.grey.withOpacity(0.1) : Colors.black12;
    final shadowColor = isDarkMode ? Colors.black.withOpacity(0.2) : Colors.black.withOpacity(0.1);

    Color levelColor = _getColorForLevel(percentage);
    String levelDescription = _getLevelDescription(percentage);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: borderColor,
            width: 1,
          ),
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
                Row(
                  children: _buildIcons(percentage),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 6.0),
                      decoration: BoxDecoration(
                        color: levelColor,
                        borderRadius: BorderRadius.circular(22.0),
                      ),
                      child: Text(
                        levelDescription,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
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
