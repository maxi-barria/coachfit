import 'package:mobile/models/user.dart';

class CoachClient {
  final String id;
  final String? note;
  final DateTime startDate;
  final DateTime? endDate;
  final User client;

  CoachClient({
    required this.id,
    this.note,
    required this.startDate,
    this.endDate,
    required this.client,
  });

  factory CoachClient.fromJson(Map<String, dynamic> json) {
    return CoachClient(
      id: json['id'],
      note: json['note'],
      startDate: DateTime.parse(json['startDate']),
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      client: User.fromJson(json['client']),
    );
  }
}
