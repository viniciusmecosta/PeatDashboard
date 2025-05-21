import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
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

  final LatLng _location = const LatLng(-3.7442, -38.5361);

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final tempHumiData = await PeatDataService.fetchTemperatureAndHumidity();
      final capData = await PeatDataService.fetchCapacity();
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar dados: ${e.toString()}')),
      );
    }
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
          const SizedBox(width: 16),
          Expanded(child: temperatureCard),
          const SizedBox(width: 16),
          Expanded(child: humidityCard),
          const SizedBox(width: 16),
          Expanded(child: notifyCard),
        ],
      );
    } else {
      return Column(
        children: [
          Row(
            children: [
              Expanded(child: capacityCard),
              const SizedBox(width: 16),
              Expanded(child: temperatureCard),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: humidityCard),
              const SizedBox(width: 16),
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
        toolbarHeight: 80,
        title: Image.asset('assets/logo.png', height: 115),
        centerTitle: isMobile,
      ),
      body: SafeArea(
        top: false,
        child:
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : Padding(
                  padding: const EdgeInsets.all(16),
                  child:
                      isMobile
                          ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const InfoWidget(),
                              const SizedBox(height: 16),
                              _buildMetricCards(
                                context,
                                false,
                                _data["temperature"],
                                _data["humidity"],
                                _data["capacity"],
                              ),
                              const SizedBox(height: 16),
                              Expanded(child: MapWidget(location: _location)),
                            ],
                          )
                          : Column(
                            children: [
                              const InfoWidget(),
                              const SizedBox(height: 16),
                              _buildMetricCards(
                                context,
                                true,
                                _data["temperature"],
                                _data["humidity"],
                                _data["capacity"],
                              ),
                              const SizedBox(height: 16),
                              Expanded(child: MapWidget(location: _location)),
                            ],
                          ),
                ),
      ),
    );
  }
}
