import 'package:flutter/material.dart';
import '../models/complaint.dart';
import '../services/api_service.dart';
import '../widgets/complaint_card.dart';

class AdminComplaintList extends StatefulWidget {
  const AdminComplaintList({super.key});

  @override
  State<AdminComplaintList> createState() => _AdminComplaintListState();
}

class _AdminComplaintListState extends State<AdminComplaintList> {
  List<Complaint> complaints = [];
  bool isLoading = true;

  void loadComplaints() async {
    complaints = await ApiService.fetchAllComplaints();
    setState(() => isLoading = false);
  }

  void updateStatus(Complaint complaint) async {
    await ApiService.updateStatus(complaint.id, "Resolved");
    loadComplaints();
  }

  @override
  void initState() {
    super.initState();
    loadComplaints();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("All Complaints")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: complaints.map((c) => ComplaintCard(
                complaint: c,
                isAdmin: true,
                onUpdate: () => updateStatus(c),
              )).toList(),
            ),
    );
  }
}