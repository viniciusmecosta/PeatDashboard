import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:peatdashboard/models/sensor_data.dart';
import 'package:peatdashboard/models/sensor_level.dart';
import 'package:peatdashboard/screens/capacity_screen.dart';
import 'package:peatdashboard/screens/humidity_screen.dart';
import 'package:peatdashboard/screens/temperature_screen.dart';
import 'package:peatdashboard/services/api_service.dart';
import 'package:peatdashboard/widgets/info_widget.dart';
import 'package:peatdashboard/widgets/map_widget.dart';
import 'package:peatdashboard/widgets/metric_capacity_widget.dart';
import '../widgets/metric_humidity_widget.dart';
import '../widgets/metric_temperature_widget.dart';

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
      final tempHumiData = await ApiService.fetchTemperatureAndHumidity();
      final capData = await ApiService.fetchCapacity();
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
      BuildContext context, bool isLargeScreen, SensorData temperature, SensorData humidity, SensorLevel capacity) {
    final cardColor = Theme.of(context).colorScheme.primary;

    final capacityCard = GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const CapacityScreen())),
      child: MetricCapacityWidget(
        title: 'Volume de Ração',
        value: '${capacity.capacity.toInt()}%',
        subtitle: capacity.date,
        chartColor: cardColor,
      ),
    );

    final temperatureCard = GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const TemperatureScreen())),
      child: MetricTemperatureWidget(
        title: 'Temperatura',
        value: '${temperature.temperature.toInt()}°C',
        subtitle: temperature.date,
        chartColor: cardColor,
      ),
    );

    final humidityCard = GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const HumidityScreen())),
      child: MetricHumidityWidget(
        title: 'Umidade',
        value: '${humidity.humidity.toInt()}%',
        subtitle: humidity.date,
        chartColor: cardColor,
      ),
    );

    return isLargeScreen
        ? Row(children: [
      Expanded(child: capacityCard),
      const SizedBox(width: 16),
      Expanded(child: temperatureCard),
      const SizedBox(width: 16),
      Expanded(child: humidityCard),
    ])
        : Column(children: [
      SizedBox(width: double.infinity, child: capacityCard),
      const SizedBox(height: 16),
      Row(children: [
        Expanded(child: temperatureCard),
        const SizedBox(width: 16),
        Expanded(child: humidityCard),
      ]),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMobile = MediaQuery.of(context).size.width <= 600;

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        toolbarHeight: 80,
        title: Container(
          padding: const EdgeInsets.only(top: 20),
          alignment: isMobile ? Alignment.center : Alignment.centerLeft,
          child: Image.asset('assets/logo.png', height: 115),
        ),
        centerTitle: isMobile,
      ),
      body: SafeArea(
        top: false,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
          padding: const EdgeInsets.all(16),
          child: isMobile
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
              : SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                MapWidget(location: _location),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
