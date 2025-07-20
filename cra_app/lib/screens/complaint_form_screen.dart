import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
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
  File? _imageFile;
  bool isSubmitting = false;

  @override
  void initState() {
    super.initState();
    fetchLocation();
  }

  Future<void> fetchLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      showError("Please enable location services.");
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        showError("Location permission denied.");
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      showError(
        "Location permission permanently denied. Please enable in settings.",
      );
      return;
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        lat = position.latitude;
        lng = position.longitude;
      });
    } catch (e) {
      showError("Error fetching location.");
    }
  }

  void showError(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.camera);
    if (picked != null) {
      setState(() => _imageFile = File(picked.path));
    }
  }

  Future<void> submitComplaint() async {
    if (titleController.text.isEmpty ||
        descriptionController.text.isEmpty ||
        lat == null ||
        lng == null) {
      showError("All fields and location are required.");
      return;
    }

    setState(() => isSubmitting = true);

    String photoBase64 = '';
    if (_imageFile != null) {
      List<int> imageBytes = await _imageFile!.readAsBytes();
      photoBase64 = base64Encode(imageBytes);
    }

    final data = {
      'user_id': widget.user.id,
      'title': titleController.text,
      'description': descriptionController.text,
      'photo': photoBase64,
      'latitude': lat,
      'longitude': lng,
    };

    bool success = await ApiService.createComplaint(data);
    setState(() => isSubmitting = false);

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content:
          Text(success ? '✅ Complaint submitted!' : '❌ Submission failed.'),
    ));

    if (success) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = const Color(0xFFFF8774);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text("Submit Complaint"),
        backgroundColor: themeColor,
        elevation: 2,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLabel("Title"),
            _styledInputField(
                controller: titleController, hint: "Complaint title..."),
            const SizedBox(height: 15),
            _buildLabel("Description"),
            _styledInputField(
              controller: descriptionController,
              hint: "Describe the complaint...",
              maxLines: 4,
            ),
            const SizedBox(height: 15),
            _buildLabel("Photo"),
            if (_imageFile != null) ...[
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(_imageFile!, height: 160, fit: BoxFit.cover),
              ),
            ],
            const SizedBox(height: 20),
            Row(
              children: [
                const Icon(Icons.location_pin, color: Colors.redAccent),
                const SizedBox(width: 8),
                Text(
                  lat != null ? '($lat, $lng)' : 'Fetching location...',
                  style: TextStyle(color: Colors.grey[700]),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Center(
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.send),
                  onPressed: isSubmitting ? null : submitComplaint,
                  label: isSubmitting
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2),
                        )
                      : const Text("Submit Complaint"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: themeColor,
                    textStyle: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(text,
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: Colors.grey[800]));
  }

  Widget _styledInputField({
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
      ),
    );
  }
}
