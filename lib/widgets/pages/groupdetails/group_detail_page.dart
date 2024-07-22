import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sport/api/group/club_service.dart';
import 'package:flutter_sport/models/club/authority.dart';
import 'package:flutter_sport/models/club/club_data.dart';
import 'package:flutter_sport/notifiers/recentlyClubNotifier.dart';
import 'package:flutter_sport/widgets/pages/groupdetails/group_dateil_board_page.dart';
import 'package:flutter_sport/widgets/pages/groupdetails/group_detail_chat_page.dart';
import 'package:flutter_sport/widgets/pages/groupdetails/group_detail_home_page.dart';
import 'package:flutter_sport/widgets/pages/groupdetails/group_detail_meeting_page.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sport/widgets/pages/groupdetails/group_edit_page.dart';

class GroupDetailWidget extends ConsumerStatefulWidget {

  final int id;

  const GroupDetailWidget({super.key, required this.id});

  @override
  ConsumerState<GroupDetailWidget> createState() => _GroupDetailWidgetState();
}

class _GroupDetailWidgetState extends ConsumerState<GroupDetailWidget> with SingleTickerProviderStateMixin {

  Map<Tab, Widget> tabList = {
    Tab(text: 'groupMenus'.tr(gender: 'home')) : const SizedBox(),
    Tab(text: 'groupMenus'.tr(gender: 'board')) : const SizedBox(),
    Tab(text: 'groupMenus'.tr(gender: 'group')) : const SizedBox(),
    Tab(text: 'groupMenus'.tr(gender: 'chat')) : const SizedBox()
  };
  late TabController _tabController;
  bool isLiked = false;

  late ClubDetail? club;
  bool isLoading = true;

  toggleLike() {
    setState(() {
      isLiked = !isLiked;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('테스트 중입니다.'), // 컨텐츠 표시내용
        duration: Duration(seconds: 3), // 지속시간
        behavior: SnackBarBehavior.floating, // 화면 하단
        backgroundColor: Color(0xFF414650),
        elevation: 0, // 그림자 없애기
        shape: RoundedRectangleBorder( // 모서리를 둥글게 변경
          borderRadius: BorderRadius.circular(10.0),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 25),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      ),
    );
  }


  readClub() async {
    club = await ClubService.clubData(context: context, clubId: widget.id);
    if (club == null) return;
    setState(() {
      isLoading = false;
    });
    tabList = {
      Tab(text: 'groupMenus'.tr(gender: 'home')) : GroupDetailHomeWidget(club : club!, reloadClub: readClub),
      Tab(text: 'groupMenus'.tr(gender: 'board')) : GroupDetailBoardWidget(club : club!),
      Tab(text: 'groupMenus'.tr(gender: 'group')) : GroupDetailMeetingWidget(club : club!),
      Tab(text: 'groupMenus'.tr(gender: 'chat')) : GroupDetailChatWidget(club : club!)
    };

    ClubSimp clubSimp = ClubSimp(club!.id, club!.thumbnail, club!.title, club!.intro, club!.sport, club!.region, club!.personCount, club!.createDate);
    ref.read(recentlyClubNotifier.notifier).add(clubSimp);

  }

  @override
  void initState() {
    readClub();
    super.initState();
    _tabController = TabController(
      length: tabList.length,
      vsync: this,
      initialIndex: 0
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Stack(
        children: [
          Scaffold(
            appBar: AppBar(
              actions: const [
                Padding(
                  padding: EdgeInsets.only(right: 15),
                  child: Icon(Icons.favorite,
                    size: 30,
                    color: Colors.grey,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 20),
                  child: Icon(Icons.more_horiz_outlined, size: 30, ),
                )
              ],
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(40.0),
                child: Container(
                  color: Theme.of(context).colorScheme.background,
                  child: TabBar(
                    controller: _tabController,
                    // labelColor: Colors.red,
                    labelColor: Theme.of(context).colorScheme.onPrimary,
                    // indicatorColor: Colors.red,
                    indicatorColor: Theme.of(context).colorScheme.onPrimary,
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicatorWeight: 2.5,
                    labelStyle: TextStyle(
                      fontSize: 18,
                    ),
                    tabs: tabList.keys.toList(),
                  ),
                ),
              ),
            ),
            body: TabBarView(
              controller: _tabController,
              physics: NeverScrollableScrollPhysics(),
              children: List.generate(tabList.length, (index) => SizedBox()),
            ),
            backgroundColor: Theme.of(context).colorScheme.background,
          ),
          Positioned(
            child: Center(
              child: CupertinoActivityIndicator(radius: 15,),
            ) 
          ),
        ]
      );
    }
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Theme.of(context).colorScheme.background,
        title: Text(club!.title,
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.w500,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          GestureDetector(
            onTap: () => toggleLike(),
            child: Padding(
              padding: const EdgeInsets.only(right: 15),
              child: Icon(Icons.favorite,
                size: 30,
                color: isLiked
                  ? const Color(0xFFF84D4D)
                  : Colors.grey,
              ),
            ),
          ),
          GestureDetector(
            onTap: () => showBottomActionSheet(context),
            child: Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Icon(Icons.more_horiz_outlined,
                size: 30,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          )
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(40.0),
          child: Container(
            color: Theme.of(context).colorScheme.background,
            child: TabBar(
              controller: _tabController,
              // labelColor: Colors.red,
              labelColor: Theme.of(context).colorScheme.onPrimary,
              // indicatorColor: Colors.red,
              indicatorColor: Theme.of(context).colorScheme.onPrimary,
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorWeight: 2.5,
              labelStyle: TextStyle(
                fontSize: Theme.of(context).textTheme.displayMedium!.fontSize,
                fontWeight: FontWeight.w500,
              ),
              tabs: tabList.keys.toList(),
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        physics: const NeverScrollableScrollPhysics(),
        children: tabList.values.toList(),
      ),
    );
  }

  void showBottomActionSheet(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return CupertinoActionSheet(
          actions: [
            CupertinoActionSheetAction(
              onPressed: () {
                // Chat 탭 처리
                Navigator.of(context).pop();
              },
              child: const Text('notifyGroup',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w500,
                ),
              ).tr(),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                // Chat 탭 처리
                Navigator.of(context).pop();
              },
              child: Text('shareGroup',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ).tr(),
            ),

            if (club!.authority != null && club!.authority == Authority.OWNER)
              CupertinoActionSheetAction(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return ClubEditWidget(club: club!, reload: readClub);
                },));
              },
              child: Text('방 설정 변경',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('cancel').tr(),
          ),
        );
      },
    );
  }

}
