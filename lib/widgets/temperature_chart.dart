import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart'; // Import intl package

import '../services/api_service.dart';

class TemperatureChart extends StatelessWidget {
  final List<SensorData> sensorDataList;

  const TemperatureChart({super.key, required this.sensorDataList});

  @override
  Widget build(BuildContext context) {
    // Extract temperature values from sensorDataList
    List<double> temperatureData = sensorDataList.map((e) => e.value).toList();
    List<String> dates = sensorDataList.map((e) => e.date).toList();

    // Create DateFormat for displaying time only
    DateFormat dateFormat = DateFormat('HH:mm'); // Format for time only

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0), // Add padding to the sides
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
            Text(
              'Temperatura ao longo do tempo',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0), // Padding extra
              child: SizedBox(
                height: 250, // Set a fixed height for the chart
                child: temperatureData.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : LineChart(
                  LineChartData(
                    gridData: FlGridData(show: true),
                    titlesData: FlTitlesData(
                      show: true,
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 30,
                          interval: 1,
                          getTitlesWidget: (value, meta) {
                            // Format the time for each point (only time)
                            String formattedTime = dateFormat.format(
                              DateTime.parse(dates[value.toInt()]),
                            );

                            return Padding(
                              padding: const EdgeInsets.only(top: 10.0), // Space below the hours
                              child: Text(
                                formattedTime,
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 10,  // Slightly larger font size
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
                          interval: 10,
                          getTitlesWidget: (value, meta) {
                            return Text(
                              '${value.toInt()}°C',
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            );
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
                        color: const Color(0xFF8B5CF6),
                        barWidth: 3,
                        belowBarData: BarAreaData(
                          show: true,
                          color: const Color(0xFF8B5CF6).withOpacity(0.2),
                        ),
                      ),
                    ],
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
