
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_sport/common/navigator_helper.dart';
import 'package:flutter_sport/models/club/region_data.dart';
import 'package:flutter_sport/models/club/sport_type.dart';
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
        backgroundColor: Theme.of(context).colorScheme.background,
        scrolledUnderElevation: 0,
        title: const Text('sportTitle',
          style: TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ).tr(gender: label),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              icon: const Icon(Icons.search, size: 30,),
              onPressed: () {
              NavigatorHelper.push(context, const SearchPage());
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
                  child: Text('mostActiveGroups',
                    style: TextStyle(
                      fontSize: Theme.of(context).textTheme.displayMedium!.fontSize,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.primary
                    ),
                  ).tr(),
                ),
                const SizedBox(height: 10,),
                SizedBox(
                  height: 170,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    scrollDirection: Axis.horizontal,
                    separatorBuilder: (context, index) => const SizedBox(width: 20,),
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return LargeListWidget(
                        id: 1,
                        image: Image.asset('assets/groupImages/sample1.jpeg', fit: BoxFit.fill,),
                        title: '모임제목모임제목모임제목모임제목모임제목모임제목',
                        region: '시부야구',
                        personCount: 300,
                        extraInfo: const Text('recentlyChat',
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
                  child: Text('newGroups',
                    style: TextStyle(
                      fontSize: Theme.of(context).textTheme.displayMedium!.fontSize,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.primary
                    ),
                  ).tr(),
                ),
                const SizedBox(height: 10,),
                SizedBox(
                  height: 170,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    scrollDirection: Axis.horizontal,
                    separatorBuilder: (context, index) => const SizedBox(width: 20,),
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return LargeListWidget(
                        id: 1,
                        image: Image.asset('assets/groupImages/sample1.jpeg', fit: BoxFit.fill,),
                        title: '모임제목모임제목모임제목모임제목모임제목모임제목',
                        region: '시부야구',
                        personCount: 3,
                        extraInfo: const Text('NEW',
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
                const SizedBox(height: 20,),
              ],
            ),
          ),

          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child : Text('activateIn',
                style: TextStyle(
                  fontSize: Theme.of(context).textTheme.displayMedium!.fontSize,
                  fontWeight: FontWeight.w600,
                ),
              ).tr(args: [translationRegionTitle]),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList.separated(
              separatorBuilder: (context, index) => const SizedBox(height: 5,),
              itemCount: 20,
              itemBuilder: (context, index) {
                return SmallListWidget(
                  id: 1,
                  image: Image.asset('assets/groupImages/sample1.jpeg', fit: BoxFit.fill,),
                  title: '野球団野球団野球団野球団野球団野球団野球団野球団',
                  intro: '新人さんを待っています',
                  sport: SportType.BASKETBALL,
                  region: Region.TAITO,
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

