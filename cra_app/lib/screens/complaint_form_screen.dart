import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../models/user.dart';
import '../services/api_service.dart';

class ComplaintFormScreen extends StatefulWidget {
  final User user;
  const ComplaintFormScreen({super.key, required this.user});

  @override
  State<ComplaintFormScreen> createState() => _ComplaintFormScreenState();
}

class _ComplaintFormScreenState extends State<ComplaintFormScreen> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  double? lat;
  double? lng;

  void submitComplaint() async {
    final Map<String, dynamic> data = {
      'user_id': widget.user.id,
      'title': titleController.text,
      'description': descriptionController.text,
      'photo': '',
      'latitude': lat,
      'longitude': lng,
    };
    bool success = await ApiService.createComplaint(data);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(success ? 'Complaint submitted' : 'Submission failed'),
    ));
  }

  void fetchLocation() async {
    Position pos = await Geolocator.getCurrentPosition();
    setState(() {
      lat = pos.latitude;
      lng = pos.longitude;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("New Complaint")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(controller: titleController, decoration: const InputDecoration(labelText: 'Title')),
            TextField(controller: descriptionController, decoration: const InputDecoration(labelText: 'Description')),
            const SizedBox(height: 10),
            Text(lat != null ? 'Location: ($lat, $lng)' : 'Fetching location...'),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: submitComplaint, child: const Text("Submit Complaint"))
          ],
        ),
      ),
    );
  }
}