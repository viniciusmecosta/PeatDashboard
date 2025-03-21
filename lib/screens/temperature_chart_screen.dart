import 'package:flutter/material.dart';
import 'package:peatdashboard/models/sensor_data.dart';
import 'package:peatdashboard/widgets/temperature_chart.dart';
import '../services/api_service.dart';
import '../widgets/humidity_chart.dart';
import 'package:intl/intl.dart';

class TemperatureChartScreen extends StatefulWidget {
  const TemperatureChartScreen({super.key});

  @override
  _HumidityChartScreenState createState() => _HumidityChartScreenState();
}

class _HumidityChartScreenState extends State<TemperatureChartScreen> {
  List<SensorData> sensorDataList = [];
  List<SensorData> filteredData = [];
  String selectedPeriod = "Hoje";
  bool isLoading = true; 
  @override
  void initState() {
    super.initState();
    _fetchDataForSelectedPeriod();
  }

  Future<void> _fetchDataForSelectedPeriod() async {
    setState(() {
      isLoading = true; 
    });
    switch (selectedPeriod) {
      case "Hoje":
        await _fetchTodayData();
        break;
      case "Ontem":
        await _fetchYesterdayData();
        break;
      case "Média 10 dias":
        await _fetch10DaysAverageData();
        break;
    }
  }

  Future<void> _fetchTodayData() async {
    DateTime now = DateTime.now();
    String today = DateFormat('ddMMyyyy').format(now);
    List<SensorData> data = await ApiService.fetchTemperatureAndHumidityByDate(today);
    _updateFilteredData(data);
  }

  Future<void> _fetchYesterdayData() async {
    DateTime now = DateTime.now();
    String yesterday = DateFormat('ddMMyyyy').format(now.subtract(const Duration(days: 1)));
    List<SensorData> data = await ApiService.fetchTemperatureAndHumidityByDate(yesterday);
    _updateFilteredData(data);
  }

  Future<void> _fetch10DaysAverageData() async {
    List<SensorData> data = await ApiService.fetchTemperatureAndHumidityList(10);
    _updateFilteredData(data);
  }

  void _updateFilteredData(List<SensorData> data) {
    setState(() {
      filteredData = data;
      sensorDataList = data; 
      isLoading = false; 
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF090909),
      appBar: AppBar(
        backgroundColor: const Color(0xFF090909),
        elevation: 0,
        title: const Text('Temperatura'),
      ),
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator()) // Exibe o indicador enquanto carrega
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      DropdownButton<String>(
                        value: selectedPeriod,
                        dropdownColor: const Color(0xFF18181B),
                        style: const TextStyle(color: Colors.white),
                        items: ["Hoje", "Ontem", "Média 10 dias"].map((String period) {
                          return DropdownMenuItem(
                            value: period,
                            child: Text(period),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() {
                              selectedPeriod = newValue;
                            });
                            _fetchDataForSelectedPeriod();
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: TemperatureChart(sensorDataList: filteredData),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}