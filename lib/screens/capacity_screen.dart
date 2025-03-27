import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:peatdashboard/models/sensor_level.dart';
import 'package:peatdashboard/services/api_service.dart';
import 'package:peatdashboard/utils/app_colors.dart';
import 'package:peatdashboard/widgets/capacity_info_widget.dart';
import 'package:peatdashboard/widgets/capacity_widget.dart';

class CapacityScreen extends StatefulWidget {
  const CapacityScreen({super.key});

  @override
  _CapacityScreenState createState() => _CapacityScreenState();
}

class _CapacityScreenState extends State<CapacityScreen> {
  final Map<String, List<SensorLevel>> _sensorLevelListByPeriod = {};
  late double _last = 0.0;
  SensorLevel _sensorLevel = SensorLevel(date: "0", capacity: 0.0);
  List<SensorLevel> _filteredData = [];
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
      final today = DateTime.now();
      final yesterday = today.subtract(const Duration(days: 1));

      _sensorLevelListByPeriod["Hoje"] = await _fetchDataByDate(today);
      _sensorLevelListByPeriod["Ontem"] = await _fetchDataByDate(yesterday);
      _sensorLevelListByPeriod["Últimos 7 dias"] = await _fetchAverageData(7);
      _sensorLevelListByPeriod["Últimos 31 dias"] = await _fetchAverageData(31);
      _sensorLevel = await ApiService.fetchCapacity();
      _last = _sensorLevelListByPeriod["Hoje"]!.last.capacity;

      _updateFilteredData();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Erro ao carregar dados')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<List<SensorLevel>> _fetchDataByDate(DateTime date) async {
    final formattedDate = DateFormat('ddMMyyyy').format(date);
    return await ApiService.fetchCapacityByDate(formattedDate);
  }

  Future<List<SensorLevel>> _fetchAverageData(int days) async {
    return await ApiService.fetchLastNAvgLevels(days);
  }

  void _updateFilteredData() {
    if (mounted) {
      setState(() {
        _filteredData = _sensorLevelListByPeriod[_selectedPeriod] ?? [];
      });
    }
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
    final backgroundColor =
        isDarkMode
            ? AppColors.darkBackgroundColor
            : AppColors.lightBackgroundColor;
    final textColor =
        isDarkMode
            ? AppColors.lightBackgroundColor
            : AppColors.darkBackgroundColor;
    final dropdownColor =
        isDarkMode ? AppColors.darkCardColor : AppColors.lightBackgroundColor;

    double percentage = _sensorLevel.capacity;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        centerTitle: true,
        title: Text('Volume de Ração', style: TextStyle(color: textColor)),
      ),
      body: SafeArea(
        child:
            _isLoading
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
                                      _updateFilteredData();
                                    });
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
                        child: CapacityWidget(
                          sensorLevelList: _filteredData,
                          last: _last,
                        ),
                      ),
                      const SizedBox(height: 16),
                      CapacityInfoWidget(percentage: percentage),
                    ],
                  ),
                ),
      ),
    );
  }
}
