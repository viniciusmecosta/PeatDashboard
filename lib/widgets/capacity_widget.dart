import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:peatdashboard/models/sensor_level.dart';

import '../utils/app_colors.dart';

class CapacityWidget extends StatelessWidget {
  final List<SensorLevel> sensorLevelList;
  final double last;

  const CapacityWidget({
    super.key,
    required this.sensorLevelList,
    required this.last,
  });

  @override
  Widget build(BuildContext context) {
    if (sensorLevelList.isEmpty) {
      return Center(
        child: Text(
          "Nenhum dado disponível no gráfico",
          style: TextStyle(color: AppColors.textColor(context), fontSize: 16),
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
          color: AppColors.backgroundColor(context),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: AppColors.borderColor(context), width: 1),
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
            color: AppColors.textColor(context).withOpacity(0.7),
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

  Widget _buildCurrentCapacity(double lastCapacity) {
    return Center(
      child: Text(
        '${last.toStringAsFixed(1)}%',
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
                    if (value % gap == 0 && value.toInt() < dates.length) {
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
                                  color: AppColors.textColor(
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
}
