import 'package:flutter/material.dart';
import 'package:peatdashboard/widgets/humidity_chart.dart';
import 'package:peatdashboard/services/api_service.dart';

class HumidityChartScreen extends StatefulWidget {
  const HumidityChartScreen({super.key});

  @override
  State<HumidityChartScreen> createState() => _HumidityChartScreenState();
}

class _HumidityChartScreenState extends State<HumidityChartScreen> {
  List<double> humidityData = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHumidityData();
  }

  Future<void> _loadHumidityData() async {
    try {
      final data = await ApiService.fetchTemperatureAndHumidityList(10);
      setState(() {
        humidityData = data.map((e) => e.value).toList();
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        humidityData = [];
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFF090909),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF090909),
        elevation: 0,
        title: Text(
          'Humidity Chart',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      backgroundColor: const Color(0xFF090909),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              HumidityChart(humidityData: humidityData),
            ],
          ),
        ),
      ),
    );
  }
}
