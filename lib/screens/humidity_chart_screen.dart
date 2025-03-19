import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../widgets/humidity_chart.dart';

class HumidityChartScreen extends StatefulWidget {
  const HumidityChartScreen({super.key});

  @override
  _HumidityChartScreenState createState() => _HumidityChartScreenState();
}

class _HumidityChartScreenState extends State<HumidityChartScreen> {
  List<SensorData> sensorDataList = [];
  List<double> humidityData = [];

  @override
  void initState() {
    super.initState();
    _fetchHumidityData();
  }

  Future<void> _fetchHumidityData() async {
    List<SensorData> data = await ApiService.fetchTemperatureAndHumidityList(10);

    setState(() {
      sensorDataList = data;
      humidityData = sensorDataList.map((e) => e.humidity).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    double lastHumidity = humidityData.isNotEmpty ? humidityData.last : 0.0;

    return Scaffold(
      backgroundColor: const Color(0xFF090909),
      appBar: AppBar(
        backgroundColor: const Color(0xFF090909),
        elevation: 0,
        title: const Text('Umidade'),
      ),
      body: SafeArea(
        child: humidityData.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [

                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  child: HumidityChart(sensorDataList: sensorDataList),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
