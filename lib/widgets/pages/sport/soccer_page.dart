
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_sport/models/region_data.dart';
import 'package:flutter_sport/notifiers/region_notifier.dart';
import 'package:flutter_sport/widgets/lists/large_list_widget.dart';
import 'package:flutter_sport/widgets/lists/small_list_widget.dart';
import 'package:flutter_sport/widgets/pages/search_page.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SoccerPage extends ConsumerWidget {

  final String label;

  const SoccerPage({super.key, required this.label});


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Locale locale = EasyLocalization.of(context)!.locale;
    String translationRegionTitle = ref.read(regionProvider.notifier).getLocalName(locale);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        title: Text('sportTitle').tr(gender: label),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              icon: const Icon(Icons.search, size: 30,),
              onPressed: () => {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const SearchPage(),))
              },
            ),
          )
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Text('recentlySearchGroups',
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF565360),
                        ),
                      ).tr(),
                      SizedBox(width: 5,),
                      Text('🔥', style: TextStyle(fontSize: 19),)
                    ],
                  ),
                ),
                SizedBox(height: 10,),
                SizedBox(
                  height: 200,
                  child: ListView.separated(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    scrollDirection: Axis.horizontal,
                    separatorBuilder: (context, index) => SizedBox(width: 20,),
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return LargeListWidget(
                        id: 1,
                        image: Image.asset('assets/groupImages/sample1.jpeg', fit: BoxFit.fill,),
                        title: '모임제목모임제목모임제목모임제목모임제목모임제목',
                        region: '시부야구',
                        personCount: 3,
                        extraInfo: Text('recentlyChat',
                          style: TextStyle(
                            color: Color(0xFFF34C4C),
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ).tr(),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Text('recentlySearchGroups',
                        style: TextStyle(
                          fontSize: 19,
                          color: Color(0xFF565360),
                          fontWeight: FontWeight.w500,
                        ),
                      ).tr(),
                      SizedBox(width: 5,),
                      Text('🔰', style: TextStyle(fontSize: 19),)
                    ],
                  ),
                ),
                SizedBox(height: 10,),
                SizedBox(
                  height: 200,
                  child: ListView.separated(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    scrollDirection: Axis.horizontal,
                    separatorBuilder: (context, index) => SizedBox(width: 20,),
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return LargeListWidget(
                        id: 1,
                        image: Image.asset('assets/groupImages/sample1.jpeg', fit: BoxFit.fill,),
                        title: '모임제목모임제목모임제목모임제목모임제목모임제목',
                        region: '시부야구',
                        personCount: 3,
                        extraInfo: Text('NEW',
                          style: TextStyle(
                            color: Color(0xFF53C62C),
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 20,),
              ],
            ),
          ),

          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child : Text('activateIn',
                style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w500
                ),
              ).tr(args: [translationRegionTitle]),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.all(20),
            sliver: SliverList.separated(
              separatorBuilder: (context, index) => SizedBox(height: 5,),
              itemCount: 20,
              itemBuilder: (context, index) {
                return SmallListWidget(
                  id: 1,
                  image: Image.asset('assets/groupImages/sample1.jpeg', fit: BoxFit.fill,),
                  title: '野球団野球団野球団野球団野球団野球団野球団野球団',
                  intro: '新人さんを待っています',
                  sportType: '야구',
                  region: '신주쿠구',
                  personCount: 3,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

