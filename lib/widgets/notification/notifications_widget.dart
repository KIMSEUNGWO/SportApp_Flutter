import 'package:flutter/material.dart';
import 'package:flutter_sport/api/api_service.dart';
import 'package:flutter_sport/models/component.dart';
import 'package:flutter_sport/models/notification.dart';
import 'package:flutter_sport/widgets/notification/notification_widget.dart';

import 'package:easy_localization/easy_localization.dart';

class NotificationsWidget extends StatefulWidget {
  const NotificationsWidget({super.key});

  @override
  State<NotificationsWidget> createState() => _NotificationsWidgetState();
}

class _NotificationsWidgetState extends State<NotificationsWidget> {
  late final List<Notifications> notifications;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    initNotifications();
  }
  initNotifications() async {
    notifications = await ApiService.getTestNotification(3);
    setState(() {
      isLoading = false;
    });
  }

  deleteNotification(Notifications notify) {
    notifications.remove(notify);
    if (notifications.isEmpty) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Theme.of(context).colorScheme.background,
        title: Text('mainAppBarMenus').tr(gender: 'notification'),
      ),
      body: isLoading
        ? const Center(child: CircularProgressIndicator(),)
        : notifications.isEmpty
            ? EmptyElement(message: 'alert'.tr(gender: 'emptyNotification'))
            : makeNotifies(notifications)
      ,
      // body: FutureBuilder(
      //   future: notifications,
      //   builder: (context, snapshot) {
      //     if (snapshot.hasData) {
      //       if (snapshot.data!.isEmpty) {
      //         return const Center(
      //           child: Text('알림이 없습니다.', style: TextStyle(fontSize: 25, color: Color(0xFF898989)),),
      //         );
      //       } else {
      //         return makeNotifies(snapshot);
      //       }
      //     } else {
      //       return const Center(
      //         child: CircularProgressIndicator(),
      //       );
      //     }
      //   },
      // )
    );
  }

  ListView makeNotifies(List<Notifications> notifyList) {
    return ListView.builder(
      itemCount: notifyList.length,
        itemBuilder: (context, index) {
          var notify = notifyList[index];
          return Dismissible(
            key: Key(notify.id),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) {
              deleteNotification(notify);
            },
            child: NotificationWidget(
                id: notify.id,
                thumb: notify.thumb,
                title: notify.title,
                date: notify.date),
          );
        },
    );
  }
}


