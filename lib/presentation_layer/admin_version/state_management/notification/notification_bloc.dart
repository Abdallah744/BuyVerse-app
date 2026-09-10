import 'dart:async';

import 'package:buy_verse_app/data_layer/admin/admin_models/notification_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core_layer/admin/helpers/cache_helper.dart';

// Event
abstract class NotificationEvent extends Equatable {
  const NotificationEvent();
  @override
  List<Object> get props => [];
}

class GetNotifications extends NotificationEvent {}

class MarkAllAsRead extends NotificationEvent {}

class MarkAsRead extends NotificationEvent {
  final String notificationId;
  const MarkAsRead(this.notificationId);
  @override
  List<Object> get props => [notificationId];
}

class UpdateNotificationList extends NotificationEvent {
  final List<NotificationModel> notifications;
  const UpdateNotificationList(this.notifications);
  @override
  List<Object> get props => [notifications];
}

// State
abstract class NotificationState extends Equatable {
  const NotificationState();
  @override
  List<Object> get props => [];
}

class NotificationInitial extends NotificationState {}

class NotificationLoading extends NotificationState {}

class NotificationLoaded extends NotificationState {
  final List<NotificationModel> notifications;
  final int unreadCount;
  const NotificationLoaded(this.notifications, this.unreadCount);
  @override
  List<Object> get props => [notifications, unreadCount];
}

class NotificationError extends NotificationState {
  final String message;
  const NotificationError(this.message);
  @override
  List<Object> get props => [message];
}

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  StreamSubscription? _notificationSubscription;

  NotificationBloc() : super(NotificationInitial()) {
    on<GetNotifications>((event, emit) async {
      emit(NotificationLoading());
      try {
        String? uId = CacheHelper.getData(key: 'uId');
        if (uId == null) {
          emit(const NotificationLoaded([], 0));
          return;
        }

        await _notificationSubscription?.cancel();
        _notificationSubscription = FirebaseFirestore.instance
            .collection('admin')
            .doc(uId)
            .collection('notifications')
            .orderBy('createdAt', descending: true)
            .snapshots()
            .listen((snapshot) {
              final notifications = snapshot.docs.map((doc) {
                return NotificationModel.fromMap(doc.id, doc.data());
              }).toList();

              add(UpdateNotificationList(notifications));
            });
      } catch (e) {
        emit(NotificationError(e.toString()));
      }
    });

    on<UpdateNotificationList>((event, emit) {
      int unreadCount = event.notifications.where((n) => !n.isRead).length;
      emit(NotificationLoaded(event.notifications, unreadCount));
    });

    on<MarkAllAsRead>((event, emit) async {
      try {
        String? uId = CacheHelper.getData(key: 'uId');
        if (uId == null) return;

        final unreadDocs = await FirebaseFirestore.instance
            .collection('admin')
            .doc(uId)
            .collection('notifications')
            .where('isRead', isEqualTo: false)
            .get();

        if (unreadDocs.docs.isEmpty) return;

        final batch = FirebaseFirestore.instance.batch();
        for (var doc in unreadDocs.docs) {
          batch.update(doc.reference, {'isRead': true});
        }

        await batch.commit();
      } catch (e) {
        // Handle error
      }
    });

    on<MarkAsRead>((event, emit) async {
      try {
        String? uId = CacheHelper.getData(key: 'uId');
        if (uId == null) return;

        await FirebaseFirestore.instance
            .collection('admin')
            .doc(uId)
            .collection('notifications')
            .doc(event.notificationId)
            .update({'isRead': true});
      } catch (e) {
        // Handle error
      }
    });
  }

  @override
  Future<void> close() {
    _notificationSubscription?.cancel();
    return super.close();
  }
}
