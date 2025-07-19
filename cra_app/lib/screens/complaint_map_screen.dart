import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ComplaintMapScreen extends StatefulWidget {
  const ComplaintMapScreen({super.key});

  @override
  State<ComplaintMapScreen> createState() => _ComplaintMapScreenState();
}

class _ComplaintMapScreenState extends State<ComplaintMapScreen> {
  late GoogleMapController mapController;
  final LatLng _center = const LatLng(14.5995, 120.9842);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Complaints Map')),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 11.0,
        ),
        markers: {
          const Marker(
            markerId: MarkerId('1'),
            position: LatLng(14.5995, 120.9842),
            infoWindow: InfoWindow(title: 'Sample Complaint'),
          ),
        },
      ),
    );
  }
}
