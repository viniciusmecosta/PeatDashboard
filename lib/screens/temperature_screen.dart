import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:peatdashboard/models/sensor_data.dart';
import 'package:peatdashboard/services/api_service.dart';
import 'package:peatdashboard/widgets/temperature_widget.dart';

class TemperatureScreen extends StatefulWidget {
  const TemperatureScreen({super.key});

  @override
  _TemperatureScreenState createState() => _TemperatureScreenState();
}

class _TemperatureScreenState extends State<TemperatureScreen> {
  List<SensorData> _sensorDataList = [];
  List<SensorData> _filteredData = [];
  String _selectedPeriod = "Hoje";
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchDataForSelectedPeriod();
  }

  Future<void> _fetchDataForSelectedPeriod() async {
    setState(() => _isLoading = true);

    switch (_selectedPeriod) {
      case "Hoje":
        await _fetchDataByDate(DateTime.now());
        break;
      case "Ontem":
        await _fetchDataByDate(DateTime.now().subtract(const Duration(days: 1)));
        break;
      case "Últimos 7 dias":
        await _fetchAverageData(7);
        break;
      case "Últimos 31 dias":
        await _fetchAverageData(31);
        break;
    }
  }

  Future<void> _fetchDataByDate(DateTime date) async {
    final formattedDate = DateFormat('ddMMyyyy').format(date);
    final data = await ApiService.fetchTemperatureAndHumidityByDate(formattedDate);
    _updateFilteredData(data);
  }

  Future<void> _fetchAverageData(int days) async {
    final data = await ApiService.fetchTemperatureAndHumidityList(days);
    _updateFilteredData(data);
  }

  void _updateFilteredData(List<SensorData> data) {
    if (mounted) {
      setState(() {
        _filteredData = data;
        _sensorDataList = data;
        _isLoading = false;
      });
    }
  }

  List<String> _getAvailablePeriods(BuildContext context) {
    final periods = ["Hoje", "Ontem", "Últimos 7 dias"];
    if (MediaQuery.of(context).size.width > 800) {
      periods.add("Últimos 31 dias");
    } else if (_selectedPeriod == "Últimos 31 dias") {
      _selectedPeriod = "Últimos 7 dias";
      _fetchDataForSelectedPeriod();
    }
    return periods;
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
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              DropdownButton<String>(
                value: _selectedPeriod,
                dropdownColor: const Color(0xFF18181B),
                style: const TextStyle(color: Colors.white),
                items: _getAvailablePeriods(context).map((period) => DropdownMenuItem(
                  value: period,
                  child: Text(period),
                )).toList(),
                onChanged: (newValue) {
                  if (newValue != null) {
                    setState(() => _selectedPeriod = newValue);
                    _fetchDataForSelectedPeriod();
                  }
                },
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: TemperatureWidget(sensorDataList: _filteredData),
              ),
            ],
          ),
        ),
      ),
    );
  }
}