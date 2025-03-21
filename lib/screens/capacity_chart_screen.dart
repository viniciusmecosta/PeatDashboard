import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../widgets/capacity_chart.dart';

class CapacityChartScreen extends StatefulWidget {
  const CapacityChartScreen({super.key});

  @override
  _CapacityChartScreenState createState() => _CapacityChartScreenState();
}

class _CapacityChartScreenState extends State<CapacityChartScreen> {
  List<SensorLevel> sensorLevelList = [];
  int n = 8;

  @override
  void initState() {
    super.initState();
    _fetchCapacityData();
  }

  Future<void> _fetchCapacityData() async {
    List<SensorLevel> data = await ApiService.fetchLastNAvgLevels(n);
    setState(() {
      sensorLevelList = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF090909),
      appBar: AppBar(
        backgroundColor: const Color(0xFF090909),
        elevation: 0,
        title: Text('Volume de Ração'),
      ),
      body: SafeArea(
        child: sensorLevelList.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  child: CapacityChart(sensorLevelList: sensorLevelList),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
