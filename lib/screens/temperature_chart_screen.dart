import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../widgets/temperature_chart.dart';

class TemperatureChartScreen extends StatefulWidget {
  const TemperatureChartScreen({super.key});

  @override
  _TemperatureChartScreenState createState() => _TemperatureChartScreenState();
}

class _TemperatureChartScreenState extends State<TemperatureChartScreen> {
  List<SensorData> sensorDataList = [];
  List<double> temperatureData = [];

  @override
  void initState() {
    super.initState();
    _fetchTemperatureData();
  }

  Future<void> _fetchTemperatureData() async {
    List<SensorData> data = await ApiService.fetchTemperatureAndHumidityList(10);

    setState(() {
      sensorDataList = data;
      temperatureData = sensorDataList.map((e) => e.value).toList();
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF090909),
      appBar: AppBar(
        backgroundColor: const Color(0xFF090909),
        elevation: 0,
        title: const Text('Gráfico de Temperatura'),
      ),
      body: SafeArea(
        child: temperatureData.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            height: 350,
            child: TemperatureChart(sensorDataList: sensorDataList),
          ),
        ),
      ),
    );
  }
}
