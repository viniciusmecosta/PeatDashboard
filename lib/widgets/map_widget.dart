import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

class MapWidget extends StatelessWidget {
  final LatLng location;

  const MapWidget({super.key, required this.location});

  Future<void> _openGoogleMaps() async {
    final Uri googleMapsUrl = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=${location.latitude},${location.longitude}',
    );
    final Uri googleMapsAppUrl = Uri.parse(
      'geo:${location.latitude},${location.longitude}?q=${location.latitude},${location.longitude}',
    );

    if (await canLaunchUrl(googleMapsAppUrl)) {
      await launchUrl(googleMapsAppUrl);
    } else if (await canLaunchUrl(googleMapsUrl)) {
      await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication);
    } else {
      throw 'Não foi possível abrir o Google Maps.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _openGoogleMaps,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
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
                      urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                      subdomains: ['a', 'b', 'c'],
                      userAgentPackageName: 'com.example.app',
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: location,
                          builder: (ctx) => const Icon(
                            Icons.location_pin,
                            color: Colors.red,
                            size: 40,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Positioned.fill(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: _openGoogleMaps,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}