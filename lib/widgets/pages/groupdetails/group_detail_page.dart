import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sport/widgets/pages/groupdetails/group_dateil_board_page.dart';
import 'package:flutter_sport/widgets/pages/groupdetails/group_detail_chat_page.dart';
import 'package:flutter_sport/widgets/pages/groupdetails/group_detail_home_page.dart';
import 'package:flutter_sport/widgets/pages/groupdetails/group_detail_meeting_page.dart';


class GroupDetailWidget extends StatefulWidget {

  final int id;

  const GroupDetailWidget({super.key, required this.id});

  @override
  State<GroupDetailWidget> createState() => _GroupDetailWidgetState();
}

class _GroupDetailWidgetState extends State<GroupDetailWidget> with SingleTickerProviderStateMixin {

  final Map<Tab, Widget> tabList = {
    Tab(text: '홈') : GroupDetailHomeWidget(),
    Tab(text: '게시판') : GroupDetailBoardWidget(),
    Tab(text: '모임',) : GroupDetailMeetingWidget(),
    Tab(text: '채팅') : GroupDetailChatWidget()
  };
  late TabController _tabController;
  bool isLiked = false;

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

  @override
  void initState() {
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
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text('그룹명들어갈자리그룹명들어갈자리', overflow: TextOverflow.ellipsis,),
        actions: [
          GestureDetector(
            onTap: () => toggleLike(),
            child: Padding(
              padding: const EdgeInsets.only(right: 15),
              child: Icon(Icons.favorite,
                size: 30,
                color: isLiked
                  ? Color(0xFFF84D4D)
                  : Colors.grey,
              ),
            ),
          ),
          GestureDetector(
            onTap: () => showBottomActionSheet(context),
            child: const Padding(
              padding: EdgeInsets.only(right: 20),
              child: Icon(Icons.more_horiz_outlined, size: 30, ),
            ),
          )
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(40.0),
          child: Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.red,
              indicatorColor: Colors.red,
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
              child: Text('모임 신고하기', style: const TextStyle(color: Colors.red),),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                // Chat 탭 처리
                Navigator.of(context).pop();
              },
              child: Text('모임 공유하기'),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('취소'),
          ),
        );
      },
    );
  }

}
