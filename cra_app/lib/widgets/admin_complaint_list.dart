import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/complaint.dart';
import '../services/api_service.dart';
import '../helpers/image_helper.dart';
import '../helpers/location_helper.dart';

class AdminComplaintList extends StatefulWidget {
  const AdminComplaintList({super.key});

  @override
  State<AdminComplaintList> createState() => _AdminComplaintListState();
}

class _AdminComplaintListState extends State<AdminComplaintList> {
  late Future<List<Complaint>> futureComplaints;

  @override
  void initState() {
    super.initState();
    futureComplaints = ApiService.getAllComplaints();
  }

  Future<void> _refreshComplaints() async {
    setState(() {
      futureComplaints = ApiService.getAllComplaints();
    });
  }

  Future<void> _markAsResolved(int complaintId) async {
    final success =
        await ApiService.updateComplaintStatus(complaintId, 'resolved');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            success ? "Marked as resolved" : "Failed to update complaint"),
      ),
    );

    if (success) _refreshComplaints();
  }

  void _openMap(double lat, double lng) async {
    final url = 'https://www.google.com/maps/search/?api=1&query=$lat,$lng';
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Could not open Google Maps")),
      );
    }
  }

  Widget _buildComplaintCard(Complaint c) {
    return FutureBuilder<String>(
      future: LocationHelper.getAddress(c.latitude, c.longitude, c.id),
      builder: (context, snapshot) {
        final address = snapshot.data ?? 'Locating...';
        final Uint8List? imageBytes = ImageHelper.tryDecodeImage(c.photo);

        return InkWell(
          onTap: () => _openMap(c.latitude, c.longitude),
          child: Card(
            margin: const EdgeInsets.only(bottom: 16),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(c.title,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Text(c.description),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined,
                          color: Colors.redAccent),
                      const SizedBox(width: 4),
                      Expanded(child: Text(address)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: imageBytes != null
                        ? Image.memory(
                            imageBytes,
                            height: 180,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            height: 180,
                            width: double.infinity,
                            color: Colors.grey[300],
                            child: const Center(
                              child: Icon(Icons.broken_image_outlined,
                                  size: 50, color: Colors.grey),
                            ),
                          ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Status: ${c.status}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: c.status == 'resolved'
                                  ? Colors.green
                                  : Colors.deepOrange)),
                      if (c.status != 'resolved')
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
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
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFDFD),
      appBar: AppBar(
        title: const Text("Admin Complaints"),
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      body: FutureBuilder<List<Complaint>>(
        future: futureComplaints,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No complaints found."));
          }

          final complaints = snapshot.data!;
          return RefreshIndicator(
            onRefresh: _refreshComplaints,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: complaints.length,
              itemBuilder: (context, index) =>
                  _buildComplaintCard(complaints[index]),
            ),
          );
        },
      ),
    );
  }
}
