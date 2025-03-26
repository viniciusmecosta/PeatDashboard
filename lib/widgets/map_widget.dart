import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

class MapWidget extends StatelessWidget {
  final LatLng location;

  const MapWidget({super.key, required this.location});

  Future<void> _openGoogleMaps() async {
    final googleMapsAppUrl = Uri.parse('geo:${location.latitude},${location.longitude}?q=${location.latitude},${location.longitude}');
    final googleMapsWebUrl = Uri.parse('https://www.google.com/maps/search/?api=1&query=${location.latitude},${location.longitude}');

    if (await canLaunchUrl(googleMapsAppUrl)) {
      await launchUrl(googleMapsAppUrl);
    } else if (await canLaunchUrl(googleMapsWebUrl)) {
      await launchUrl(googleMapsWebUrl, mode: LaunchMode.externalApplication);
    } else {
      throw 'Não foi possível abrir o Google Maps.';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final backgroundColor = isDarkMode ? const Color(0xFF18181B) : Colors.white;
    final borderColor = isDarkMode ? Colors.grey.withOpacity(0.1) : Colors.black12;
    final shadowColor = isDarkMode ? Colors.black.withOpacity(0.2) : Colors.black.withOpacity(0.1);

    final tileUrl = isDarkMode
        ? 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png'
        : 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png';

    return GestureDetector(
      onTap: _openGoogleMaps,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: SizedBox(
          height: 170,
          child: Stack(
            children: [
              IgnorePointer(
                child: FlutterMap(
                  options: MapOptions(
                    center: location,
                    zoom: 16.0,
                    interactiveFlags: InteractiveFlag.none,
                  ),
                  nonRotatedChildren: [
                    TileLayer(
                      urlTemplate: tileUrl,
                      subdomains: const ['a', 'b', 'c'],
                      userAgentPackageName: 'com.example.app',
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: location,
                          builder: (ctx) => const Icon(Icons.location_pin, color: Color(0xFF298F5E), size: 40),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Positioned.fill(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(onTap: _openGoogleMaps),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
