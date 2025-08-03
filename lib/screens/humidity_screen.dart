import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:peatdashboard/models/feeder.dart';
import 'package:peatdashboard/models/sensor_data.dart';
import 'package:peatdashboard/services/peat_data_service.dart';
import 'package:peatdashboard/utils/app_colors.dart';
import 'package:peatdashboard/widgets/humidity_widget.dart';

class HumidityScreen extends StatefulWidget {
  final Feeder feeder;
  const HumidityScreen({super.key, required this.feeder});

  @override
  _HumidityScreenState createState() => _HumidityScreenState();
}

class _HumidityScreenState extends State<HumidityScreen> {
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
    final feederId = widget.feeder.id;

    try {
      final today = DateFormat('ddMMyyyy').format(DateTime.now());
      final yesterday = DateFormat(
        'ddMMyyyy',
      ).format(DateTime.now().subtract(const Duration(days: 1)));

      _allData["Hoje"] =
          await PeatDataService.fetchTemperatureAndHumidityByDate(
            today,
            feederId,
          );
      _allData["Ontem"] =
          await PeatDataService.fetchTemperatureAndHumidityByDate(
            yesterday,
            feederId,
          );
      _allData["Últimos 7 dias"] =
          await PeatDataService.fetchTemperatureAndHumidityList(7, feederId);
      _allData["Últimos 31 dias"] =
          await PeatDataService.fetchTemperatureAndHumidityList(31, feederId);

      _updateFilteredData();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erro ao carregar dados: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _updateFilteredData() {
    if (mounted) {
      setState(() {
        _filteredData = _allData[_selectedPeriod] ?? [];
      });
    }
  }

  List<String> _getAvailablePeriods(BuildContext context) {
    final periods = ["Hoje", "Ontem", "Últimos 7 dias"];
    if (MediaQuery.of(context).size.width > 800) {
      periods.add("Últimos 31 dias");
    } else if (_selectedPeriod == "Últimos 31 dias") {
      _selectedPeriod = "Últimos 7 dias";
      Future.microtask(() => _updateFilteredData());
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

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        centerTitle: true,
        title: Text('Umidade', style: TextStyle(color: textColor)),
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
                        child: HumidityWidget(
                          sensorDataList: _filteredData,
                          feeder: widget.feeder,
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
      ),
    );
  }
}
