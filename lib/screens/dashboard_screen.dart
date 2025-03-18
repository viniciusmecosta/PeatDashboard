import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

import 'package:peatdashboard/services/api_service.dart';
import 'package:peatdashboard/widgets/info_card.dart';
import 'package:peatdashboard/widgets/map_widget.dart';
import 'package:peatdashboard/widgets/metric_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final LatLng _location = const LatLng(-3.7442, -38.5361);
  SensorData temperature = SensorData(id: 0, date: "0", value: 0);
  SensorData humidity = SensorData(id: 0, date: "0", value: 0);
  SensorData capacity = SensorData(id: 0, date: "0", value: 0);
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final tempHumiData = await ApiService.fetchTemperatureAndHumidity();
    final capData = await ApiService.fetchCapacity();

    setState(() {
      temperature = tempHumiData["temperature"]!;
      humidity = tempHumiData["humidity"]!;
      capacity = capData;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFF090909),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final bool isLargeScreen = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      backgroundColor: const Color(0xFF090909),
      appBar: AppBar(
        backgroundColor: const Color(0xFF090909),
        elevation: 0,
        toolbarHeight: 100,
        title: Container(
          padding: const EdgeInsets.only(top: 20),
          alignment: isLargeScreen ? Alignment.centerLeft : Alignment.center,
          child: Image.asset(
            'assets/logo.png',
            height: 130,
          ),
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
              const InfoCard(),
              const SizedBox(height: 16),
              if (isLargeScreen)
                Row(
                  children: [
                    Expanded(
                      child: MetricCard(
                        title: 'Capacidade',
                        value: '${capacity.value.toInt()}%',
                        subtitle: capacity.date,
                        chartColor: const Color(0xFF8B5CF6),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: MetricCard(
                        title: 'Temperatura',
                        value: '${temperature.value.toInt()}°C',
                        subtitle: temperature.date,
                        chartColor: const Color(0xFF8B5CF6),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: MetricCard(
                        title: 'Umidade',
                        value: '${humidity.value.toInt()}%',
                        subtitle: humidity.date,
                        chartColor: const Color(0xFF8B5CF6),
                      ),
                    ),
                  ],
                )
              else
                Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: MetricCard(
                            title: 'Capacidade',
                            value: '${capacity.value.toInt()}%',
                            subtitle: capacity.date,
                            chartColor: const Color(0xFF8B5CF6),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: MetricCard(
                            title: 'Temperatura',
                            value: '${temperature.value.toInt()}°C',
                            subtitle: temperature.date,
                            chartColor: const Color(0xFF8B5CF6),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: MetricCard(
                            title: 'Umidade',
                            value: '${humidity.value.toInt()}%',
                            subtitle: humidity.date,
                            chartColor: const Color(0xFF8B5CF6),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              const SizedBox(height: 16),
              MapWidget(location: _location),
            ],
          ),
        ),
      ),
    );
  }
}
