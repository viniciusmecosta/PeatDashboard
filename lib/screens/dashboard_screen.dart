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
import 'package:peatdashboard/widgets/metric_widget.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final LatLng _location = const LatLng(-3.7442, -38.5361);
  SensorData _temperature = SensorData(id: 0, date: "0", temperature: 0, humidity: 0);
  SensorData _humidity = SensorData(id: 0, date: "0", temperature: 0, humidity: 0);
  SensorLevel _capacity = SensorLevel(id: 0, date: "0", capacity: 0);
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final tempHumiData = await ApiService.fetchTemperatureAndHumidity();
      final capData = await ApiService.fetchCapacity();

      if (mounted) {
        setState(() {
          _temperature = tempHumiData["temperature"] ?? _temperature;
          _humidity = tempHumiData["humidity"] ?? _humidity;
          _capacity = capData ?? _capacity;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        print("Error loading data: $e");
      }
    }
  }

  Widget _buildMetricCards(BuildContext context, bool isLargeScreen) {
    final cardColor = const Color(0xFF10B981);

    final capacityCard = GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const CapacityScreen())),
      child: MetricWidget(
        title: 'Volume de Ração',
        value: '${_capacity.capacity.toInt()}%',
        subtitle: _capacity.date,
        chartColor: cardColor,
      ),
    );

    final temperatureCard = GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const TemperatureScreen())),
      child: MetricWidget(
        title: 'Temperatura',
        value: '${_temperature.temperature.toInt()}°C',
        subtitle: _temperature.date,
        chartColor: cardColor,
      ),
    );

    final humidityCard = GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const HumidityScreen())),
      child: MetricWidget(
        title: 'Umidade',
        value: '${_humidity.humidity.toInt()}%',
        subtitle: _humidity.date,
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
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFF090909),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final isLargeScreen = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      backgroundColor: const Color(0xFF090909),
      appBar: AppBar(
        backgroundColor: const Color(0xFF090909),
        elevation: 0,
        toolbarHeight: 100,
        title: Container(
          padding: const EdgeInsets.only(top: 20),
          alignment: isLargeScreen ? Alignment.centerLeft : Alignment.center,
          child: Image.asset('assets/logo.png', height: 130),
        ),
        centerTitle: !isLargeScreen,
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const InfoWidget(),
              const SizedBox(height: 16),
              _buildMetricCards(context, isLargeScreen),
              const SizedBox(height: 16),
              MapWidget(location: _location),
            ],
          ),
        ),
      ),
    );
  }
}