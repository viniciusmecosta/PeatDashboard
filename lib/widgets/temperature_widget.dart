import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:peatdashboard/models/feeder.dart';
import 'package:peatdashboard/models/sensor_data.dart';
import 'package:peatdashboard/services/peat_data_service.dart';
import 'package:peatdashboard/utils/app_colors.dart';

class TemperatureWidget extends StatefulWidget {
  final List<SensorData> sensorDataList;
  final Feeder feeder;

  const TemperatureWidget({
    super.key,
    required this.sensorDataList,
    required this.feeder,
  });

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
    final weekly = await PeatDataService.fetchAverageTemperatureAndHumidity(
      7,
      widget.feeder.id,
    );
    final monthly = await PeatDataService.fetchAverageTemperatureAndHumidity(
      31,
      widget.feeder.id,
    );

    if (mounted) {
      setState(() {
        weeklyAverage = weekly.temperature;
        monthlyAverage = monthly.temperature;
      });
    }
  }

  Future<void> _loadCurrentTemperature() async {
    final data = await PeatDataService.fetchTemperatureAndHumidity(
      widget.feeder.id,
    );
    if (mounted) {
      setState(() {
        currentTemperature = data["temperature"]?.temperature ?? 0.0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor =
        isDarkMode ? AppColors.darkCardColor : AppColors.lightBackgroundColor;
    final textColor =
        isDarkMode
            ? AppColors.lightBackgroundColor
            : AppColors.darkBackgroundColor;
    final borderColor =
        isDarkMode
            ? AppColors.darkBorderColor.withOpacity(0.1)
            : AppColors.lightBorderColor;
    final shadowColor =
        isDarkMode ? AppColors.darkShadowColor : AppColors.shadow;
    final gridColor =
        isDarkMode ? AppColors.darkGridColor : AppColors.darkBorderColor;
    final statIconBackgroundColor =
        isDarkMode
            ? AppColors.primary.withOpacity(0.1)
            : AppColors.primary.withOpacity(0.1);
    final secondaryTextColor =
        isDarkMode ? AppColors.darkBorderColor : AppColors.lightSecondaryText;

    if (widget.sensorDataList.isEmpty) {
      return Center(
        child: Text(
          "Nenhum dado disponível no gráfico",
          style: TextStyle(color: textColor, fontSize: 16),
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
          color: backgroundColor,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: borderColor, width: 1),
          boxShadow: [
            BoxShadow(
              color: shadowColor,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildChartTitle(textColor),
            const SizedBox(height: 16),
            _buildCurrentTemperature(currentTemperature),
            const SizedBox(height: 16),
            _buildLineChart(
              context,
              temperatureData,
              dates,
              gap,
              textColor,
              gridColor,
            ),
            const SizedBox(height: 16),
            _buildTemperatureStats(
              textColor,
              secondaryTextColor,
              statIconBackgroundColor,
            ),
            const SizedBox(height: 16),
            _buildLocationInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildChartTitle(Color textColor) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.location_on, color: textColor.withOpacity(0.7), size: 20),
          const SizedBox(width: 8),
          Text(
            widget.feeder.name,
            style: TextStyle(color: textColor, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentTemperature(double currentTemp) {
    return Center(
      child: Text(
        '${currentTemp.toStringAsFixed(1)}°C',
        style: const TextStyle(
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
    Color textColor,
    Color gridColor,
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
                  (value) => FlLine(color: gridColor, strokeWidth: 1),
            ),
            titlesData: FlTitlesData(
              show: true,
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 40,
                  interval: gap,
                  getTitlesWidget: (value, meta) {
                    if (value.toInt() < dates.length && value % gap == 0) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Text(
                          dates[value.toInt()],
                          style: TextStyle(
                            color: textColor.withOpacity(0.7),
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
                            color: textColor.withOpacity(0.7),
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
                left: BorderSide(color: gridColor, width: 1),
                bottom: BorderSide(color: gridColor, width: 1),
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
                                TextStyle(color: textColor, fontSize: 14),
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

  Widget _buildTemperatureStats(
    Color textColor,
    Color secondaryTextColor,
    Color iconBackgroundColor,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStatRow(
          "S",
          "Média Semanal",
          "${weeklyAverage.toStringAsFixed(1)}°C",
          textColor,
          secondaryTextColor,
          iconBackgroundColor,
        ),
        const SizedBox(height: 12),
        _buildStatRow(
          "M",
          "Média Mensal",
          "${monthlyAverage.toStringAsFixed(1)}°C",
          textColor,
          secondaryTextColor,
          iconBackgroundColor,
        ),
      ],
    );
  }

  Widget _buildStatRow(
    String iconText,
    String title,
    String value,
    Color textColor,
    Color secondaryTextColor,
    Color iconBackgroundColor,
  ) {
    return Row(
      children: [
        _buildStatIcon(iconText, iconBackgroundColor),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(color: textColor, fontSize: 18)),
            Text(
              value,
              style: TextStyle(color: secondaryTextColor, fontSize: 16),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatIcon(String letter, Color backgroundColor) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(color: backgroundColor, shape: BoxShape.circle),
      child: Center(
        child: Text(
          letter,
          style: const TextStyle(
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
          const Row(
            children: [
              Icon(Icons.wb_sunny, color: AppColors.accent, size: 24),
              SizedBox(width: 8),
              Text(
                'Fortaleza',
                style: TextStyle(
                  color: AppColors.lightBackgroundColor,
                  fontSize: 18,
                ),
              ),
              SizedBox(width: 4),
              Icon(
                Icons.location_on,
                color: AppColors.lightBackgroundColor,
                size: 20,
              ),
            ],
          ),
          Text(
            '${currentTemperature.toStringAsFixed(1)}°C',
            style: const TextStyle(
              color: AppColors.lightBackgroundColor,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}
