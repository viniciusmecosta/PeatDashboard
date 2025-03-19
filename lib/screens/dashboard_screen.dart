import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:peatdashboard/screens/temperature_chart_screen.dart';
import 'package:peatdashboard/screens/humidity_chart_screen.dart'; // Added humidity chart screen
import 'package:peatdashboard/services/api_service.dart';
import 'package:peatdashboard/widgets/info_card.dart';
import 'package:peatdashboard/widgets/map_widget.dart';
import 'package:peatdashboard/widgets/metric_card.dart';
import 'package:peatdashboard/screens/metric_detail_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final LatLng _location = const LatLng(-3.7442, -38.5361);
  SensorData temperature = SensorData(id: 0, date: "0", temperature: 0, humidity: 0);
  SensorData humidity = SensorData(id: 0, date: "0", temperature: 0, humidity: 0);
  SensorLevel capacity = SensorLevel(id: 0, date: "0", capacity: 0);
  bool isLoading = true;

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
        temperature = tempHumiData["temperature"] ?? SensorData(id: 0, date: "0", temperature: 0, humidity: 0);
        humidity = tempHumiData["humidity"] ?? SensorData(id: 0, date: "0", temperature: 0, humidity: 0);
        capacity = capData ?? SensorLevel(id: 0, date: "0", capacity: 0);
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        temperature = SensorData(id: 0, date: "0", temperature: 0, humidity: 0);
        humidity = SensorData(id: 0, date: "0", temperature: 0, humidity: 0);
        capacity = SensorLevel(id: 0, date: "0", capacity: 0);
        isLoading = false;
      });
    }
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
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MetricDetailScreen(
                                title: 'Capacidade',
                                value: '${capacity.capacity.toInt()}%',
                                subtitle: capacity.date,
                              ),
                            ),
                          );
                        },
                        child: MetricCard(
                          title: 'Capacidade',
                          value: '${capacity.capacity.toInt()}%',
                          subtitle: capacity.date,
                          chartColor: const Color(0xFF8B5CF6),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TemperatureChartScreen(),
                            ),
                          );
                        },
                        child: MetricCard(
                          title: 'Temperatura',
                          value: '${temperature.temperature.toInt()}°C',
                          subtitle: temperature.date,
                          chartColor: const Color(0xFF8B5CF6),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HumidityChartScreen(), // Navigate to HumidityChartScreen
                            ),
                          );
                        },
                        child: MetricCard(
                          title: 'Umidade',
                          value: '${humidity.humidity.toInt()}%',
                          subtitle: humidity.date,
                          chartColor: const Color(0xFF8B5CF6),
                        ),
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
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MetricDetailScreen(
                                    title: 'Volume de Ração',
                                    value: '${capacity.capacity.toInt()}%',
                                    subtitle: capacity.date,
                                  ),
                                ),
                              );
                            },
                            child: MetricCard(
                              title: 'Volume de Ração',
                              value: '${capacity.capacity.toInt()}%',
                              subtitle: capacity.date,
                              chartColor: const Color(0xFF8B5CF6),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TemperatureChartScreen(),
                                ),
                              );
                            },
                            child: MetricCard(
                              title: 'Temperatura',
                              value: '${temperature.temperature.toInt()}°C',
                              subtitle: temperature.date,
                              chartColor: const Color(0xFF8B5CF6),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HumidityChartScreen(),
                                ),
                              );
                            },
                            child: MetricCard(
                              title: 'Umidade',
                              value: '${humidity.humidity.toInt()}%',
                              subtitle: humidity.date,
                              chartColor: const Color(0xFF8B5CF6),
                            ),
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
