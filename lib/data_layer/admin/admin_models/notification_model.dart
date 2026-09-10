import 'package:equatable/equatable.dart';

class NotificationModel extends Equatable {
  final String id;
  final String title;
  final String body;
  final String date;
  final bool isRead;
  final String? type; // 'product', 'order', etc.
  final String? targetId;

  const NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.date,
    this.isRead = false,
    this.type,
    this.targetId,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'body': body,
      'date': date,
      'isRead': isRead,
      'type': type,
      'targetId': targetId,
    };
  }

  factory NotificationModel.fromMap(String id, Map<String, dynamic> map) {
    return NotificationModel(
      id: id,
      title: map['title'] ?? '',
      body: map['body'] ?? '',
      date: map['date'] ?? '',
      isRead: map['isRead'] ?? false,
      type: map['type'],
      targetId: map['targetId'],
    );
  }

  @override
  List<Object?> get props => [id, title, body, date, isRead, type, targetId];
}
