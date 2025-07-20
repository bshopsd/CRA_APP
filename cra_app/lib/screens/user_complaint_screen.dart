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
  bool hasError = false;

  final Color primaryColor = const Color(0xFFFF8774);

  @override
  void initState() {
    super.initState();
    loadUserComplaints();
  }

  Future<void> loadUserComplaints() async {
    try {
      print('Fetching complaints for user ID: ${widget.user.id}');
      final result = await ApiService.fetchUserComplaints(widget.user.id);
      print('Fetch successful. Complaints: ${result.length}');
      setState(() {
        complaints = result;
        isLoading = false;
        hasError = false;
      });
    } catch (e, stackTrace) {
      print('Error: $e');
      print(stackTrace);
      setState(() {
        isLoading = false;
        hasError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFDFD),
      appBar: AppBar(
        title: const Text("My Complaints"),
        backgroundColor: primaryColor,
        elevation: 0,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : hasError
              ? _buildErrorState()
              : complaints.isEmpty
                  ? _buildEmptyState()
                  : RefreshIndicator(
                      onRefresh: loadUserComplaints,
                      child: ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: complaints.length,
                        itemBuilder: (context, index) =>
                            ComplaintCard(complaint: complaints[index]),
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 12),
                      ),
                    ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.red),
          const SizedBox(height: 12),
          const Text("Failed to load complaints.",
              style: TextStyle(fontSize: 16)),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: loadUserComplaints,
            style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
            child: const Text("Retry"),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.inbox, size: 48, color: Colors.grey),
          SizedBox(height: 12),
          Text("You have no complaints yet.",
              style: TextStyle(fontSize: 16, color: Colors.grey)),
        ],
      ),
    );
  }
}
