import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:peatdashboard/models/sensor_data.dart';


class TemperatureChart extends StatelessWidget {
  final List<SensorData> sensorDataList;

  const TemperatureChart({super.key, required this.sensorDataList});

  @override
  Widget build(BuildContext context) {
    List<double> temperatureData = sensorDataList.map((e) => e.temperature).toList();
    List<String> dates = sensorDataList.map((e) => e.date).toList();

    double lastHumidity = temperatureData.isNotEmpty ? temperatureData.last : 0.0;
    double maxHumidity = temperatureData.isNotEmpty ? temperatureData.reduce((a, b) => a > b ? a : b) : 0;
    double upperLimit = ((maxHumidity / 20).ceil() * 20).toDouble();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF18181B),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.grey.withOpacity(0.1),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.location_on,
                    color: Colors.white,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Peat IFCE - Bloco Central',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                '${lastHumidity.toStringAsFixed(1)}°C',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: SizedBox(
                height: 250,
                child: temperatureData.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : LineChart(
                        LineChartData(
                          minY: 0,
                          maxY: upperLimit,
                          gridData: FlGridData(
                            show: true,
                            horizontalInterval: 20,
                            drawVerticalLine: false,
                          ),
                          titlesData: FlTitlesData(
                            show: true,
                            bottomTitles: AxisTitles(

                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 40, 
                            interval: 1, 
                            getTitlesWidget: (value, meta) {
                            String dateString = dates[value.toInt()];

                            return Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Text(
                                dateString, 
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 10,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            );
                          },


                          ),
                        ),

                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 40,
                                interval: 20,
                                getTitlesWidget: (value, meta) {
                                  if (value % 20 == 0) {
                                    return Text(
                                      '${value.toInt()}°C',
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12,
                                      ),
                                    );
                                  }
                                  return const SizedBox.shrink();
                                },
                              ),
                            ),
                            rightTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            topTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                          ),
                          borderData: FlBorderData(show: false),
                          lineBarsData: [
                            LineChartBarData(
                              spots: temperatureData.asMap().entries.map((entry) {
                                return FlSpot(entry.key.toDouble(), entry.value);
                              }).toList(),
                              isCurved: true,
                              barWidth: 3,
                              color: const Color(0xFF298F5E),
                              dotData: FlDotData(show: true),
                              belowBarData: BarAreaData(
                                show: true,
                                color: const Color(0xFF298F5E).withOpacity(0.3),
                              ),
                            ),
                          ],
                          lineTouchData: LineTouchData(
                            touchTooltipData: LineTouchTooltipData(
                              getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                                return touchedBarSpots.map((barSpot) {
                                  final humidity = temperatureData[barSpot.x.toInt()];
                                  return LineTooltipItem(
                                    '${humidity.toStringAsFixed(1)}%',
                                    const TextStyle(color: Colors.white),
                                  );
                                }).toList();
                              },
                            ),
                          ),
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
