import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../widgets/temperature_avg_chart.dart';

class TemperatureAvgChartScreen extends StatefulWidget {
  const TemperatureAvgChartScreen({super.key});


  @override
  _TemperatureAvgChartScreenState createState() => _TemperatureAvgChartScreenState();
}

class _TemperatureAvgChartScreenState extends State<TemperatureAvgChartScreen> {
  List<SensorData> sensorAvgDataList = [];
  int n =8;

  @override
  void initState() {
    super.initState();
    _fetchTemperatureAvgData();
  }

  Future<void> _fetchTemperatureAvgData() async {
    List<SensorData> data = await ApiService.fetchLastNAverageTemperatures(8);
    setState(() {
      sensorAvgDataList = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF090909),
      appBar: AppBar(
        backgroundColor: const Color(0xFF090909),
        elevation: 0,
        title: Text('Últimos ${n.toString()} Dias'),
      ),
      body: SafeArea(
        child: sensorAvgDataList.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  child: TemperatureAvgChart(sensorAvgDataList: sensorAvgDataList),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
