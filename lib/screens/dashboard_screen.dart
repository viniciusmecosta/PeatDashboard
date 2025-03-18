import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
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

  final List<double> _temperatureData = List.generate(20, (index) => 20 + index * 1.5);
  final List<double> _humidityData = List.generate(20, (index) => 40 + index * 2.0);

  @override
  Widget build(BuildContext context) {
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
        actions: [],
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const InfoCard(), // Placed here just below the logo and above Metric Cards
              const SizedBox(height: 16),
              if (isLargeScreen)
                Row(
                  children: [
                    Expanded(
                      child: MetricCard(
                        title: 'Capacidade',
                        value: '10%',
                        subtitle: '11:30 20/10/2024',
                        chartColor: const Color(0xFF8B5CF6),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: MetricCard(
                        title: 'Temperatura',
                        value: '30°',
                        subtitle: '11:30 20/10/2024',
                        chartColor: const Color(0xFF8B5CF6),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: MetricCard(
                        title: 'Umidade',
                        value: '40%',
                        subtitle: '11:30 20/10/2024',
                        chartColor: const Color(0xFF8B5CF6),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: MetricCard(
                        title: 'Pressão',
                        value: '1013 hPa',
                        subtitle: '11:30 20/10/2024',
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
                            value: '10%',
                            subtitle: '11:30 20/10/2024',
                            chartColor: const Color(0xFF8B5CF6),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: MetricCard(
                            title: 'Temperatura',
                            value: '30°',
                            subtitle: '11:30 20/10/2024',
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
                            value: '40%',
                            subtitle: '11:30 20/10/2024',
                            chartColor: const Color(0xFF8B5CF6),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: MetricCard(
                            title: 'Pressão',
                            value: '1013 hPa',
                            subtitle: '11:30 20/10/2024',
                            chartColor: const Color(0xFF8B5CF6),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              const SizedBox(height: 16),
              MapWidget(location: _location),

              const SizedBox(height: 16),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF18181B),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.grey.withOpacity(0.1),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.food_bank_sharp,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Peat',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
