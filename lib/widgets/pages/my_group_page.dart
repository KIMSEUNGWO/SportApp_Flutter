import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_sport/main.dart';
import 'package:flutter_sport/notifiers/login_notifier.dart';
import 'package:flutter_sport/notifiers/region_notifier.dart';
import 'package:flutter_sport/widgets/notification/notifications_widget.dart';
import 'package:flutter_sport/widgets/pages/login_page.dart';
import 'package:flutter_sport/widgets/pages/region_settings.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_sport/widgets/pages/search_page.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
        CupertinoSliverRefreshControl(
          refreshTriggerPullDistance: 100.0,
          refreshIndicatorExtent: 50.0,
          onRefresh: () async {
            // 위로 새로고침
            await Future.delayed(Duration(seconds: 2));
          },
        ),

        SliverToBoxAdapter(
          child: Container(
            height: 120,
            margin: EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color(0xFFDCD7D7)
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text('내 모임',
              style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w500
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          sliver: SliverList.separated(
            separatorBuilder: (context, index) => SizedBox(height: 10,),
            itemCount: 2,
            itemBuilder: (context, index) {
              return Container(
                height: 150,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Color(0xFFF6F6F8)
                ),
                child: Column (
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('그룹 제목임',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),

                            ],
                          ),
                        ),
                        Container(
                          width: 65, height: 65,
                          margin: EdgeInsets.only(left: 15),
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                            color: Color(0xFFE4E4E4),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(child: SvgPicture.asset('assets/icons/emptyGroupImage.svg', width: 35, height: 35, color: Color(0xFF878181),))
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        )
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
