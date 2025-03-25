import 'package:flutter/material.dart';

class CapacityInfoWidget extends StatelessWidget {
  final double percentage;

  const CapacityInfoWidget({Key? key, required this.percentage})
      : super(key: key);

  Color _getColorForLevel(double percentage) {
    if (percentage > 75) {
      return Colors.green; // Bom
    } else if (percentage >= 50) {
      return Colors.amber; // Médio
    } else {
      return Colors.red; // Ruim
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
        .floor(); // Quantidade de ícones cheios para 5 bolas
    double partialFill = percentage % 20; // Porcentagem da última bola

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
            // Bola parcialmente preenchida
            shape: BoxShape.circle,
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: partialFill / 100, // Define o preenchimento parcial
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
    final theme = Theme.of(context);

    Color levelColor = _getColorForLevel(percentage);
    String levelDescription = _getLevelDescription(percentage);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: theme.dividerColor.withOpacity(0.1),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor.withOpacity(0.1),
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
                  ),
                ),
                Text(
                  '${percentage.toStringAsFixed(0)}%',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
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