import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:peatdashboard/models/sensor_data.dart';
import 'package:peatdashboard/services/api_service.dart';

class TemperatureWidget extends StatefulWidget {
  final List<SensorData> sensorDataList;

  const TemperatureWidget({super.key, required this.sensorDataList});

  @override
  State<TemperatureWidget> createState() => _TemperatureWidgetState();
}

class _TemperatureWidgetState extends State<TemperatureWidget> {
  double weeklyAverage = 0.0;
  double monthlyAverage = 0.0;
  double currentTemperature = 0.0;

  @override
  void initState() {
    super.initState();
    _loadAverages();
    _loadCurrentTemperature();
  }

  Future<void> _loadAverages() async {
    final weekly = await ApiService.fetchAverageTemperatureAndHumidity(7);
    final monthly = await ApiService.fetchAverageTemperatureAndHumidity(31);

    setState(() {
      weeklyAverage = weekly.temperature;
      monthlyAverage = monthly.temperature;
    });
  }

  Future<void> _loadCurrentTemperature() async {
    final data = await ApiService.fetchTemperatureAndHumidity();
    setState(() {
      currentTemperature = data["temperature"]?.temperature ?? 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    if (widget.sensorDataList.isEmpty) {
      return Center(
        child: Text(
          "Nenhum dado disponível no gráfico",
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black,
            fontSize: 16,
          ),
        ),
      );
    }

    final temperatureData = widget.sensorDataList.map((e) => e.temperature).toList();
    final dates = widget.sensorDataList.map((e) => e.date).toList();
    final maxTemperature = temperatureData.reduce((a, b) => a > b ? a : b);
    final upperLimit = ((maxTemperature / 20).ceil() * 20).toDouble();

    final isMobile = MediaQuery.of(context).size.width < 600;
    final gap = isMobile
        ? (temperatureData.length <= 7 ? 1.0 : (temperatureData.length / 7).ceil().toDouble())
        : 1.0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDarkMode ? const Color(0xFF18181B) : Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: isDarkMode ? Colors.grey.withOpacity(0.1) : Colors.black.withOpacity(0.1),
          ),
          boxShadow: [
            BoxShadow(
              color: isDarkMode ? Colors.black.withOpacity(0.2) : Colors.grey.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildChartTitle(isDarkMode),
            const SizedBox(height: 16),
            _buildCurrentTemperature(currentTemperature, isDarkMode),
            const SizedBox(height: 16),
            _buildLineChart(temperatureData, dates, upperLimit, gap, isDarkMode),
            const SizedBox(height: 16),
            _buildTemperatureStats(isDarkMode),
            const SizedBox(height: 16),
            _buildLocationInfo(isDarkMode),
          ],
        ),
      ),
    );
  }

  Widget _buildChartTitle(bool isDarkMode) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.location_on, color: isDarkMode ? Colors.white : Colors.black, size: 20),
          const SizedBox(width: 8),
          Text(
            'Peat IFCE - Bloco Central',
            style: TextStyle(color: isDarkMode ? Colors.white : Colors.black, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentTemperature(double currentTemperature, bool isDarkMode) {
    return Center(
      child: Text(
        '${currentTemperature.toStringAsFixed(1)}°C',
        style: TextStyle(
          color: isDarkMode ? const Color(0xFF298F5E) : const Color(0xFF298F5E),
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildLineChart(List<double> temperatureData, List<String> dates, double upperLimit, double gap, bool isDarkMode) {
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
                  interval: gap,
                  getTitlesWidget: (value, meta) => Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Text(
                      dates[value.toInt()],
                      style: TextStyle(
                        color: isDarkMode
                            ? Colors.white.withOpacity(0.7)
                            : Colors.black.withOpacity(0.7),
                        fontSize: 10,
                      ),
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
                      ? Text(
                    '${value.toInt()}°C',
                    style: TextStyle(
                      color: isDarkMode
                          ? Colors.white.withOpacity(0.7)
                          : Colors.black.withOpacity(0.7),
                      fontSize: 12,
                    ),
                  )
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
                color: isDarkMode ? const Color(0xFF298F5E) : const Color(0xFF298F5E),
                dotData: FlDotData(show: true),
                belowBarData: BarAreaData(show: true, color: const Color(0xFF298F5E).withOpacity(0.3)),
              ),
            ],
            lineTouchData: LineTouchData(
              touchTooltipData: LineTouchTooltipData(
                getTooltipItems: (List<LineBarSpot> touchedBarSpots) => touchedBarSpots
                    .map((barSpot) => LineTooltipItem(
                  '${temperatureData[barSpot.x.toInt()].toStringAsFixed(1)}°C',
                  TextStyle(color: isDarkMode ? Colors.white : Colors.black),
                ))
                    .toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTemperatureStats(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _buildStatIcon("S", isDarkMode),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Média Semanal",
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                    fontSize: 18,
                  ),
                ),
                Text(
                  "${weeklyAverage.toStringAsFixed(1)}°C",
                  style: TextStyle(
                    color: isDarkMode ? Colors.grey : Colors.grey.shade600,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildStatIcon("M", isDarkMode),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Média Mensal",
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                    fontSize: 18,
                  ),
                ),
                Text(
                  "${monthlyAverage.toStringAsFixed(1)}°C",
                  style: TextStyle(
                    color: isDarkMode ? Colors.grey : Colors.grey.shade600,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatIcon(String letter, bool isDarkMode) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade300,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          letter,
          style: TextStyle(color: const Color(0xFF298F5E), fontSize: 26),
        ),
      ),
    );
  }

  Widget _buildLocationInfo(bool isDarkMode) {
    return Container(
      width: double.infinity,
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF2D9966) : const Color(0xFF2D9966),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.wb_sunny, color: const Color(0xFFFFE151), size: 24),
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
