
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sport/api/api_result.dart';
import 'package:flutter_sport/api/board/board_service.dart';
import 'package:flutter_sport/models/board/board.dart';
import 'package:flutter_sport/models/board/board_type.dart';
import 'package:flutter_sport/models/club/authority.dart';
import 'package:flutter_sport/widgets/pages/board/board_page.dart';

class BoardListWidget extends StatefulWidget {

  final BoardType boardType;
  final int clubId;
  final Authority? authority;

  const BoardListWidget({super.key, required this.boardType, required this.clubId, this.authority});

  @override
  State<BoardListWidget> createState() => BoardListWidgetState();
}

class BoardListWidgetState extends State<BoardListWidget> with AutomaticKeepAliveClientMixin {

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

  fetchRefresh() async {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      _setInit();
      await _fetchBoards();
    });
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
      return const SliverFillRemaining(
        child: Center(
          child: CupertinoActivityIndicator(),
        ),
      );
    }
    if (_boards.isEmpty) {
      return SliverFillRemaining(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.dashboard_customize_rounded,
                size: 40,
                color: Theme.of(context).colorScheme.surfaceVariant,
              ),
              SizedBox(height: 10,),
              Text('등록된 게시물이 없습니다.',
                style: TextStyle(
                    color: Theme.of(context).colorScheme.surfaceVariant,
                    fontWeight: FontWeight.w500,
                    fontSize: 16
                ),
              ),
            ],
          ),
        ),
      );
    }
    return SliverList.separated(
      separatorBuilder: (context, index) =>
          Container(
            margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
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
        return BoardWidget(
            clubId: widget.clubId,
            board: _boards[index],
            authority: widget.authority,
            boardListReload: fetchRefresh
        );
      },

    );

  }

  @override
  bool get wantKeepAlive => true;

}
