
import 'package:flutter/material.dart';
import 'package:flutter_sport/api/api_result.dart';
import 'package:flutter_sport/api/board/board_service.dart';
import 'package:flutter_sport/api/result_code.dart';
import 'package:flutter_sport/common/navigator_helper.dart';
import 'package:flutter_sport/models/board/board.dart';
import 'package:flutter_sport/models/board/board_type.dart';
import 'package:flutter_sport/models/club/authority.dart';
import 'package:flutter_sport/widgets/pages/board/board_detail_page.dart';

class BoardNoticeWidget extends StatefulWidget {

  final int clubId;
  final Authority? authority;
  final Function() refresh;

  const BoardNoticeWidget({super.key, required this.clubId, this.authority, required this.refresh});

  @override
  State<BoardNoticeWidget> createState() => BoardNoticeWidgetState();
}

class BoardNoticeWidgetState extends State<BoardNoticeWidget> {

  late List<Board> _boards = [];
  bool _isLoading = false;

  setLoading(bool data) {
    setState(() {
      _isLoading = data;
    });
  }

  fetchBoards() async {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {

      if (_isLoading) return;
      setLoading(true);

      ResponseResult result = await BoardService.of(context).getBoards(
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
    fetchBoards();
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
          return GestureDetector(
            onTap: () {
              NavigatorHelper.push(context, BoardDetailWidget(
                  clubId: widget.clubId,
                  boardId: board.boardId,
                  authority: widget.authority,
                  boardListReload: widget.refresh
              ));
            },
            child: Flex(
              direction: Axis.horizontal,
              children: [
                Container(
                  padding: const EdgeInsets.only(right: 3, top: 5, bottom: 5,),
                  decoration: const BoxDecoration(),
                  child: Text('[공지]',
                    style: TextStyle(
                        fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
                        fontWeight: FontWeight.w600,
                        // color: Color(0xFFF35353),
                        color: Theme.of(context).colorScheme.onPrimary
                    ),
                  ),
                ),
                const SizedBox(width: 10, ),
                Expanded(
                  flex: 3,
                  child: Text(board.title,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.primary
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
