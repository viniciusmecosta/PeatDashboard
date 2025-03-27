import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:peatdashboard/models/sensor_data.dart';
import 'package:peatdashboard/services/api_service.dart';

import '../utils/app_colors.dart';

class HumidityWidget extends StatefulWidget {
  final List<SensorData> sensorDataList;

  const HumidityWidget({super.key, required this.sensorDataList});

  @override
  State<HumidityWidget> createState() => _HumidityWidgetState();
}

class _HumidityWidgetState extends State<HumidityWidget> {
  double weeklyAverage = 0.0;
  double monthlyAverage = 0.0;
  double currentHumidity = 0.0;

  @override
  void initState() {
    super.initState();
    _loadAverages();
    _loadCurrentTemperatureAndHumidity();
  }

  Future<void> _loadAverages() async {
    final weekly = await ApiService.fetchAverageTemperatureAndHumidity(7);
    final monthly = await ApiService.fetchAverageTemperatureAndHumidity(31);

    setState(() {
      weeklyAverage = weekly.humidity;
      monthlyAverage = monthly.humidity;
    });
  }

  Future<void> _loadCurrentTemperatureAndHumidity() async {
    final data = await ApiService.fetchTemperatureAndHumidity();
    setState(() {
      currentHumidity = data["humidity"]?.humidity ?? 0.0;
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

    final humidityData = widget.sensorDataList.map((e) => e.humidity).toList();
    final dates = widget.sensorDataList.map((e) => e.date).toList();

    final isMobile = MediaQuery.of(context).size.width < 600;
    final gap =
        isMobile
            ? (humidityData.length <= 7
                ? 1.0
                : (humidityData.length / 7).ceil().toDouble())
            : 1.0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDarkMode ? const Color(0xFF18181B) : Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color:
                isDarkMode
                    ? Colors.grey.withOpacity(0.1)
                    : Colors.black.withOpacity(0.1),
          ),
          boxShadow: [
            BoxShadow(
              color:
                  isDarkMode
                      ? Colors.black.withOpacity(0.2)
                      : Colors.grey.withOpacity(0.2),
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
            _buildCurrentHumidity(currentHumidity, isDarkMode),
            const SizedBox(height: 16),
            _buildLineChart(context, humidityData, dates, gap, isDarkMode),
            const SizedBox(height: 16),
            _buildHumidityStats(context, isDarkMode),
            const SizedBox(height: 16),
            _buildLocationInfo(),
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
          Icon(
            Icons.location_on,
            color: isDarkMode ? Colors.white : Colors.black,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            'Peat IFCE - Bloco Central',
            style: TextStyle(
              color: isDarkMode ? Colors.white : Colors.black,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentHumidity(double currentHumidity, bool isDarkMode) {
    return Center(
      child: Text(
        '${currentHumidity.toStringAsFixed(1)}%',
        style: TextStyle(
          color: isDarkMode ? const Color(0xFF298F5E) : const Color(0xFF298F5E),
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildLineChart(
    BuildContext context,
    List<double> humidityData,
    List<String> dates,
    double gap,
    bool isDarkMode,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: SizedBox(
        height: 250,
        child: LineChart(
          LineChartData(
            minY: 0,
            maxY: 100,
            gridData: FlGridData(
              show: true,
              horizontalInterval: 20,
              drawVerticalLine: false,
              getDrawingHorizontalLine:
                  (value) => FlLine(
                    color: AppColors.gridColor(context),
                    strokeWidth: 1,
                  ),
            ),
            titlesData: FlTitlesData(
              show: true,
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 40,
                  interval: gap,
                  getTitlesWidget: (value, meta) {
                    if (value.toInt() < dates.length) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Text(
                          dates[value.toInt()],
                          style: TextStyle(
                            color: AppColors.textColor(
                              context,
                            ).withOpacity(0.7),
                            fontSize: 10,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 40,
                  interval: 20,
                  getTitlesWidget:
                      (value, meta) =>
                          (value % 20 == 0)
                              ? Text(
                                '${value.toInt()}%',
                                style: TextStyle(
                                  color:
                                      isDarkMode
                                          ? Colors.white.withOpacity(0.7)
                                          : Colors.black.withOpacity(0.7),
                                  fontSize: 12,
                                ),
                              )
                              : const SizedBox.shrink(),
                ),
              ),
              rightTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            borderData: FlBorderData(
              show: true,
              border: Border(
                left: BorderSide(color: AppColors.gridColor(context), width: 1),
                bottom: BorderSide(
                  color: AppColors.gridColor(context),
                  width: 1,
                ),
              ),
            ),
            lineBarsData: [
              LineChartBarData(
                spots:
                    humidityData
                        .asMap()
                        .entries
                        .map(
                          (entry) => FlSpot(entry.key.toDouble(), entry.value),
                        )
                        .toList(),
                isCurved: true,
                curveSmoothness: 0.3,
                barWidth: 3,
                color: Color(0xFF298F5E),
                dotData: FlDotData(
                  show: true,
                  getDotPainter:
                      (spot, percent, barData, index) => FlDotCirclePainter(
                        radius: 4,
                        color: Color(0xFF298F5E),
                        strokeWidth: 2,
                      ),
                ),
                belowBarData: BarAreaData(
                  show: true,
                  color: Color(0xFF298F5E).withOpacity(0.2),
                  cutOffY: 0,
                  applyCutOffY: true,
                ),
              ),
            ],
            lineTouchData: LineTouchData(
              touchTooltipData: LineTouchTooltipData(
                getTooltipItems:
                    (List<LineBarSpot> touchedBarSpots) =>
                        touchedBarSpots
                            .map(
                              (barSpot) => LineTooltipItem(
                                '${humidityData[barSpot.x.toInt()].toStringAsFixed(1)}%\n${dates[barSpot.x.toInt()]}',
                                TextStyle(
                                  color:
                                      isDarkMode ? Colors.white : Colors.black,
                                ),
                              ),
                            )
                            .toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHumidityStats(BuildContext context, bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStatRow(
          context,
          "S",
          "Média Semanal",
          "${weeklyAverage.toStringAsFixed(1)}%",
          isDarkMode,
        ),
        const SizedBox(height: 12),
        _buildStatRow(
          context,
          "M",
          "Média Mensal",
          "${monthlyAverage.toStringAsFixed(1)}%",
          isDarkMode,
        ),
      ],
    );
  }

  Widget _buildStatRow(
    BuildContext context,
    String iconText,
    String title,
    String value,
    bool isDarkMode,
  ) {
    return Row(
      children: [
        _buildStatIcon(iconText, isDarkMode),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: AppColors.textColor(context),
                fontSize: 18,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                color: AppColors.secondaryTextColor(context),
                fontSize: 16,
              ),
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
        color: AppColors.primary.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          letter,
          style: TextStyle(
            color: AppColors.primary,
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
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
        color: AppColors.primaryDark,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.wb_sunny, color: AppColors.accent, size: 24),
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
            '60%',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ],
      ),
    );
  }
}
