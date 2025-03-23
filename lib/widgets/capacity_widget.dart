import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:peatdashboard/models/sensor_level.dart';

class CapacityWidget extends StatelessWidget {
  final List<SensorLevel> sensorLevelList;

  const CapacityWidget({super.key, required this.sensorLevelList});

  @override
  Widget build(BuildContext context) {
    if (sensorLevelList.isEmpty) {
      return const Center(
        child: Text(
          "Nenhum dado disponível no gráfico",
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      );
    }

    final levelData = sensorLevelList.map((e) => e.capacity).toList();
    final dates = sensorLevelList.map((e) => e.date).toList();
    final lastLevel = levelData.last;
    final maxLevel = levelData.reduce((a, b) => a > b ? a : b);
    final upperLimit = ((maxLevel / 20).ceil() * 20).toDouble();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF18181B),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.withOpacity(0.1), width: 1),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, 4)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildChartTitle(context),
            const SizedBox(height: 16),
            _buildCurrentLevel(context, lastLevel),
            const SizedBox(height: 16),
            _buildLineChart(levelData, dates, upperLimit),
          ],
        ),
      ),
    );
  }

  Widget _buildChartTitle(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.location_on, color: Colors.white, size: 20),
          const SizedBox(width: 8),
          Text(
            'Peat IFCE - Bloco Central',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentLevel(BuildContext context, double lastLevel) {
    return Center(
      child: Text(
        '${lastLevel.toStringAsFixed(1)}%',
        style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white, fontSize: 24),
      ),
    );
  }

  Widget _buildLineChart(List<double> levelData, List<String> dates, double upperLimit) {
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
                    child: Text(
                      dates[value.toInt()],
                      style: const TextStyle(color: Colors.grey, fontSize: 10),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 40,
                  interval: 20,
                  getTitlesWidget: (value, meta) => (value % 20 == 0)
                      ? Text('${value.toInt()}%', style: const TextStyle(color: Colors.grey, fontSize: 12))
                      : const SizedBox.shrink(),
                ),
              ),
              rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            borderData: FlBorderData(show: false),
            lineBarsData: [
              LineChartBarData(
                spots: levelData.asMap().entries.map((entry) => FlSpot(entry.key.toDouble(), entry.value)).toList(),
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
                  '${levelData[barSpot.x.toInt()].toStringAsFixed(1)}%',
                  const TextStyle(color: Colors.white),
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
