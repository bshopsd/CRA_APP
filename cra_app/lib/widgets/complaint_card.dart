import 'package:flutter/material.dart';
import '../models/complaint.dart';

class ComplaintCard extends StatelessWidget {
  final Complaint complaint;
  final VoidCallback? onUpdate;
  final bool isAdmin;

  const ComplaintCard({
    super.key,
    required this.complaint,
    this.onUpdate,
    this.isAdmin = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(complaint.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(complaint.description),
            Text("Status: ${complaint.status}"),
            const SizedBox(height: 6),
            Text("Location: (${complaint.latitude}, ${complaint.longitude})"),
            if (isAdmin) ...[
              const SizedBox(height: 10),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () => onUpdate?.call(),
                    child: const Text("Mark Resolved"),
                  )
                ],
              )
            ]
          ],
        ),
      ),
    );
  }
}
