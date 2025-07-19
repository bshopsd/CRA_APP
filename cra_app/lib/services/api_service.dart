import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import '../models/complaint.dart';

class ApiService {
  static const baseUrl = 'http://10.0.2.2/complaint_api/api';

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

  static Future<bool> register(String name, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register.php'),
      body: jsonEncode({"name": name, "email": email, "password": password}),
      headers: {"Content-Type": "application/json"},
    );
    return jsonDecode(response.body)['success'];
  }

  static Future<List<Complaint>> fetchUserComplaints(int userId) async {
    final response = await http.get(Uri.parse('$baseUrl/get_user_complaints.php?user_id=$userId'));
    final data = jsonDecode(response.body);
    return (data['complaints'] as List).map((e) => Complaint.fromJson(e)).toList();
  }

  static Future<List<Complaint>> fetchAllComplaints() async {
    final response = await http.get(Uri.parse('$baseUrl/get_all_complaints.php'));
    final data = jsonDecode(response.body);
    return (data['complaints'] as List).map((e) => Complaint.fromJson(e)).toList();
  }

  static Future<bool> createComplaint(Map<String, dynamic> complaint) async {
    final response = await http.post(
      Uri.parse('$baseUrl/create_complaint.php'),
      body: jsonEncode(complaint),
      headers: {"Content-Type": "application/json"},
    );
    return jsonDecode(response.body)['success'];
  }

  static Future<bool> updateStatus(int id, String status) async {
    final response = await http.post(
      Uri.parse('$baseUrl/update_complaint_status.php'),
      body: jsonEncode({"id": id, "status": status}),
      headers: {"Content-Type": "application/json"},
    );
    return jsonDecode(response.body)['success'];
  }
}