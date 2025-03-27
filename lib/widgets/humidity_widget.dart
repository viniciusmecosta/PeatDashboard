import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:peatdashboard/models/sensor_data.dart';
import 'package:peatdashboard/services/api_service.dart';
import 'package:peatdashboard/utils/app_colors.dart';

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
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode
        ? AppColors.darkCardColor
        : AppColors.lightBackgroundColor;
    final textColor = isDarkMode
        ? AppColors.lightBackgroundColor
        : AppColors.darkBackgroundColor;
    final borderColor = isDarkMode
        ? AppColors.darkBorderColor.withOpacity(0.1)
        : AppColors.lightBorderColor;
    final shadowColor = isDarkMode
        ? AppColors.darkShadowColor
        : AppColors.darkBorderColor;
    final gridColor = isDarkMode
        ? AppColors.darkGridColor
        : AppColors.darkBorderColor;
    final statIconBackgroundColor = isDarkMode
        ? AppColors.primary.withOpacity(0.1)
        : AppColors.primary.withOpacity(0.1);
    final secondaryTextColor = isDarkMode
        ? AppColors.darkBorderColor
        : AppColors.lightSecondaryText;

    if (widget.sensorDataList.isEmpty) {
      return Center(
        child: Text(
          "Nenhum dado disponível no gráfico",
          style: TextStyle(color: textColor, fontSize: 16),
        ),
      );
    }

    final humidityData = widget.sensorDataList.map((e) => e.humidity).toList();
    final dates = widget.sensorDataList.map((e) => e.date).toList();

    final isMobile = MediaQuery.of(context).size.width < 600;
    final gap = isMobile
        ? (humidityData.length <= 7
            ? 1.0
            : (humidityData.length / 7).ceil().toDouble())
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
            _buildCurrentHumidity(currentHumidity),
            const SizedBox(height: 16),
            _buildLineChart(context, humidityData, dates, gap, textColor, gridColor),
            const SizedBox(height: 16),
            _buildHumidityStats(textColor, secondaryTextColor, statIconBackgroundColor),
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
          Icon(
            Icons.location_on,
            color: textColor.withOpacity(0.7),
            size: 20,
          ),
          const SizedBox(width: 8),
         Text(
            'Peat IFCE - Bloco Central',
            style: TextStyle(
              color: textColor,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentHumidity(double currentHumidity) {
    return Center(
      child: Text(
        '${currentHumidity.toStringAsFixed(1)}%',
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
    List<double> humidityData,
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
            minY: 0,
            maxY: 100,
            gridData: FlGridData(
              show: true,
              horizontalInterval: 20,
              drawVerticalLine: false,
              getDrawingHorizontalLine:
                  (value) => FlLine(
                    color: gridColor,
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
                  interval: 20,
                  getTitlesWidget:
                      (value, meta) =>
                          (value % 20 == 0)
                              ? Text(
                                  '${value.toInt()}%',
                                  style: TextStyle(
                                    color: textColor.withOpacity(0.7),
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
                left: BorderSide(color: gridColor, width: 1),
                bottom: BorderSide(
                  color: gridColor,
                  width: 1,
                ),
              ),
            ),
            lineBarsData: [
              LineChartBarData(
                spots: humidityData
                    .asMap()
                    .entries
                    .map((entry) => FlSpot(entry.key.toDouble(), entry.value))
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
                                  color: textColor,
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

  Widget _buildHumidityStats(Color textColor, Color secondaryTextColor, Color iconBackgroundColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStatRow(
          "S",
          "Média Semanal",
          "${weeklyAverage.toStringAsFixed(1)}%",
          textColor,
          secondaryTextColor,
          iconBackgroundColor,
        ),
        const SizedBox(height: 12),
        _buildStatRow(
          "M",
          "Média Mensal",
          "${monthlyAverage.toStringAsFixed(1)}%",
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
            Text(
              title,
              style: TextStyle(
                color: textColor,
                fontSize: 18,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                color: secondaryTextColor,
                fontSize: 16,
              ),
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
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
      ),
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
          Row(
            children: [
              const Icon(Icons.wb_sunny, color: AppColors.accent, size: 24),
              const SizedBox(width: 8),
              const Text(
                'Fortaleza',
                style: TextStyle(color: AppColors.lightBackgroundColor, fontSize: 18),
              ),
              const SizedBox(width: 4),
              const Icon(Icons.location_on, color: AppColors.lightBackgroundColor, size: 20),
            ],
          ),
          Text(
            '${currentHumidity.toStringAsFixed(0)}%',
            style: const TextStyle(color: AppColors.lightBackgroundColor, fontSize: 18),
          ),
        ],
      ),
    );
  }
}