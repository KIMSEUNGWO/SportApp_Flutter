

import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_sport/common/local_storage.dart';
import 'package:flutter_sport/models/login_notifier.dart';
import 'package:flutter_sport/models/region_data.dart';
import 'package:flutter_sport/widgets/chating/oneToOneMessage_widget.dart';
import 'package:flutter_sport/widgets/lists/small_list_widget.dart';
import 'package:flutter_sport/widgets/notification/notifications_widget.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_sport/widgets/pages/login_page.dart';
import 'package:flutter_sport/widgets/pages/recently_visit_group.dart';
import 'package:flutter_sport/widgets/pages/region_settings.dart';
import 'package:flutter_sport/widgets/pages/search_page.dart';
import 'package:flutter_sport/widgets/pages/sport/soccer_page.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:vector_graphics/vector_graphics.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MainPage extends StatefulWidget {


  const MainPage({
    super.key,
  });

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with AutomaticKeepAliveClientMixin {
  final double margin = 20;

  Region region = Region.ALL;

  onChangeRegion(Region data) {
    setState(() {
      region = data;
    });
    LocalStorage.saveByRegion(data);
  }

  _initRegion() async {
    region = await LocalStorage.findByRegion();
  }

  @override
  void initState() {
    _initRegion();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return CustomScrollView(
      physics: AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      slivers: [
        SliverAppBar(
          elevation: 0,
          toolbarHeight: 50,
          floating: true,
          title: GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => RegionSettingsWidget(changeRegion : onChangeRegion),));
            },
            child: Row(
              children: [
                Text(region.getLocaleName(EasyLocalization.of(context)!.locale),
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 24,
                    color: Color(0xFF2B2828)
                  ),
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
        const InfinityBanner(),
        Menus(region : region),
        const SliverToBoxAdapter(child: SizedBox(height: 40,),),
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
                        fontSize: 19,
                        fontWeight: FontWeight.w500
                      ),
                    ).tr(),
                    GestureDetector(
                      onTap: () => Navigator.push(context, MaterialPageRoute(
                          builder: (context) => RecentlyVisitPages(),)
                      ),
                      child: Text('more',
                        style: TextStyle(
                          fontSize: 15,
                          color: Theme.of(context).colorScheme.secondary
                        ),
                      ).tr(),
                    )
                  ],
                ),
                SizedBox(height: 20,),
                Column(
                  children: [
                    SmallListWidget(
                      id: 1,
                      image: Image.asset('assets/groupImages/sample1.jpeg', fit: BoxFit.fill,),
                      title: '野球団野球団野球団野球団野球団野球団野球団野球団',
                      intro: '新人さんを待っています',
                      sportType: '야구',
                      region: '신주쿠구',
                      personCount: 3,
                    ),
                  ],
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

  final Region region;

  const Menus({super.key, required this.region});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Menu(
              page: SoccerPage(region : region, label : 'soccer'),
              assetSvg: 'assets/icons/soccer.svg',
              label: 'soccer',
            ),
            Menu(
              page: SoccerPage(region : region, label : 'baseball'),
              assetSvg: 'assets/icons/baseball.svg',
              label: 'baseball',
            ),
            Menu(
              page: SoccerPage(region : region, label : 'tennis'),
              assetSvg: 'assets/icons/tennis.svg',
              label: 'tennis',
            ),
            Menu(
              page: SoccerPage(region : region, label : 'badminton'),
              assetSvg: 'assets/icons/badminton.svg',
              label: 'badminton',
            ),
            Menu(
              page: SoccerPage(region : region, label : 'basketball'),
              assetSvg: 'assets/icons/basketball.svg',
              label: 'basketball',
            ),
          ],
        ),
      ),
    );
  }
}


class Menu extends StatelessWidget {

  final Widget page;
  final String assetSvg;
  final String label;

  const Menu({super.key, required this.page, required this.assetSvg, required this.label});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(
              builder: (context) => page,
            )
        );
      },
      child: Column(
        children: [
          SvgPicture.asset(assetSvg),
          const SizedBox(height: 6,),
          Text('sportTitle').tr(gender: label),
        ],
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
      image: SvgPicture(AssetBytesLoader('assets/banners/icon1.svg.vec'),),
    ),
    BannerCard(
      color: const Color(0xFF6663E8),
      subtitle: '어쩌구저쩌구소제목',
      boldTitle: '"강조글임',
      title: '나머지 제목내용임”',
      image: SvgPicture(AssetBytesLoader('assets/banners/icon2.svg.vec')),
      top: 0,
    ),
    BannerCard(
      color: const Color(0xFF221E26),
      subtitle: '어쩌구저쩌구소제목',
      boldTitle: '"강조글임',
      title: '나머지 제목내용임”',
      image: SvgPicture(AssetBytesLoader('assets/banners/icon3.svg.vec'), width: 100,),
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
                  // autoPlay: true,
                  // autoPlayInterval: const Duration(seconds: 10),
                  scrollDirection: Axis.horizontal,
                  onPageChanged: (index, reason) {
                    onBannerChanged(index + 1);
                  },
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
  final SvgPicture image;
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

    final double screenSize = MediaQuery.of(context).size.width;

    return Container(
      padding: const EdgeInsets.only(left: 20),
      width: min(screenSize - (2 * margin) - 30, 470),
      height: double.infinity,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: color),
      child: Stack(
        children: [
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
          Positioned(
            top: top ?? 10,
            right: right ?? 10,
            child: image
          ),
        ]
      ),
    );
  }
}


