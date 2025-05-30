import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:peatdashboard/utils/app_colors.dart';

class MapWidget extends StatelessWidget {
  final LatLng location;

  const MapWidget({super.key, required this.location});

  Future<void> _openGoogleMaps() async {
    final googleMapsAppUrl = Uri.parse(
      'geo:${location.latitude},${location.longitude}?q=${location.latitude},${location.longitude}',
    );
    final googleMapsWebUrl = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=${location.latitude},${location.longitude}',
    );

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
    final tileUrl =
        isDarkMode
            ? 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png'
            : 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png';

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    double calculateZoom() {
      if (screenWidth < 300 || screenHeight < 200) {
        return 14.0;
      } else if (screenWidth < 600 || screenHeight < 400) {
        return 15.0;
      } else {
        return 16.0;
      }
    }

    final zoom = calculateZoom();

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
                    zoom: zoom,
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
                          builder:
                              (ctx) => const Icon(
                                Icons.location_pin,
                                color: AppColors.primary,
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
                  color: AppColors.transparent,
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
