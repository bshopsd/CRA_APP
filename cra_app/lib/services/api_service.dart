import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import '../models/complaint.dart';

class ApiService {
  static const baseUrl = 'http://10.34.50.174/cra_api/api';

  static Future<User?> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login.php'),
      body: jsonEncode({"email": email, "password": password}),
      headers: {"Content-Type": "application/json"},
    );

    final data = jsonDecode(response.body);
    if (data['success']) {
      return User.fromJson(data['user']);
    }
    return null;
  }

  static Future<bool> register(
      String name, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register.php'),
      body: jsonEncode({"name": name, "email": email, "password": password}),
      headers: {"Content-Type": "application/json"},
    );
    return jsonDecode(response.body)['success'];
  }

    static Future<List<Complaint>> fetchUserComplaints(int userId) async {
      final response = await http.get(
        Uri.parse('$baseUrl/get_user_complaints.php?user_id=$userId'),
      );

      final data = jsonDecode(response.body);
      print("API Response: $data"); 

      if (data['success'] && data['complaints'] != null) {
        return (data['complaints'] as List)
            .map((e) => Complaint.fromJson(e))
            .toList();
      } else {
        throw Exception("Failed to load complaints");
      }
    }

  static Future<List<Complaint>> getAllComplaints() async {
    final response =
        await http.get(Uri.parse('$baseUrl/get_all_complaint.php'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success']) {
        List complaintsJson = data['data'];
        return complaintsJson.map((e) => Complaint.fromJson(e)).toList();
      } else {
        throw Exception("Failed to load complaints");
      }
    } else {
      throw Exception("Server error");
    }
  }

  static Future<bool> createComplaint(Map<String, dynamic> complaint) async {
    final response = await http.post(
      Uri.parse('$baseUrl/create_complaint.php'),
      body: jsonEncode(complaint),
      headers: {"Content-Type": "application/json"},
    );
    return jsonDecode(response.body)['success'];
  }

  static Future<bool> updateComplaintStatus(int id, String status) async {
    final response = await http.post(
      Uri.parse('$baseUrl/update_complaint_status.php'),
      body: jsonEncode({"id": id, "status": status}),
      headers: {"Content-Type": "application/json"},
    );
    return jsonDecode(response.body)['success'];
  }
}
