import 'package:flutter/material.dart';
import '../models/complaint.dart';
import '../models/user.dart';
import '../services/api_service.dart';
import '../widgets/complaint_card.dart';

class UserComplaintsScreen extends StatefulWidget {
  final User user;
  const UserComplaintsScreen({super.key, required this.user});

  @override
  State<UserComplaintsScreen> createState() => _UserComplaintsScreenState();
}

class _UserComplaintsScreenState extends State<UserComplaintsScreen> {
  List<Complaint> complaints = [];
  bool isLoading = true;

  void loadUserComplaints() async {
    complaints = await ApiService.fetchUserComplaints(widget.user.id);
    setState(() => isLoading = false);
  }

  @override
  void initState() {
    super.initState();
    loadUserComplaints();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Complaints")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: complaints.map((c) => ComplaintCard(complaint: c)).toList(),
            ),
    );
  }
}