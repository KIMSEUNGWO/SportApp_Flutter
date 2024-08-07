
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_sport/common/navigator_helper.dart';
import 'package:flutter_sport/common/svg_icon.dart';
import 'package:flutter_sport/models/club/club_data.dart';
import 'package:flutter_sport/notifiers/recentlyClubNotifier.dart';
import 'package:flutter_sport/widgets/lists/small_list_widget.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_sport/widgets/pages/common/common_sliver_appbar.dart';
import 'package:flutter_sport/widgets/pages/recently_visit_group.dart';
import 'package:flutter_sport/widgets/pages/sport/soccer_page.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MainPage extends ConsumerStatefulWidget {

  const MainPage({super.key,});

  @override
  ConsumerState<MainPage> createState() => _MainPageState();
}

class _MainPageState extends ConsumerState<MainPage> with AutomaticKeepAliveClientMixin {
  final double margin = 20;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      slivers: [
        CustomSliverAppBar(),
        CupertinoSliverRefreshControl(
          refreshTriggerPullDistance: 100.0,
          refreshIndicatorExtent: 50.0,
          onRefresh: () async {
            // 위로 새로고침
            await Future.delayed(const Duration(seconds: 2));
          },
        ),
        const InfinityBanner(),
        const Menus(),
        const SliverToBoxAdapter(child: SizedBox(height: 40,),),
        if (ref.read(recentlyClubNotifier.notifier).length() != 0)
          SliverToBoxAdapter(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: margin),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('recentlySearchGroups',
                      style: TextStyle(
                        fontSize: Theme.of(context).textTheme.displayMedium!.fontSize,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.primary
                      ),
                    ).tr(),
                    GestureDetector(
                      onTap: () => NavigatorHelper.push(context, const RecentlyVisitPages()),
                      child: Text('more',
                        style: TextStyle(
                          fontSize: 15,
                          color: Theme.of(context).colorScheme.secondary
                        ),
                      ).tr(),
                    )
                  ],
                ),
                ListView.builder(
                  padding: const EdgeInsets.only(top: 15),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: min(ref.watch(recentlyClubNotifier.notifier).length(), 5),
                  itemBuilder: (context, index) {
                    ClubSimp club = ref.read(recentlyClubNotifier.notifier).index(index);
                    if (club.sport != null && club.region != null) {
                      return SmallListWidget(
                        id: club.id,
                        image: club.thumbnail,
                        title: club.title,
                        intro: club.intro,
                        sport: club.sport!,
                        region: club.region!,
                        personCount: club.personCount,
                      );
                    }
                    return null;
                  },
                ),
              ],

            ),
          ),
        ),
      ],
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

class Menus extends StatelessWidget {

  const Menus({super.key,});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Menu(
                  page: SoccerPage(label : 'soccer'),
                  svgIcon: SvgIcon.asset(sIcon: SIcon.soccer),
                  label: 'soccer',
                ),
                Menu(
                  page: SoccerPage(label : 'baseball'),
                  svgIcon: SvgIcon.asset(sIcon: SIcon.baseball),
                  label: 'baseball',
                ),
                Menu(
                  page: SoccerPage(label : 'badminton'),
                  svgIcon: SvgIcon.asset(sIcon: SIcon.badminton),
                  label: 'badminton',
                ),
              ],
            ),
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Menu(
                  page: SoccerPage(label : 'tennis'),
                  svgIcon: SvgIcon.asset(sIcon: SIcon.tennis),
                  label: 'tennis',
                ),
                Menu(
                  page: SoccerPage(label : 'basketball'),
                  svgIcon: SvgIcon.asset(sIcon: SIcon.basketball),
                  label: 'basketball',
                ),
                Menu(
                  page: SoccerPage(label : 'running'),
                  svgIcon: SvgIcon.asset(sIcon: SIcon.trainers),
                  label: 'running',
                ),
              ],
            ),
          ],
        ),
        // child: Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceAround,
        //   children: [
        //     Menu(
        //       page: SoccerPage(label : 'soccer'),
        //       assetSvg: 'assets/icons/soccer.svg',
        //       label: 'soccer',
        //     ),
        //     Menu(
        //       page: SoccerPage(label : 'baseball'),
        //       assetSvg: 'assets/icons/baseball.svg',
        //       label: 'baseball',
        //     ),
        //     Menu(
        //       page: SoccerPage(label : 'tennis'),
        //       assetSvg: 'assets/icons/tennis.svg',
        //       label: 'tennis',
        //     ),
        //     Menu(
        //       page: SoccerPage(label : 'badminton'),
        //       assetSvg: 'assets/icons/badminton.svg',
        //       label: 'badminton',
        //     ),
        //     Menu(
        //       page: SoccerPage(label : 'basketball'),
        //       assetSvg: 'assets/icons/basketball.svg',
        //       label: 'basketball',
        //     ),
        //   ],
        // ),
      ),
    );
  }
}


class Menu extends StatelessWidget {

  final Widget page;
  final SvgIcon svgIcon;
  final String label;

  const Menu({super.key, required this.page, required this.svgIcon, required this.label});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        NavigatorHelper.push(context, page);
      },
      child: SizedBox(
        width: 100,
        child: Column(
          children: [
            svgIcon,
            const SizedBox(height: 8,),
            Text('sportTitle',
              style: TextStyle(
                fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w500,
                letterSpacing: 1,
              ),
            ).tr(gender: label),
          ],
        ),
      ),
    );
  }
}




class InfinityBanner extends StatefulWidget {
  const InfinityBanner({super.key,});

  @override
  State<InfinityBanner> createState() => _InfinityBannerState();
}

class _InfinityBannerState extends State<InfinityBanner> {
  final List<BannerCard> banners = [
    BannerCard(
      color: const Color(0xFF1D4C92),
      subtitle: '전 현직 직접 추천',
      boldTitle: '"높은 연봉',
      title: '연봉으로 보상받아요”',
      image: SvgIcon.assetBytes(sIcon: SIcon.banner1),
    ),
    BannerCard(
      color: const Color(0xFF6663E8),
      subtitle: '어쩌구저쩌구소제목',
      boldTitle: '"강조글임',
      title: '나머지 제목내용임”',
      image: SvgIcon.assetBytes(sIcon: SIcon.banner2),
      top: 0,
    ),
    BannerCard(
      color: const Color(0xFF221E26),
      subtitle: '어쩌구저쩌구소제목',
      boldTitle: '"강조글임',
      title: '나머지 제목내용임”',
      image: SvgIcon.assetBytes(sIcon: SIcon.banner1,
        style: SvgIconStyle(
          width: 100,
        )
      ),
      top: 15,
      right: 20,
    ),
  ];

  int currentBannerPage = 1;

  void onBannerChanged(int index) {
    setState(() => currentBannerPage = index);
  }

  @override
  Widget build(BuildContext context) {

    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 20),
        clipBehavior: Clip.hardEdge, // overflow hidden
        height: 120,
        decoration: BoxDecoration(),
        child: Stack(
          children: [
            Container(
              margin: const EdgeInsets.all(0),
              child: CarouselSlider(
                options: CarouselOptions(
                  aspectRatio: 16 / 9, // 슬라이드의 가로세로 비율 조정
                  viewportFraction: 0.88, // 각 슬라이드의 크기 조정 (0.8 = 80%)
                  height: double.infinity,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 7),
                  scrollDirection: Axis.horizontal,
                  onPageChanged: (index, reason) {
                    onBannerChanged(index + 1);
                  },
                  enlargeCenterPage: true,
                  enlargeFactor: 0.2
                ),
                items: banners.toList(),
              ),
            ),
            Positioned(
              right: 45,
              bottom: 10,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color: Colors.black.withOpacity(0.3)),
                child: Text('$currentBannerPage/${banners.length}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, letterSpacing: 3),),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BannerCard extends StatelessWidget {

  final int margin = 15;
  final double subTitleSize = 13;
  final double titleSize = 17;
  final double introSize = 13;

  final Color color;
  final String boldTitle;
  final String title;
  final String subtitle;
  final SvgIcon image;
  double? top;
  double? right;

  BannerCard({
    super.key,
    required this.color,
    required this.boldTitle,
    required this.title,
    required this.subtitle,
    required this.image,
    this.top,
    this.right
  });


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 20),
      // width: min(screenSize - (2 * margin) - 30, 470),
      height: double.infinity,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: color),
      child: Stack(
        children: [
          Positioned(
              top: top ?? 10,
              right: right ?? 10,
              child: image
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(subtitle,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: subTitleSize,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                      height: 1.5
                    ),
                  ),
                  Row(
                    children: [
                      Text(boldTitle,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: titleSize,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(title,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: titleSize,
                        ),
                      )
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('바로가기',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontWeight: FontWeight.w700,
                      fontSize: introSize
                    ),
                  ),
                  const SizedBox(width: 5,),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.white.withOpacity(0.7),
                    size: 13,
                  ),
                ],
              )
            ],
          ),

        ]
      ),
    );
  }
}


