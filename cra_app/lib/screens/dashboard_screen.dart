import 'package:flutter/material.dart';
import '../models/user.dart';
import 'complaint_form_screen.dart';
import 'complaint_map_screen.dart';

class DashboardScreen extends StatelessWidget {
  final User user;
  const DashboardScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Welcome ${user.name}')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ComplaintFormScreen(user: user)),
              ),
              child: const Text("Report a Complaint"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ComplaintMapScreen()),
              ),
              child: const Text("View Map"),
            ),
          ],
        ),
      ),
    );
  }
}
