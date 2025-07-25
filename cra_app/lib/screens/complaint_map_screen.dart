import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapScreen extends StatelessWidget {
  final double latitude;
  final double longitude;
  final String title;

  const MapScreen({
    super.key,
    required this.latitude,
    required this.longitude,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final LatLng position = LatLng(latitude, longitude);

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.blueAccent,
      ),
      body: FlutterMap(
        options: MapOptions(
          center: position,
          zoom: 16,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: const ['a', 'b', 'c'],
            userAgentPackageName: 'com.example.yourapp',
          ),
          MarkerLayer(
            markers: [
              Marker(
                width: 50,
                height: 50,
                point: position,
                child: const Icon(
                  Icons.location_on,
                  size: 40,
                  color: Colors.red,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
