import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:peatdashboard/models/sensor_data.dart';
import 'package:peatdashboard/services/api_service.dart';

import '../utils/app_colors.dart';

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
    if (widget.sensorDataList.isEmpty) {
      return Center(
        child: Text(
          "Nenhum dado disponível no gráfico",
          style: TextStyle(color: AppColors.textColor(context), fontSize: 16),
        ),
      );
    }

    final temperatureData =
        widget.sensorDataList.map((e) => e.temperature).toList();
    final dates = widget.sensorDataList.map((e) => e.date).toList();

    final isMobile = MediaQuery.of(context).size.width < 600;
    final gap =
        isMobile
            ? (temperatureData.length <= 7
                ? 1.0
                : (temperatureData.length / 7).ceil().toDouble())
            : 1.0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.backgroundColor(context),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: AppColors.borderColor(context)),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowColor(context),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildChartTitle(context),
            const SizedBox(height: 16),
            _buildCurrentTemperature(currentTemperature),
            const SizedBox(height: 16),
            _buildLineChart(context, temperatureData, dates, gap),
            const SizedBox(height: 16),
            _buildTemperatureStats(context),
            const SizedBox(height: 16),
            _buildLocationInfo(),
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
          Icon(
            Icons.location_on,
            color: AppColors.textColor(context),
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            'Peat IFCE - Bloco Central',
            style: TextStyle(color: AppColors.textColor(context), fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentTemperature(double currentTemp) {
    return Center(
      child: Text(
        '${currentTemp.toStringAsFixed(1)}°C',
        style: TextStyle(
          color: AppColors.primary,
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildLineChart(
    BuildContext context,
    List<double> temperatureData,
    List<String> dates,
    double gap,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: SizedBox(
        height: 250,
        child: LineChart(
          LineChartData(
            minY: 16,
            maxY: 40,
            gridData: FlGridData(
              show: true,
              horizontalInterval: 4,
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
                  interval: 4,
                  getTitlesWidget: (value, meta) {
                    if (value % 4 == 0 && value >= 16 && value <= 40) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 4.0),
                        child: Text(
                          '${value.toInt()}°C',
                          style: TextStyle(
                            color: AppColors.textColor(
                              context,
                            ).withOpacity(0.7),
                            fontSize: 12,
                          ),
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
                    temperatureData
                        .asMap()
                        .entries
                        .map(
                          (entry) => FlSpot(entry.key.toDouble(), entry.value),
                        )
                        .toList(),
                isCurved: true,
                curveSmoothness: 0.3,
                barWidth: 3,
                color: AppColors.primary,
                dotData: FlDotData(
                  show: true,
                  getDotPainter:
                      (spot, percent, barData, index) => FlDotCirclePainter(
                        radius: 4,
                        color: AppColors.primary,
                        strokeWidth: 2,
                      ),
                ),
                belowBarData: BarAreaData(
                  show: true,
                  color: AppColors.primary.withOpacity(0.2),
                  cutOffY: 16,
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
                                '${temperatureData[barSpot.x.toInt()].toStringAsFixed(1)}°C\n${dates[barSpot.x.toInt()]}',
                                TextStyle(
                                  color: AppColors.textColor(context),
                                  fontSize: 14,
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

  Widget _buildTemperatureStats(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStatRow(
          context,
          "S",
          "Média Semanal",
          "${weeklyAverage.toStringAsFixed(1)}°C",
        ),
        const SizedBox(height: 12),
        _buildStatRow(
          context,
          "M",
          "Média Mensal",
          "${monthlyAverage.toStringAsFixed(1)}°C",
        ),
      ],
    );
  }

  Widget _buildStatRow(
    BuildContext context,
    String iconText,
    String title,
    String value,
  ) {
    return Row(
      children: [
        _buildStatIcon(iconText),
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

  Widget _buildStatIcon(String letter) {
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
            '30.5°C',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ],
      ),
    );
  }
}
