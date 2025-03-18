import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

import '../models/chart_data.dart';

class StockChartWidget extends StatelessWidget {
  final List<StockData> data;
  final String title;

  const StockChartWidget({
    super.key,
    required this.data,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Real-time pricing data',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: SfCartesianChart(
              plotAreaBorderWidth: 0,
              primaryXAxis: DateTimeAxis(
                dateFormat: DateFormat('HH:mm'),
                intervalType: DateTimeIntervalType.minutes,
                majorGridLines: const MajorGridLines(width: 0),
                labelStyle: const TextStyle(
                  color: Colors.grey,
                  fontSize: 10,
                ),
              ),
              primaryYAxis: NumericAxis(
                labelFormat: '{value}',
                majorGridLines: const MajorGridLines(
                  width: 1,
                  color: Colors.grey,
                  dashArray: <double>[5, 5],
                ),
                labelStyle: const TextStyle(
                  color: Colors.grey,
                  fontSize: 10,
                ),
              ),
              series: <CartesianSeries>[
                CandleSeries<StockData, DateTime>(
                  dataSource: data,
                  xValueMapper: (StockData data, _) => data.time,
                  lowValueMapper: (StockData data, _) => data.low,
                  highValueMapper: (StockData data, _) => data.high,
                  openValueMapper: (StockData data, _) => data.open,
                  closeValueMapper: (StockData data, _) => data.close,
                  bullColor: Colors.green,
                  bearColor: Colors.red,
                  enableSolidCandles: true,
                  animationDuration: 0,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 