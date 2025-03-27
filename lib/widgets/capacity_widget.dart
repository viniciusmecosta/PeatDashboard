import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:peatdashboard/models/sensor_level.dart';
import 'package:peatdashboard/utils/app_colors.dart';

class CapacityWidget extends StatelessWidget {
  final List<SensorLevel> sensorLevelList;
  final double last;

  const CapacityWidget({
    super.key,
    required this.sensorLevelList,
    required this.last,
  });

  Color _getBackgroundColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? AppColors.darkCardColor
        : AppColors.lightBackgroundColor;
  }

  Color _getBorderColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? AppColors.darkBorderColor.withOpacity(0.1)
        : AppColors.lightBorderColor;
  }

  Color _getShadowColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? AppColors.darkShadowColor
        : AppColors.lightBorderColor;
  }

  Color _getTextColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? AppColors.lightBackgroundColor
        : AppColors.darkBackgroundColor;
  }

  Color _getGridColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? AppColors.darkGridColor
        : AppColors.darkBorderColor;
  }

  @override
  Widget build(BuildContext context) {
    if (sensorLevelList.isEmpty) {
      return Center(
        child: Text(
          "Nenhum dado disponível no gráfico",
          style: TextStyle(color: _getTextColor(context), fontSize: 16),
        ),
      );
    }

    final capacityData = sensorLevelList.map((e) => e.capacity).toList();
    final dates = sensorLevelList.map((e) => e.date).toList();
    final lastCapacity = capacityData.last;

    final isMobile = MediaQuery.of(context).size.width < 600;
    final gap =
        isMobile
            ? (capacityData.length <= 7
                ? 1.0
                : (capacityData.length / 7).ceil().toDouble())
            : 1.0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _getBackgroundColor(context),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: _getBorderColor(context), width: 1),
          boxShadow: [
            BoxShadow(
              color: _getShadowColor(context),
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
            _buildCurrentCapacity(lastCapacity),
            const SizedBox(height: 16),
            _buildLineChart(context, capacityData, dates, gap),
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
            color: _getTextColor(context).withOpacity(0.7),
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            'Peat IFCE - Bloco Central',
            style: TextStyle(color: _getTextColor(context), fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentCapacity(double lastCapacity) {
    return Center(
      child: Text(
        '${last.toStringAsFixed(1)}%',
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
    List<double> capacityData,
    List<String> dates,
    double gap,
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
                  (value) =>
                      FlLine(color: _getGridColor(context), strokeWidth: 1),
            ),
            titlesData: FlTitlesData(
              show: true,
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 40,
                  interval: gap,
                  getTitlesWidget: (value, meta) {
                    if (value % gap == 0 && value.toInt() < dates.length) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Text(
                          dates[value.toInt()],
                          style: TextStyle(
                            color: _getTextColor(context).withOpacity(0.7),
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
                                  color: _getTextColor(
                                    context,
                                  ).withOpacity(0.7),
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
                left: BorderSide(color: _getGridColor(context), width: 1),
                bottom: BorderSide(color: _getGridColor(context), width: 1),
              ),
            ),
            lineBarsData: [
              LineChartBarData(
                spots:
                    capacityData
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
                                '${capacityData[barSpot.x.toInt()].toStringAsFixed(1)}%\n${dates[barSpot.x.toInt()]}',
                                TextStyle(
                                  color: _getTextColor(context),
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
}
