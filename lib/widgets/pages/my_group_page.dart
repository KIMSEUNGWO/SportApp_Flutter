import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_sport/api/group/club_service.dart';
import 'package:flutter_sport/models/alert.dart';
import 'package:flutter_sport/models/club/club_data.dart';
import 'package:flutter_sport/notifiers/login_notifier.dart';
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
                CustomSliverAppBar(),
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
                    separatorBuilder: (context, index) => SizedBox(height: 13,),
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
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Color(0xFFFBFBFB),
                                boxShadow: [
                                  BoxShadow(color: Color(0xFFF1F1F5), offset: Offset(5, 5), blurRadius: 6)
                                ]
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
                                              fontSize: 17,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          SizedBox(height: 5,),
                                          Row(
                                            children: [
                                              Text('sportTitle').tr(gender: club.sport!.lang),
                                              Text(' · '),
                                              Text(club.region!.getLocaleName(EasyLocalization.of(context)!.locale)),
                                              Text(' · '),
                                              Icon(Icons.people_alt, size: 17, color: Color(0xFF707072),),
                                              Text('person').tr(args: [club.personCount.toString()]),
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
                                          color: Color(0xFFE4E4E4),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Center(child: SvgPicture.asset('assets/icons/emptyGroupImage.svg', width: 35, height: 35, color: Color(0xFF878181),))
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
                  Navigator.push(context, MaterialPageRoute(builder: (context) => CreateGroupWidget(),
                    fullscreenDialog: true,
                  ));
                },
                child: Container(
                  width: 65, height: 65,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Color(0xFFE9F1FA),
                  ),
                  child: Icon(Icons.add, size: 40,),
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

  @override
  bool get wantKeepAlive => false;
}

