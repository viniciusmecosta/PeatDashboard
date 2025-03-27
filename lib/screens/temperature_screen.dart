import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:peatdashboard/models/sensor_data.dart';
import 'package:peatdashboard/services/api_service.dart';
import 'package:peatdashboard/utils/app_colors.dart';
import 'package:peatdashboard/widgets/temperature_widget.dart';

class TemperatureScreen extends StatefulWidget {
  const TemperatureScreen({super.key});

  @override
  _TemperatureScreenState createState() => _TemperatureScreenState();
}

class _TemperatureScreenState extends State<TemperatureScreen> {
  final Map<String, List<SensorData>> _allData = {
    "Hoje": [],
    "Ontem": [],
    "Últimos 7 dias": [],
    "Últimos 31 dias": [],
  };
  List<SensorData> _filteredData = [];
  String _selectedPeriod = "Hoje";
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAllData();
  }

  Future<void> _fetchAllData() async {
    setState(() => _isLoading = true);

    try {
      final today = DateFormat('ddMMyyyy').format(DateTime.now());
      final yesterday = DateFormat(
        'ddMMyyyy',
      ).format(DateTime.now().subtract(const Duration(days: 1)));

      _allData["Hoje"] = await ApiService.fetchTemperatureAndHumidityByDate(
        today,
      );
      _allData["Ontem"] = await ApiService.fetchTemperatureAndHumidityByDate(
        yesterday,
      );
      _allData["Últimos 7 dias"] =
          await ApiService.fetchTemperatureAndHumidityList(7);
      _allData["Últimos 31 dias"] =
          await ApiService.fetchTemperatureAndHumidityList(31);

      _updateFilteredData();
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Erro ao carregar dados')));
    }
  }

  void _updateFilteredData() {
    setState(() {
      _filteredData = _allData[_selectedPeriod] ?? [];
      _isLoading = false;
    });
  }

  List<String> _getAvailablePeriods(BuildContext context) {
    final periods = ["Hoje", "Ontem", "Últimos 7 dias"];
    if (MediaQuery.of(context).size.width > 800) {
      periods.add("Últimos 31 dias");
    } else if (_selectedPeriod == "Últimos 31 dias") {
      _selectedPeriod = "Últimos 7 dias";
      _updateFilteredData();
    }
    return periods;
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode
        ? AppColors.darkBackgroundColor
        : AppColors.lightBackgroundColor;
    final textColor = isDarkMode
        ? AppColors.lightBackgroundColor
        : AppColors.darkBackgroundColor;
    final dropdownColor = isDarkMode
        ? AppColors.darkCardColor
        : AppColors.lightBackgroundColor;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        centerTitle: true,
        title: Text('Temperatura', style: TextStyle(color: textColor)),
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8.0,
                      ),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12.0,
                          ),
                          decoration: BoxDecoration(
                            color: dropdownColor,
                            borderRadius: BorderRadius.circular(22.0),
                            boxShadow: const [
                              BoxShadow(
                                color: AppColors.darkShadowColor,
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _selectedPeriod,
                              dropdownColor: dropdownColor,
                              icon: Icon(
                                Icons.arrow_drop_down,
                                color: textColor,
                              ),
                              style: TextStyle(color: textColor),
                              items:
                                  _getAvailablePeriods(context).map((period) {
                                return DropdownMenuItem(
                                  value: period,
                                  child: Text(
                                    period,
                                    style: TextStyle(color: textColor),
                                  ),
                                );
                              }).toList(),
                              onChanged: (newValue) {
                                if (newValue != null) {
                                  setState(() {
                                    _selectedPeriod = newValue;
                                  });
                                  _updateFilteredData();
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 1),
                    SizedBox(
                      width: double.infinity,
                      child:
                          TemperatureWidget(sensorDataList: _filteredData),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}