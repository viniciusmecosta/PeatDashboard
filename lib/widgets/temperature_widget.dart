import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:peatdashboard/models/sensor_data.dart';

class TemperatureWidget extends StatelessWidget {
  final List<SensorData> sensorDataList;

  const TemperatureWidget({super.key, required this.sensorDataList});

  @override
  Widget build(BuildContext context) {
    if (sensorDataList.isEmpty) {
      return const Center(
        child: Text(
          "Nenhum dado disponível no gráfico",
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      );
    }

    final temperatureData = sensorDataList.map((e) => e.temperature).toList();
    final dates = sensorDataList.map((e) => e.date).toList();
    final lastTemperature = temperatureData.last;
    final maxTemperature = temperatureData.reduce((a, b) => a > b ? a : b);
    final upperLimit = ((maxTemperature / 20).ceil() * 20).toDouble();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF18181B),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: Colors.grey.withOpacity(0.1)),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, 4)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildChartTitle(),
            const SizedBox(height: 16),
            _buildCurrentTemperature(lastTemperature),
            const SizedBox(height: 16),
            _buildLineChart(temperatureData, dates, upperLimit),
            const SizedBox(height: 16),
            _buildTemperatureStats(),
            const SizedBox(height: 16),
            _buildLocationInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildChartTitle() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.location_on, color: Colors.white, size: 20),
          const SizedBox(width: 8),
          const Text(
            'Peat IFCE - Bloco Central',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentTemperature(double lastTemperature) {
    return Center(
      child: Text(
        '${lastTemperature.toStringAsFixed(1)}°C',
        style: const TextStyle(color: Color(0xFF298F5E), fontSize: 28, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildLineChart(List<double> temperatureData, List<String> dates, double upperLimit) {
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
                    child: Text(dates[value.toInt()], style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 10), textAlign: TextAlign.center),
                  ),
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 40,
                  interval: 20,
                  getTitlesWidget: (value, meta) => (value % 20 == 0)
                      ? Text('${value.toInt()}°C', style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 12))
                      : const SizedBox.shrink(),
                ),
              ),
              rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            borderData: FlBorderData(show: false),
            lineBarsData: [
              LineChartBarData(
                spots: temperatureData.asMap().entries.map((entry) => FlSpot(entry.key.toDouble(), entry.value)).toList(),
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
                  '${temperatureData[barSpot.x.toInt()].toStringAsFixed(1)}°C',
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

  Widget _buildTemperatureStats() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _buildStatIcon("S"),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text("Média Semanal", style: TextStyle(color: Colors.white, fontSize: 18)),
                Text("30°C", style: TextStyle(color: Colors.grey, fontSize: 16)),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildStatIcon("M"),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text("Média Mensal", style: TextStyle(color: Colors.white, fontSize: 18)),
                Text("32°C", style: TextStyle(color: Colors.grey, fontSize: 16)),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatIcon(String letter) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.grey.shade800,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          letter,
          style: const TextStyle(color: Color(0xFF298F5E), fontSize: 26),
        ),
      ),
    );
  }

  Widget _buildLocationInfo() {
    return Container(
      width: double.infinity,
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF2D9966),  // Cor de fundo para o texto "Fortaleza"
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.wb_sunny, color: const Color(0xFFFFE151), size: 24),  // Cor do sol ajustada para #FFE151
              const SizedBox(width: 8),
              const Text(
                'Fortaleza',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              const SizedBox(width: 4),
              const Icon(Icons.location_on, color: Colors.white, size: 20),
            ],
          ),
          const Text(
            '30.5°C',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ],
      ),
    );
  }
}
