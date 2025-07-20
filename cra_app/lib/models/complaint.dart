class Complaint {
  final int id;
  final int userId;
  final String title;
  final String description;
  final String photo;
  final double latitude;
  final double longitude;
  final String status;
  final DateTime createdAt;

  Complaint({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.photo,
    required this.latitude,
    required this.longitude,
    required this.status,
    required this.createdAt,
  });

  factory Complaint.fromJson(Map<String, dynamic> json) {
    final latitudeStr = json['latitude']?.toString() ?? '0.0';
    final longitudeStr = json['longitude']?.toString() ?? '0.0';

    final double latitude = double.tryParse(latitudeStr) ?? 0.0;
    final double longitude = double.tryParse(longitudeStr) ?? 0.0;

    print('[Complaint] ID: ${json['id']} → lat: $latitude, lng: $longitude');

    return Complaint(
      id: int.tryParse(json['id'].toString()) ?? 0,
      userId: int.tryParse(json['user_id'].toString()) ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      photo: json['photo'] ?? '',
      latitude: latitude,
      longitude: longitude,
      status: json['status'] ?? 'pending',
      createdAt:
          DateTime.tryParse(json['created_at'].toString()) ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'description': description,
      'photo': photo,
      'latitude': latitude,
      'longitude': longitude,
      'status': status,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
