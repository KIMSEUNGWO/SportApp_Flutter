
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_sport/common/alert.dart';
import 'package:flutter_sport/common/navigator_helper.dart';
import 'package:flutter_sport/notifiers/login_notifier.dart';
import 'package:flutter_sport/notifiers/region_notifier.dart';
import 'package:flutter_sport/widgets/notification/notifications_widget.dart';
import 'package:flutter_sport/widgets/pages/region_settings.dart';
import 'package:flutter_sport/widgets/pages/search_page.dart';

class CustomSliverAppBar extends StatelessWidget {
  const CustomSliverAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      scrolledUnderElevation: 0,
      elevation: 0,
      toolbarHeight: 50,
      floating: true,
      backgroundColor: Theme.of(context).colorScheme.background,
      title: GestureDetector(
        onTap: () {
          NavigatorHelper.push(context, RegionSettingsWidget());
        },
        child: Row(
          children: [
            Consumer(
              builder: (context, ref, child) {
                return Text(ref.watch(regionProvider).getLocaleName(EasyLocalization.of(context)!.locale),
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: Theme.of(context).textTheme.displayLarge!.fontSize,
                    color: Theme.of(context).colorScheme.primary
                  ),
                );
              },
            ),
            SizedBox(width: 5,),
            Icon(Icons.arrow_forward_ios,
              color: Theme.of(context).colorScheme.primary,
              size: Theme.of(context).textTheme.displayLarge!.fontSize,
            )
          ],
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: IconButton(
            onPressed: () => NavigatorHelper.push(context, const SearchPage()),
            icon: const Icon(Icons.search, size: 30,),
          ),
        ),
        Consumer(
          builder: (context, ref, child) {
            final profile = ref.watch(loginProvider);
            if (profile == null) {
              return Padding(
                padding: const EdgeInsets.only(right: 20),
                child: IconButton(
                  onPressed: () {
                    Alert.requireLogin(context);
                  },
                  icon: const Icon(Icons.login, size: 30,),
                ),
              );
            } else {
              return Padding(
                padding: const EdgeInsets.only(right: 20),
                child: IconButton(
                  onPressed: () => NavigatorHelper.push(context, const NotificationsWidget()),
                  icon: const Icon(Icons.notifications_none, size: 30,),
                ),
              );
            }
          },
        ),
      ],
    );
  }
}