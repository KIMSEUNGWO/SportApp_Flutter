import 'package:flutter/material.dart';
import 'package:flutter_sport/main.dart';
import 'package:flutter_sport/notifiers/login_notifier.dart';
import 'package:flutter_sport/notifiers/region_notifier.dart';
import 'package:flutter_sport/widgets/notification/notifications_widget.dart';
import 'package:flutter_sport/widgets/pages/login_page.dart';
import 'package:flutter_sport/widgets/pages/region_settings.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_sport/widgets/pages/search_page.dart';

class MyGroupPage extends ConsumerStatefulWidget {
  const MyGroupPage({super.key});

  @override
  ConsumerState<MyGroupPage> createState() => _MyGroupPageState();
}

class _MyGroupPageState extends ConsumerState<MyGroupPage> with AutomaticKeepAliveClientMixin {

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          elevation: 0,
          toolbarHeight: 50,
          floating: true,
          title: GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => RegionSettingsWidget(),));
            },
            child: Row(
              children: [
                Consumer(
                  builder: (context, ref, child) {
                    return Text(ref.watch(regionProvider).getLocaleName(EasyLocalization.of(context)!.locale),
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 24,
                          color: Color(0xFF2B2828)
                      ),
                    );
                  },
                ),
                SizedBox(width: 3,),
                Icon(Icons.arrow_forward_ios,
                  color: Color(0xFF2B2828),
                  size: 21,
                )
              ],
            ),
          ),
          // flexibleSpace: FlexibleSpaceBar(
          //   centerTitle: false,
          //   titlePadding: const EdgeInsets.only(left: 20, bottom: 10),
          //   title: Image.asset('assets/logo.jpg', ),
          // ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: IconButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SearchPage(),)),
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
                        showModalBottomSheet(context: context, builder: (context) {
                          return LoginPageWidget();
                        },);
                      },
                      icon: const Icon(Icons.login, size: 30,),
                    ),
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: IconButton(
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationsWidget(),)),
                      icon: const Icon(Icons.notifications_none, size: 30,),
                    ),
                  );
                }
              },
            ),

            // Padding(
            //   padding: const EdgeInsets.only(right: 20),
            //   child: IconButton(
            //     onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const OneToOneMessageWidget(),)),
            //     icon: const Icon(Icons.send, size: 30),
            //   ),
            // ),
          ],
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
