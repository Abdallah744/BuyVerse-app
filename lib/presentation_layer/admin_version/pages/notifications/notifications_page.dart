import 'package:buy_verse_app/presentation_layer/admin_version/state_management/notification/notification_bloc.dart';
import 'package:buy_verse_app/presentation_layer/admin_version/widgets/responsive_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../../core_layer/admin/helpers/app_localization.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    var l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: HexColor('F7F8FA'),
      appBar: AppBar(
        backgroundColor: HexColor('F5821F'),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
            size: 20,
          ),
        ),
        title: Text(
          l10n?.translate('notifications') ?? 'Notifications',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              context.read<NotificationBloc>().add(MarkAllAsRead());
            },
            child: Text(
              l10n?.translate('mark_all_as_read') ?? 'Mark all',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: BlocBuilder<NotificationBloc, NotificationState>(
        builder: (context, state) {
          if (state is NotificationLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is NotificationLoaded) {
            if (state.notifications.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.notifications_none_outlined,
                      size: 80,
                      color: Colors.grey[300],
                    ),
                    const Gap(20),
                    Text(
                      l10n?.translate('no_notifications') ??
                          'No notifications yet',
                      style: TextStyle(color: Colors.grey[500], fontSize: 16),
                    ),
                  ],
                ),
              );
            }
            return ListView.separated(
              padding: EdgeInsets.all(context.setWidth(20)),
              itemBuilder: (context, index) {
                final notification = state.notifications[index];
                return Container(
                  padding: EdgeInsets.all(context.setWidth(15)),
                  decoration: BoxDecoration(
                    color: notification.isRead
                        ? Colors.white
                        : HexColor('F5821F').withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(15),
                    border: notification.isRead
                        ? null
                        : Border.all(
                            color: HexColor('F5821F').withValues(alpha: 0.2),
                          ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: notification.isRead
                              ? Colors.grey[100]
                              : HexColor('F5821F').withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          notification.isRead
                              ? Icons.notifications_outlined
                              : Icons.notifications_active,
                          color: notification.isRead
                              ? Colors.grey
                              : HexColor('F5821F'),
                          size: 20,
                        ),
                      ),
                      const Gap(15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              notification.title,
                              style: TextStyle(
                                fontWeight: notification.isRead
                                    ? FontWeight.w600
                                    : FontWeight.bold,
                                fontSize: context.setSp(16),
                              ),
                            ),
                            const Gap(5),
                            Text(
                              notification.body,
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: context.setSp(14),
                              ),
                            ),
                            const Gap(10),
                            Text(
                              notification.date,
                              style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: context.setSp(12),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (!notification.isRead)
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: HexColor('F5821F'),
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                );
              },
              separatorBuilder: (context, index) => Gap(context.setHeight(10)),
              itemCount: state.notifications.length,
            );
          }
          return Center(child: Text(l10n?.translate('error') ?? 'Error'));
        },
      ),
    );
  }
}
