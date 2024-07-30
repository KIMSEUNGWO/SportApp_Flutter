

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_sport/common/alert.dart';
import 'package:flutter_sport/common/dateformat.dart';
import 'package:flutter_sport/common/navigator_helper.dart';
import 'package:flutter_sport/models/board/board.dart';
import 'package:flutter_sport/models/board/board_type.dart';
import 'package:flutter_sport/models/club/authority.dart';
import 'package:flutter_sport/models/common/user_profile.dart';
import 'package:flutter_sport/notifiers/login_notifier.dart';
import 'package:flutter_sport/widgets/lists/board_list_widget.dart';
import 'package:flutter_sport/widgets/pages/board/board_detail_page.dart';
import 'package:flutter_sport/widgets/lists/board_notice_widget.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BoardPageWidget extends StatefulWidget {

  final int clubId;
  final List<BoardType> boardMenus;
  final int index;
  final Function(BoardType boardType) onChange;
  final Authority? authority;

  const BoardPageWidget({super.key, required this.boardMenus, required this.index, required this.onChange, required this.clubId, this.authority});

  @override
  State<BoardPageWidget> createState() => BoardPageWidgetState();
}

class BoardPageWidgetState extends State<BoardPageWidget> {

  final GlobalKey<BoardListWidgetState> boardListKey = GlobalKey<BoardListWidgetState>();
  final GlobalKey<BoardNoticeWidgetState> noticeListKey = GlobalKey<BoardNoticeWidgetState>();

  refresh() async {
    boardListKey.currentState?.fetchRefresh();
    if (widget.boardMenus[widget.index] == BoardType.ALL) {
      await noticeListKey.currentState?.fetchBoards();
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        CupertinoSliverRefreshControl(
          refreshTriggerPullDistance: 100.0,
          refreshIndicatorExtent: 80.0,
          onRefresh: () async {
            // 위로 새로고침
            await Future.delayed(const Duration(seconds: 1));
            refresh();
          },
        ),
        SliverToBoxAdapter(
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 15),
            padding: const EdgeInsets.symmetric(horizontal: 13),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: widget.boardMenus
                    .map((menu) =>
                    GestureDetector(
                      onTap: () {
                        widget.onChange(menu);
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 7),
                        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: menu == widget.boardMenus[widget.index]
                              ? Theme.of(context).colorScheme.primaryContainer
                              : Theme.of(context).colorScheme.secondaryContainer
                        ),
                        child: Text('groupBoardMenus',
                          style: TextStyle(
                              fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
                              fontWeight: FontWeight.w500,
                              color: menu == widget.boardMenus[widget.index]
                                ? Colors.white
                                : Theme.of(context).colorScheme.primary

                          ),
                        ).tr(gender: menu.lang),
                      ),
                    )
                ).toList(),
              ),
            ),
          ),
        ),
        if (widget.boardMenus[widget.index] == BoardType.ALL)
          BoardNoticeWidget(
            key: noticeListKey,
            clubId: widget.clubId,
            authority: widget.authority,
            refresh: refresh
          ),
        BoardListWidget(key: boardListKey, clubId: widget.clubId, boardType: widget.boardMenus[widget.index], authority: widget.authority),
        const SliverToBoxAdapter(child: SizedBox(height: 50,),)
      ],
    );
  }
}


class BoardWidget extends ConsumerWidget {
  final Board board;
  final int clubId;
  final Authority? authority;
  final Function() boardListReload;

  const BoardWidget({super.key, required this.board, required this.clubId, this.authority, required this.boardListReload});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
      return GestureDetector(
        onTap: () {
          final hasLogin = ref.read(loginProvider.notifier).has();
          if (hasLogin) {
            NavigatorHelper.push(context, BoardDetailWidget(boardId: board.boardId, clubId: clubId, boardListReload: boardListReload, authority: authority,));
            // context.push('/club/$clubId/board/${board.boardId}',
            //   extra: {
            //     'authority' : authority,
            //     'reload' : boardListReload
            //   }
            // );
          } else {
            Alert.message(context: context, text: Text('참여한 회원만 열람할 수 있습니다.'));
          }
        },
        child: Container(
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
          constraints: const BoxConstraints(
            minHeight: 160,
          ),
          decoration: const BoxDecoration(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Row(
                    children: [
                      userProfile(context, diameter: 25, image: board.user.thumbnailUser),
                      const SizedBox(width: 10,),
                      Text(board.user.nickname,
                        style: TextStyle(
                            fontSize: Theme.of(context).textTheme.bodySmall!.fontSize
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 10,),
                  Flex(
                    direction: Axis.horizontal,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(board.title,
                              style: TextStyle(
                                  fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(context).colorScheme.primary,
                                  overflow: TextOverflow.ellipsis
                              ),
                            ),
                            const SizedBox(height: 6,),
                            Text(board.content,
                              maxLines: 2,
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.secondary,
                                  fontSize: Theme.of(context).textTheme.bodySmall!.fontSize
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (board.thumbnailBoard != null)
                        Container(
                          // width: 70, height: 70,
                          width: 112, height: 73,
                          margin: const EdgeInsets.only(left: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          clipBehavior: Clip.hardEdge,
                          child: board.thumbnailBoard,
                        ),
                    ],

                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.favorite,
                        color: Colors.grey,
                        size: 17,
                      ),
                      Text(board.likeCount.toString(),
                        style: detailStyle(context),
                      ),
                      Text(' · ',
                        style: detailStyle(context),
                      ),
                      SvgPicture.asset('assets/icons/emptyGroupImage.svg',
                        color: Colors.grey,
                        width: 20,
                      ),
                      Text(board.commentCount.toString(),
                        style: detailStyle(context),
                      ),
                      Text(' · ',
                        style: detailStyle(context),
                      ),
                      Text(DateTimeFormatter.formatDate(board.createDate),
                        style: detailStyle(context),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Theme.of(context).colorScheme.secondaryContainer,
                    ),
                    child: Text('groupBoardMenus'.tr(gender: board.boardType.lang),
                      style: TextStyle(
                          fontSize: Theme.of(context).textTheme.bodySmall!.fontSize,
                          color: Theme.of(context).colorScheme.secondary,
                          fontWeight: FontWeight.w600
                      ),
                    ),
                  ),

                ],
              ),
            ],
          ),
        ),
      );
  }


  TextStyle detailStyle(BuildContext context) {
    return TextStyle(
      fontSize: Theme.of(context).textTheme.displaySmall!.fontSize,
      color: Theme.of(context).colorScheme.tertiary,
    );
  }
}
