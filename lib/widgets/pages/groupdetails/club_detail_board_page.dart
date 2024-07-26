import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_sport/common/navigator_helper.dart';

import 'package:flutter_sport/models/board/board_type.dart';
import 'package:flutter_sport/models/club/authority.dart';
import 'package:flutter_sport/models/club/club_data.dart';
import 'package:flutter_sport/widgets/pages/board/board_page.dart';
import 'package:flutter_sport/widgets/pages/board/create_board_page.dart';

class ClubDetailBoardWidget extends StatefulWidget {

  final ClubDetail club;
  final Authority? authority;

  const ClubDetailBoardWidget({super.key, required this.club, this.authority});

  @override
  State<ClubDetailBoardWidget> createState() => _ClubDetailBoardWidgetState();
}


class _ClubDetailBoardWidgetState extends State<ClubDetailBoardWidget> with AutomaticKeepAliveClientMixin{

  final List<GlobalKey<BoardPageWidgetState>> _boardGlobalKeys = [];
  final List<BoardType> _boardMenus = BoardType.values;
  final PageController _pageController = PageController();

  listReload() {
    _boardGlobalKeys[_pageController.page!.round()].currentState?.refresh();
  }
  onChangePage(int index) {
    _pageController.jumpToPage(index);
    // _pageController.animateToPage(
    //   index,
    //   duration: const Duration(milliseconds: 200),
    //   curve: Curves.easeInOut
    // );
  }
  onChangeType(BoardType boardType) {
    for (var i = 0; i < _boardMenus.length; ++i) {
      BoardType type = _boardMenus[i];
      if (type == boardType) {
        onChangePage(i);
        return;
      }
    }
    return;
  }

  @override
  void initState() {
    super.initState();

    // 전체, 공지사항, ... 메뉴별 글로벌키 생성
    for (int i = 0; i< _boardMenus.length; i++) {
      _boardGlobalKeys.add(GlobalKey<BoardPageWidgetState>());
    }
  }
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Stack(
      children: [
        PageView.builder(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _boardMenus.length,
          itemBuilder: (context, index) {
            return BoardPageWidget(key: _boardGlobalKeys[index], clubId: widget.club.id, boardMenus : _boardMenus, index: index, onChange: onChangeType, authority: widget.authority);
          },
        ),
        if (widget.club.authority != null)
          Positioned(
          right: 20,
          bottom: 70,
          child: GestureDetector(
            onTap: () {
              NavigatorHelper.push(context, CreateBoardWidget(clubId: widget.club.id, authority: widget.club.authority, reload: listReload),
                fullscreenDialog: true
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              child: Row(
                children: [
                  const Icon(Icons.add,
                    size: 30,
                    color: Colors.white,
                  ),
                  SizedBox(width: 8,),
                  Text('글쓰기',
                    style: TextStyle(
                      fontSize: Theme.of(context).textTheme.displayMedium!.fontSize,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ]
    );
  }

  @override
  bool get wantKeepAlive => true;
}



