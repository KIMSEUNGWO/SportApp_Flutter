import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_sport/api/group/club_service.dart';
import 'package:flutter_sport/models/club/club_data.dart';
import 'package:flutter_sport/widgets/pages/common/common_sliver_appbar.dart';
import 'package:flutter_sport/widgets/pages/create_group_page.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sport/widgets/pages/groupdetails/group_detail_page.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';

class MyGroupPage extends ConsumerStatefulWidget {

  const MyGroupPage({super.key});

  @override
  ConsumerState<MyGroupPage> createState() => _MyGroupPageState();
}

class _MyGroupPageState extends ConsumerState<MyGroupPage> with AutomaticKeepAliveClientMixin {

  late List<ClubSimp> myClubs;
  bool isLoading = true;

  readMyClubs() async {
    loading(true);
    myClubs = await ClubService.getMyClubs();
    loading(false);
  }
  loading(bool data) {
    setState(() {
      isLoading = data;
    });
  }
  @override
  void initState() {
    readMyClubs();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (!isLoading) {
      return Stack(
          children: [
            CustomScrollView(
              slivers: [
                const CustomSliverAppBar(),
                CupertinoSliverRefreshControl(
                  refreshTriggerPullDistance: 100.0,
                  refreshIndicatorExtent: 50.0,
                  onRefresh: () async {
                    await Future.delayed(const Duration(seconds: 1));
                    readMyClubs();
                  },
                ),
                SliverToBoxAdapter(
                  child: Container(
                    height: 120,
                    margin: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color(0xFFDCD7D7)
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Text('내 모임',
                      style: TextStyle(
                        fontSize: Theme.of(context).textTheme.displayLarge!.fontSize,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.primary
                      ),
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverList.separated(
                    separatorBuilder: (context, index) => const SizedBox(height: 13,),
                    itemCount: myClubs.length,
                    itemBuilder: (context, index) {
                      ClubSimp club = myClubs[index];
                      if (club.sport != null && club.region != null) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) {
                              return GroupDetailWidget(id: club.id);
                            },));
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              // color: Theme.of(context).cardColor,
                              color: Theme.of(context).colorScheme.tertiaryContainer,

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
                                          Text(club.title,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              // fontSize: 17,
                                              fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
                                              color: Theme.of(context).colorScheme.primary,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          const SizedBox(height: 5,),
                                          Row(
                                            children: [
                                              Text('sportTitle',
                                                style: detailStyle(context),
                                              ).tr(gender: club.sport!.lang),
                                              Text(' · ',
                                                style: detailStyle(context),
                                              ),
                                              Text(club.region!.getLocaleName(EasyLocalization.of(context)!.locale),
                                                style: detailStyle(context),
                                              ),
                                              Text(' · ',
                                                style: detailStyle(context),
                                              ),
                                              Icon(Icons.people_alt,
                                                size: 17,
                                                color: Color(0xFF707072),
                                              ),
                                              Text('person',
                                                style: detailStyle(context),
                                              ).tr(args: [club.personCount.toString()]),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                    Container(
                                        width: 65, height: 65,
                                        margin: EdgeInsets.only(left: 15),
                                        clipBehavior: Clip.hardEdge,
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).colorScheme.surface,
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: club.thumbnail ??
                                          Center(
                                            child: SvgPicture.asset('assets/icons/emptyGroupImage.svg',
                                              width: 35, height: 35, color: const Color(0xFF878181),
                                            ),
                                          )
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      } else {
                        return null;
                      }
                    },
                  ),
                )
              ],
            ),
            Positioned(
              right: 20,
              bottom: 20,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => CreateGroupWidget(clubReload: readMyClubs),
                    fullscreenDialog: true,
                  ));
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.add,
                        size: 30,
                        color: Colors.white,
                      ),
                      SizedBox(width: 8,),
                      Text('그룹 생성',
                        style: TextStyle(
                          fontSize: Theme.of(context).textTheme.displayMedium!.fontSize,
                          fontWeight: FontWeight.w600,
                          color: Colors.white
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ]
      );
    } else {
      return const Center(
        child: CupertinoActivityIndicator(radius: 15,),
      );
    }

  }

  TextStyle detailStyle(BuildContext context) {
    return TextStyle(
      color: Theme.of(context).colorScheme.secondary,
      fontSize: Theme.of(context).textTheme.displaySmall!.fontSize,
      fontWeight: FontWeight.w400
    );
  }

  @override
  bool get wantKeepAlive => false;
}

