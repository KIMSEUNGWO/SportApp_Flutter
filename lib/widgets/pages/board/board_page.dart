

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_sport/api/api_result.dart';
import 'package:flutter_sport/api/board/board_service.dart';
import 'package:flutter_sport/common/dateformat.dart';
import 'package:flutter_sport/models/board/board.dart';
import 'package:flutter_sport/models/board/board_type.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';

class BoardPageWidget extends StatelessWidget {

  final int clubId;
  final List<BoardType> boardMenus;
  final int index;
  final Function(BoardType boardType) onChange;
  final GlobalKey<_BoardListWidgetState> boardListKey = GlobalKey<_BoardListWidgetState>();

  BoardPageWidget({super.key, required this.boardMenus, required this.index, required this.onChange, required this.clubId});


  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // TODO
        CupertinoSliverRefreshControl(
          refreshTriggerPullDistance: 100.0,
          refreshIndicatorExtent: 80.0,
          onRefresh: () async {
            // 위로 새로고침
            await Future.delayed(const Duration(seconds: 1));
            await boardListKey.currentState?._fetchRefresh();
          },
        ),
        SliverToBoxAdapter(
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 15),
            padding: const EdgeInsets.symmetric(horizontal: 13),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: boardMenus
                    .map((menu) =>
                    GestureDetector(
                      onTap: () {
                        onChange(menu);
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 7),
                        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: menu == boardMenus[index]
                              ? Theme.of(context).colorScheme.primaryContainer
                              : Theme.of(context).colorScheme.secondaryContainer
                        ),
                        child: Text('groupBoardMenus',
                          style: TextStyle(
                              fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
                              fontWeight: FontWeight.w500,
                              color: menu == boardMenus[index]
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
        if (boardMenus[index] == BoardType.ALL) BoardNoticeWidget(clubId: clubId),
        BoardListWidget(key: boardListKey, clubId: clubId, boardType: boardMenus[index]),
        const SliverToBoxAdapter(child: SizedBox(height: 50,),)
      ],
    );
  }
}

class BoardNoticeWidget extends StatefulWidget {

  final int clubId;

  const BoardNoticeWidget({super.key, required this.clubId});

  @override
  State<BoardNoticeWidget> createState() => _BoardNoticeWidgetState();
}

class _BoardNoticeWidgetState extends State<BoardNoticeWidget> {

  late List<Board> _boards = [];
  bool _isLoading = false;

  setLoading(bool data) {
    setState(() {
      _isLoading = data;
    });
  }

  _fetchBoards() async {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {

      if (_isLoading) return;
      setLoading(true);

      ResponseResult result = await BoardService.getBoards(
        clubId: widget.clubId,
        boardType: BoardType.NOTICE.name,
        page: 0,
        size: 3,
      );

      if (result.resultCode == ResultCode.OK) {
        List<Board> list = [];
        for (var boardJson in result.data) {
          Board board = Board.fromJson(boardJson);
          list.add(board);
        }
        setState(() {
          _boards = list;
        });
      }
      setLoading(false);
    });
  }

  @override
  void initState() {
    _fetchBoards();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_boards.isEmpty) return const SliverToBoxAdapter();
    return SliverPadding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 30),
      sliver: SliverList.separated(
        itemCount: _boards.length,
        separatorBuilder: (context, index) {
          return const SizedBox(height: 5,);
        },
        itemBuilder: (context, index) {
          Board board = _boards[index];
          return Flex(
            direction: Axis.horizontal,
            children: [
              Container(
                padding: const EdgeInsets.only(right: 3, top: 5, bottom: 5,),
                decoration: const BoxDecoration(),
                child: Text('[공지]',
                  style: TextStyle(
                      fontSize: Theme.of(context).textTheme.displayMedium!.fontSize,
                      fontWeight: FontWeight.w600,
                      // color: Color(0xFFF35353),
                      color: Theme.of(context).colorScheme.onPrimary
                  ),
                ),
              ),
              const SizedBox(width: 10, ),
              Expanded(
                flex: 3,
                child: Text(board.content,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: Theme.of(context).textTheme.displayMedium!.fontSize,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.primary
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class BoardListWidget extends StatefulWidget {

  final BoardType boardType;
  final int clubId;

  const BoardListWidget({super.key, required this.boardType, required this.clubId});

  @override
  State<BoardListWidget> createState() => _BoardListWidgetState();
}

class _BoardListWidgetState extends State<BoardListWidget> with AutomaticKeepAliveClientMixin {

  late List<Board> _boards = [];
  int _page = 0; // 페이지 번호
  int _size = 20; // 페이지 별 개수
  bool _isLoading = false;
  bool _hasMore = true;
  bool _isDone = false;

  _setData(List<Board> boards) {
    _boards.addAll(boards);
    setState(() {
      _page++;
      _isLoading = false;
      _hasMore = boards.length == _size;
      _isDone = true;
    });
  }

  _setInit() {
    setState(() {
      _page = 0;
      _isLoading = false;
      _hasMore = true;
      _isDone = false;
      _boards = [];
    });
  }

  _fetchRefresh() async {
    _setInit();
    await _fetchBoards();
  }

  _fetchBoards() async {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {

      if (_isLoading) return;
      setLoading(true);

      ResponseResult result = await BoardService.getBoards(
        clubId: widget.clubId,
        boardType: widget.boardType == BoardType.ALL ? null : widget.boardType.name,
        page: _page,
        size: _size,
      );
      if (result.resultCode == ResultCode.OK) {
        List<Board> list = [];
        for (var boardJson in result.data) {
          Board board = Board.fromJson(boardJson);
          list.add(board);
        }
        _setData(list);
      } else {
        setLoading(false);
      }
    });
  }

  setLoading(bool data) {
    setState(() {
      _isLoading = data;
    });
  }

  @override
  void initState() {
    _fetchBoards();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (!_isDone) {
      return SliverToBoxAdapter(
        child: Center(
          child: Text('게시글을 불러오고 있습니다.'),
        ),
      );
    }
    return SliverList.separated(
      separatorBuilder: (context, index) =>
          Container(
            margin: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
            height: 1,
            decoration: BoxDecoration(
              // color: Color(0xFFE4DDDD),
                color: Theme.of(context).colorScheme.outline
            ),
          ),
      itemCount: _boards.length + (_hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (_boards.isNotEmpty && index == _boards.length) {
          _fetchBoards();
          return const Center(child: CupertinoActivityIndicator(),);
        }
        return BoardWidget(board: _boards[index]);
      },

    );

  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

}

class BoardWidget extends StatelessWidget {
  final Board board;

  const BoardWidget({super.key, required this.board});

  @override
  Widget build(BuildContext context) {
      return Container(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
        constraints: const BoxConstraints(
          minHeight: 160,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                GestureDetector(
                  onTap: () {

                  },
                  child: Row(
                    children: [
                      Container(
                          width: 25, height: 25,
                          margin: const EdgeInsets.only(right: 10),
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: board.thumbnailUser ??
                            const Center(
                                child: Icon(Icons.person, size: 20, color: const Color(0xFF878181),)
                            )
                      ),
                      Text(board.nickname,
                        style: TextStyle(
                            fontSize: Theme.of(context).textTheme.bodySmall!.fontSize
                        ),
                      )
                    ],
                  ),
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
                    Icon(Icons.favorite,
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
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
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
      );
  }


  TextStyle detailStyle(BuildContext context) {
    return TextStyle(
      fontSize: Theme.of(context).textTheme.displaySmall!.fontSize,
      color: Theme.of(context).colorScheme.tertiary,
    );
  }
}
