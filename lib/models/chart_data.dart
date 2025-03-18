import 'package:flutter/material.dart';

class ChartData {
  final DateTime time;
  final double value;

  ChartData(this.time, this.value);
}

class StockData {
  final DateTime time;
  final double open;
  final double high;
  final double low;
  final double close;

  StockData(this.time, this.open, this.high, this.low, this.close);
}

class PerformanceData {
  final String category;
  final double value;
  final Color color;

  PerformanceData(this.category, this.value, this.color);
} 