import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

class MapWidget extends StatelessWidget {
  final LatLng location;

  const MapWidget({super.key, required this.location});

  void _openGoogleMaps() async {
    final Uri url = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=${location.latitude},${location.longitude}',
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Não foi possível abrir o Google Maps.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _openGoogleMaps, // Abre o Google Maps ao clicar no mapa
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12), // Borda arredondada diretamente no mapa
        child: SizedBox(
          height: 170, // Altura do mapa
          child: IgnorePointer(
            // Bloqueia todas as interações de toque no mapa
            child: FlutterMap(
              options: MapOptions(
                center: location,
                zoom: 16.0,
                interactiveFlags: InteractiveFlag.none, // Desabilita todas as interações
              ),
              nonRotatedChildren: [
                // TileLayer com mais detalhes (estilo escuro personalizado)
                TileLayer(
                  urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                  subdomains: ['a', 'b', 'c'],
                  userAgentPackageName: 'com.example.app',
                ),
                // Marcador no mapa
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
        ),
      ),
    );
  }
}