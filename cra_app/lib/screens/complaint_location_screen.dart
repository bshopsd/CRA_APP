// complaint_location_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class ComplaintLocationScreen extends StatelessWidget {
  final double latitude;
  final double longitude;
  final String title;

  const ComplaintLocationScreen({
    super.key,
    required this.latitude,
    required this.longitude,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final LatLng position = LatLng(latitude, longitude);

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: FlutterMap(
        options: MapOptions(center: position, zoom: 15.0),
        children: [
          TileLayer(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: ['a', 'b', 'c'],
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: position,
                width: 40,
                height: 40,
                child:
                    const Icon(Icons.location_pin, size: 40, color: Colors.red),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
