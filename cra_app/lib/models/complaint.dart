class Complaint {
  final int id;
  final int userId;
  final String title;
  final String description;
  final String photo;
  final double latitude;
  final double longitude;
  final String status;

  Complaint({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.photo,
    required this.latitude,
    required this.longitude,
    required this.status,
  });

  factory Complaint.fromJson(Map<String, dynamic> json) {
    return Complaint(
      id: int.parse(json['id'].toString()),
      userId: int.parse(json['user_id'].toString()),
      title: json['title'],
      description: json['description'],
      photo: json['photo'],
      latitude: double.parse(json['latitude'].toString()),
      longitude: double.parse(json['longitude'].toString()),
      status: json['status'],
    );
  }
}