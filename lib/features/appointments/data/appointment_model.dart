enum AppointmentStatus { pending, confirmed, cancelled, completed }

class Appointment {
  final String id;
  final String title;
  final String description;
  final DateTime dateTime;
  final String userId;
  final String? patientName;
  final int? age;
  final String? physicalPain;
  final String? otherInfo;
  final AppointmentStatus status;

  Appointment({
    required this.id,
    required this.title,
    required this.description,
    required this.dateTime,
    required this.userId,
    this.patientName,
    this.age,
    this.physicalPain,
    this.otherInfo,
    this.status = AppointmentStatus.pending,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['_id'] ?? json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      dateTime: DateTime.parse(json['dateTime']),
      userId: json['userId'] is Map ? json['userId']['_id'] : (json['userId'] ?? ''),
      patientName: json['patientName'] ?? (json['userId'] is Map ? json['userId']['name'] : null),
      age: json['age'],
      physicalPain: json['physicalPain'],
      otherInfo: json['otherInfo'],
      status: AppointmentStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
        orElse: () => AppointmentStatus.pending,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'dateTime': dateTime.toIso8601String(),
      'userId': userId,
      'patientName': patientName,
      'age': age,
      'physicalPain': physicalPain,
      'otherInfo': otherInfo,
      'status': status.toString().split('.').last,
    };
  }
}
