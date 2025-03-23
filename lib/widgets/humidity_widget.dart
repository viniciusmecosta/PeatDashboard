import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:peatdashboard/models/sensor_data.dart';

class HumidityWidget extends StatelessWidget {
  final List<SensorData> sensorDataList;

  const HumidityWidget({super.key, required this.sensorDataList});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? const Color(0xFF18181B) : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final borderColor = isDarkMode ? Colors.grey.withOpacity(0.1) : Colors.black12;
    final shadowColor = isDarkMode ? Colors.black.withOpacity(0.2) : Colors.black.withOpacity(0.1);

    if (sensorDataList.isEmpty) {
      return Center(
        child: Text(
          "Nenhum dado disponível no gráfico",
          style: TextStyle(color: textColor, fontSize: 16),
        ),
      );
    }

    final humidityData = sensorDataList.map((e) => e.humidity).toList();
    final dates = sensorDataList.map((e) => e.date).toList();
    final lastHumidity = humidityData.last;
    final maxHumidity = humidityData.reduce((a, b) => a > b ? a : b);
    final upperLimit = ((maxHumidity / 20).ceil() * 20).toDouble();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor, width: 1),
          boxShadow: [
            BoxShadow(color: shadowColor, blurRadius: 10, offset: const Offset(0, 4)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildChartTitle(context, textColor),
            const SizedBox(height: 16),
            _buildCurrentHumidity(context, lastHumidity, textColor),
            const SizedBox(height: 16),
            _buildLineChart(humidityData, dates, upperLimit, textColor),
          ],
        ),
      ),
    );
  }

  Widget _buildChartTitle(BuildContext context, Color textColor) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.location_on, color: textColor, size: 20),
          const SizedBox(width: 8),
          Text(
            'Peat IFCE - Bloco Central',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(color: textColor),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentHumidity(BuildContext context, double lastHumidity, Color textColor) {
    return Center(
      child: Text(
        '${lastHumidity.toStringAsFixed(1)}%',
        style: Theme.of(context).textTheme.titleLarge?.copyWith(color: textColor, fontSize: 24),
      ),
    );
  }

  Widget _buildLineChart(List<double> humidityData, List<String> dates, double upperLimit, Color textColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: SizedBox(
        height: 250,
        child: LineChart(
          LineChartData(
            minY: 0,
            maxY: upperLimit,
            gridData: FlGridData(show: true, horizontalInterval: 20, drawVerticalLine: false),
            titlesData: FlTitlesData(
              show: true,
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 40,
                  interval: 1,
                  getTitlesWidget: (value, meta) => Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text(dates[value.toInt()], style: TextStyle(color: textColor.withOpacity(0.7), fontSize: 10), textAlign: TextAlign.center),
                  ),
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 40,
                  interval: 20,
                  getTitlesWidget: (value, meta) => (value % 20 == 0)
                      ? Text('${value.toInt()}%', style: TextStyle(color: textColor.withOpacity(0.7), fontSize: 12))
                      : const SizedBox.shrink(),
                ),
              ),
              rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            borderData: FlBorderData(show: false),
            lineBarsData: [
              LineChartBarData(
                spots: humidityData.asMap().entries.map((entry) => FlSpot(entry.key.toDouble(), entry.value)).toList(),
                isCurved: true,
                barWidth: 3,
                color: const Color(0xFF298F5E),
                dotData: FlDotData(show: true),
                belowBarData: BarAreaData(show: true, color: const Color(0xFF298F5E).withOpacity(0.3)),
              ),
            ],
            lineTouchData: LineTouchData(
              touchTooltipData: LineTouchTooltipData(
                getTooltipItems: (List<LineBarSpot> touchedBarSpots) => touchedBarSpots
                    .map((barSpot) => LineTooltipItem(
                  '${humidityData[barSpot.x.toInt()].toStringAsFixed(1)}%',
                  TextStyle(color: textColor),
                ))
                    .toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
