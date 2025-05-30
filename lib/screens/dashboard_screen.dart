import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:peatdashboard/models/feeder.dart';
import 'package:peatdashboard/models/sensor_data.dart';
import 'package:peatdashboard/models/sensor_level.dart';
import 'package:peatdashboard/screens/capacity_screen.dart';
import 'package:peatdashboard/screens/humidity_screen.dart';
import 'package:peatdashboard/screens/temperature_screen.dart';
import 'package:peatdashboard/services/peat_data_service.dart';
import 'package:peatdashboard/utils/app_colors.dart';
import 'package:peatdashboard/widgets/info_widget.dart';
import 'package:peatdashboard/widgets/map_widget.dart';
import 'package:peatdashboard/widgets/metric_capacity_widget.dart';
import 'package:peatdashboard/widgets/metric_humidity_widget.dart';
import 'package:peatdashboard/widgets/metric_temperature_widget.dart';
import 'package:peatdashboard/widgets/notify_card_widget.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  Map<String, dynamic> _data = {};
  bool _isLoading = true;

  Feeder? _selectedFeeder;

  final List<Feeder> _feeders = [
    Feeder(
      id: "1",
      name: 'Comedouro IFCE',
      location: const LatLng(-3.744340487400293, -38.53604795635519),
    ),
    Feeder(
      id: "2",
      name: 'Comedouro UECE',
      location: const LatLng(-3.788079524593659, -38.553419371763795),
    ),
    Feeder(
      id: "3",
      name: 'Comedouro UNIFOR',
      location: const LatLng(-3.768765932570104, -38.47806435259981),
    ),
  ];

  @override
  void initState() {
    super.initState();
    if (_feeders.isNotEmpty) {
      _selectedFeeder = _feeders.first;
      _loadData();
    }
  }

  Future<void> _loadData() async {
    if (_selectedFeeder == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final feederId = _selectedFeeder!.id;
      final tempHumiData = await PeatDataService.fetchTemperatureAndHumidity(
        feederId,
      );
      final capData = await PeatDataService.fetchCapacity(feederId);
      setState(() {
        _data = {
          "temperature": tempHumiData["temperature"],
          "humidity": tempHumiData["humidity"],
          "capacity": capData,
        };
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao carregar dados: ${e.toString()}')),
        );
      }
    }
  }

  Widget _buildFeederSelector() {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    final backgroundColor =
        isDarkMode
            ? AppColors.metricWidgetDarkBackgroundColor
            : AppColors.lightBackgroundColor;

    final borderColor =
        isDarkMode
            ? AppColors.metricWidgetDarkBorderColor.withOpacity(0.1)
            : AppColors.lightBorderColor.withOpacity(0.1);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: borderColor),
      ),
      child: DropdownButton<Feeder>(
        value: _selectedFeeder,
        isExpanded: true,
        underline: const SizedBox.shrink(),
        dropdownColor: backgroundColor,
        icon: Icon(
          Icons.arrow_drop_down_rounded,
          color: theme.colorScheme.primary,
        ),
        onChanged: (Feeder? newValue) {
          if (newValue != null) {
            setState(() {
              _selectedFeeder = newValue;
            });
            _loadData();
          }
        },
        items:
            _feeders.map<DropdownMenuItem<Feeder>>((Feeder feeder) {
              return DropdownMenuItem<Feeder>(
                value: feeder,
                child: Text(feeder.name),
              );
            }).toList(),
      ),
    );
  }

  Widget _buildMetricCards(
    BuildContext context,
    bool isLargeScreen,
    SensorData temperature,
    SensorData humidity,
    SensorLevel capacity,
  ) {
    final cardColor = Theme.of(context).colorScheme.primary;

    final capacityCard = GestureDetector(
      onTap:
          () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CapacityScreen()),
          ),
      child: MetricCapacityWidget(
        title: 'Volume de Ração',
        value: '${capacity.capacity.toInt()}%',
        subtitle: capacity.date,
        chartColor: cardColor,
      ),
    );

    final temperatureCard = GestureDetector(
      onTap:
          () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TemperatureScreen()),
          ),
      child: MetricTemperatureWidget(
        title: 'Temperatura',
        value: '${temperature.temperature.toInt()}°C',
        subtitle: temperature.date,
        chartColor: cardColor,
      ),
    );

    final humidityCard = GestureDetector(
      onTap:
          () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const HumidityScreen()),
          ),
      child: MetricHumidityWidget(
        title: 'Umidade',
        value: '${humidity.humidity.toInt()}%',
        subtitle: humidity.date,
        chartColor: cardColor,
      ),
    );

    final notifyCard = NotifyIconCardWidget(
      onTap: () {
        //Navigator.push(context,MaterialPageRoute(builder: (context) => const NotificationScreen()), );
      },
    );

    if (isLargeScreen) {
      return Row(
        children: [
          Expanded(child: capacityCard),
          const SizedBox(width: 8),
          Expanded(child: temperatureCard),
          const SizedBox(width: 8),
          Expanded(child: humidityCard),
          const SizedBox(width: 8),
          Expanded(child: notifyCard),
        ],
      );
    } else {
      return Column(
        children: [
          Row(
            children: [
              Expanded(child: capacityCard),
              const SizedBox(width: 8),
              Expanded(child: temperatureCard),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: humidityCard),
              const SizedBox(width: 8),
              Expanded(child: notifyCard),
            ],
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMobile = MediaQuery.of(context).size.width <= 600;
    final backgroundColor =
        theme.brightness == Brightness.dark
            ? AppColors.darkSurface
            : AppColors.lightBackgroundColor;
    final appBarBackgroundColor = backgroundColor;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: appBarBackgroundColor,
        elevation: 0,
        toolbarHeight: 60,
        title: Image.asset('assets/logo.png', height: 115),
        centerTitle: isMobile,
      ),
      body: SafeArea(
        top: false,
        child:
            _isLoading || _selectedFeeder == null
                ? const Center(child: CircularProgressIndicator())
                : Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child:
                      isMobile
                          ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const InfoWidget(),
                              const SizedBox(height: 8),
                              _buildFeederSelector(),
                              const SizedBox(height: 8),
                              _buildMetricCards(
                                context,
                                false,
                                _data["temperature"],
                                _data["humidity"],
                                _data["capacity"],
                              ),
                              const SizedBox(height: 8),
                              Expanded(
                                child: MapWidget(
                                  location: _selectedFeeder!.location,
                                ),
                              ),
                            ],
                          )
                          : Column(
                            children: [
                              const InfoWidget(),
                              const SizedBox(height: 8),
                              _buildFeederSelector(),
                              const SizedBox(height: 8),
                              _buildMetricCards(
                                context,
                                true,
                                _data["temperature"],
                                _data["humidity"],
                                _data["capacity"],
                              ),
                              const SizedBox(height: 8),
                              Expanded(
                                child: MapWidget(
                                  location: _selectedFeeder!.location,
                                ),
                              ),
                            ],
                          ),
                ),
      ),
    );
  }
}
