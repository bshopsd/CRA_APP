import 'package:flutter/material.dart';
import '../models/user.dart';
import '../models/complaint.dart';
import '../services/api_service.dart';
import 'complaint_location_screen.dart';
import 'complaint_form_screen.dart';
import 'package:url_launcher/url_launcher.dart';

const Color primaryColor = Color(0xFFFF8774);

class DashboardScreen extends StatefulWidget {
  final User user;
  const DashboardScreen({super.key, required this.user});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late Future<List<Complaint>> futureComplaints;

  @override
  void initState() {
    super.initState();
    futureComplaints = ApiService.fetchUserComplaints(widget.user.id); // Only user's complaints
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFDFD),
      appBar: AppBar(
      title: Text(
        'Dashboard - ${widget.user.name}',
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: primaryColor,
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh, color: Colors.white),
          tooltip: 'Refresh Complaints',
          onPressed: () {
            setState(() {
              futureComplaints = ApiService.fetchUserComplaints(widget.user.id);
            });
          },
        ),
      ],
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
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
            itemCount: complaints.length,
            itemBuilder: (context, index) =>
                _buildComplaintCard(context, complaints[index]),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: primaryColor,
        icon: const Icon(Icons.add_location_alt, color: Colors.white),
        label: const Text(
          "File Complaint",
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ComplaintFormScreen(user: widget.user),
            ),
          );
        },
      ),
    );
  }

  Widget _buildComplaintCard(BuildContext context, Complaint c) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ComplaintLocationScreen(
              latitude: c.latitude,
              longitude: c.longitude,
              title: c.title,
            ),
          ),
        );
      },
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Header
              Row(
                children: [
                  const Icon(Icons.report_problem_rounded, color: primaryColor),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      c.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: "Open in Google Maps",
                    icon: const Icon(Icons.map, color: Colors.blue),
                    onPressed: () async {
                      final googleUrl =
                          'https://www.google.com/maps/search/?api=1&query=${c.latitude},${c.longitude}';
                      if (await canLaunchUrl(Uri.parse(googleUrl))) {
                        await launchUrl(Uri.parse(googleUrl));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Could not launch Google Maps")),
                        );
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),

              /// Description
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.description, size: 20, color: Colors.grey),
                  const SizedBox(width: 8),
                  Expanded(child: Text(c.description)),
                ],
              ),
              const SizedBox(height: 8),

              /// Status
              Row(
                children: [
                  const Icon(Icons.info_outline, size: 20, color: Colors.grey),
                  const SizedBox(width: 8),
                  Text(
                    "Status: ${c.status}",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: c.status == 'resolved' ? Colors.green : Colors.orange,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),
              const Text(
                "Tap card to view location in app map",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
