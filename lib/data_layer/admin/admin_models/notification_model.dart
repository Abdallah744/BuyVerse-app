import 'package:equatable/equatable.dart';

class NotificationModel extends Equatable {
  final String id;
  final String title;
  final String body;
  final String date;
  final bool isRead;

  const NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.date,
    this.isRead = false,
  });

  Map<String, dynamic> toMap() {
    return {'title': title, 'body': body, 'date': date, 'isRead': isRead};
  }

  factory NotificationModel.fromMap(String id, Map<String, dynamic> map) {
    return NotificationModel(
      id: id,
      title: map['title'] ?? '',
      body: map['body'] ?? '',
      date: map['date'] ?? '',
      isRead: map['isRead'] ?? false,
    );
  }

  @override
  List<Object?> get props => [id, title, body, date, isRead];
}
