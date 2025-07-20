import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';

import '../models/complaint.dart';
import '../services/api_service.dart';
import '../helpers/location_helper.dart';

class AdminComplaintList extends StatefulWidget {
  const AdminComplaintList({super.key});

  @override
  State<AdminComplaintList> createState() => _AdminComplaintListState();
}

class _AdminComplaintListState extends State<AdminComplaintList> {
  late Future<List<Complaint>> _futureComplaints;
  Position? _adminPosition;
  final Color primaryColor = const Color(0xFFFF8774);
  final Map<int, String> _addressCache = {};

  @override
  void initState() {
    super.initState();
    _loadComplaints();
    _getAdminLocation();
  }

  void _loadComplaints() {
    _futureComplaints = ApiService.getAllComplaints();
  }

  Future<void> _getAdminLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _showSnack("Location services are disabled.");
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        _showSnack("Location permission denied.");
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _adminPosition = position;
      });
    } catch (e) {
      _showSnack("Failed to get location: $e");
    }
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<void> _refreshComplaints() async {
    setState(() {
      _loadComplaints();
    });
  }

  Future<void> _markAsResolved(int complaintId) async {
    final success =
        await ApiService.updateComplaintStatus(complaintId, 'resolved');
    _showSnack(success
        ? "Marked as resolved"
        : "Failed to update complaint status");

    if (success) _refreshComplaints();
  }

  Widget _buildComplaintCard(Complaint c) {
    final distanceInKm = _adminPosition != null
        ? Geolocator.distanceBetween(
              _adminPosition!.latitude,
              _adminPosition!.longitude,
              c.latitude,
              c.longitude,
            ) /
            1000
        : null;

    return FutureBuilder<String>(
      future: _addressCache.containsKey(c.id)
          ? Future.value(_addressCache[c.id])
          : LocationHelper.getAddress(c.latitude, c.longitude, c.id),
      builder: (context, snapshot) {
        final address = snapshot.data ?? "Fetching location...";
        if (snapshot.hasData) _addressCache[c.id] = snapshot.data!;

        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(c.title,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text(c.description, style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 8),
                Text(address, style: const TextStyle(color: Colors.black87)),
                if (distanceInKm != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      "Distance: ${distanceInKm.toStringAsFixed(2)} km",
                      style: const TextStyle(color: Colors.grey, fontSize: 14.5),
                    ),
                  ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    height: 200,
                    width: double.infinity,
                    color: Colors.grey[200],
                    child: FlutterMap(
                      options: MapOptions(
                        center: LatLng(c.latitude, c.longitude),
                        zoom: 15.0,
                        interactiveFlags: InteractiveFlag.none,
                      ),
                      children: [
                        TileLayer(
                          urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                          subdomains: ['a', 'b', 'c'],
                        ),
                        MarkerLayer(
                          markers: [
                            Marker(
                              point: LatLng(c.latitude, c.longitude),
                              width: 40,
                              height: 40,
                              child: const Icon(Icons.location_pin, size: 40, color: Colors.red),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Status: ${c.status}",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: c.status == 'resolved'
                            ? Colors.green
                            : Colors.deepOrange,
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.directions),
                          tooltip: "Open in Google Maps",
                          onPressed: () async {
                            final uri = Uri.parse(
                                "https://www.google.com/maps/search/?api=1&query=${c.latitude},${c.longitude}");
                            if (await canLaunchUrl(uri)) {
                              await launchUrl(uri,
                                  mode: LaunchMode.externalApplication);
                            } else {
                              _showSnack("Could not open Google Maps.");
                            }
                          },
                        ),
                        if (c.status != 'resolved')
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                            icon: const Icon(Icons.check_circle_outline),
                            label: const Text("Resolve"),
                            onPressed: () => _markAsResolved(c.id),
                          ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildComplaintList(List<Complaint> complaints) {
    return RefreshIndicator(
      onRefresh: _refreshComplaints,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: complaints.length,
        itemBuilder: (context, index) =>
            _buildComplaintCard(complaints[index]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFDFD),
      appBar: AppBar(
        title: const Text("List of Complaints"),
        backgroundColor: primaryColor,
        elevation: 0,
      ),
      body: FutureBuilder<List<Complaint>>(
        future: _futureComplaints,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (snapshot.data?.isEmpty ?? true) {
            return const Center(child: Text("No complaints found."));
          }

          return _buildComplaintList(snapshot.data!);
        },
      ),
    );
  }
}
