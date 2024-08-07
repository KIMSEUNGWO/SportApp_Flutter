

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_sport/api/api_result.dart';
import 'package:flutter_sport/api/board/board_service.dart';
import 'package:flutter_sport/api/comment/comment_service.dart';
import 'package:flutter_sport/api/result_code.dart';
import 'package:flutter_sport/common/alert.dart';
import 'package:flutter_sport/common/dateformat.dart';
import 'package:flutter_sport/common/navigator_helper.dart';
import 'package:flutter_sport/models/board/board_detail.dart';
import 'package:flutter_sport/models/club/authority.dart';
import 'package:flutter_sport/models/comment/comment.dart';
import 'package:flutter_sport/models/comment/comment_collection.dart';
import 'package:flutter_sport/models/common/user_profile.dart';
import 'package:flutter_sport/notifiers/login_notifier.dart';
import 'package:flutter_sport/widgets/pages/board/edit_board_page.dart';
import 'package:flutter_sport/widgets/pages/comment/comment_page.dart';
import 'package:flutter_sport/widgets/pages/common/image_detail_view.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class BoardDetailWidget extends ConsumerStatefulWidget {

  final int clubId;
  final int boardId;
  // TODO 여기에서 Authority가 null일 수가 있나? 확인하고 게시글 수정, 삭제 로직 다시 수정하자
  final Authority? authority;
  final Function() boardListReload;

  const BoardDetailWidget({super.key, required this.boardId, required this.clubId, this.authority, required this.boardListReload});

  @override
  ConsumerState<BoardDetailWidget> createState() => _BoardDetailWidgetState();
}

class _BoardDetailWidgetState extends ConsumerState<BoardDetailWidget> {

  final GlobalKey<_CommentPageWidgetState> _globalKey = GlobalKey<_CommentPageWidgetState>();
  late TextEditingController _commentController;
  final FocusNode _focusNode = FocusNode();
  Comment? _reply;

  late BoardDetail boardDetail;
  bool boardLoading = true;

  setBoardLoading(bool data) {
    setState(() {
      boardLoading = data;
    });
  }

  fetchBoardDetail() async {
    if (!boardLoading) return;
    setBoardLoading(true);

    ResponseResult result = await BoardService.of(context).getBoardDetail(
      clubId: widget.clubId,
      boardId: widget.boardId,
    );
    if (result.resultCode == ResultCode.OK) {
      boardDetail = BoardDetail.fromJson(result.data);

      setBoardLoading(false);
    }
  }

  _boardReload() async {
    setBoardLoading(true);
    await fetchBoardDetail();
  }

  sendComment(String text) async {
    _commentController.text = '';

    final result = await CommentService.of(context).sendComment(clubId: widget.clubId, boardId: widget.boardId, parentId: _reply?.commentId, comment: text);

    if (result.resultCode == ResultCode.OK) {
      _initFocus();
      await _globalKey.currentState?._fetchPageable(reload: true);
    }
    setState(() {
      _reply = null;
    });
  }

  setReply(Comment? comment) {
    setState(() {
      _reply = comment;
    });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _handleContainerTap();
    });
  }

  _handleContainerTap() {
    if (!_focusNode.hasFocus) {
      FocusScope.of(context).requestFocus(_focusNode);
    }
  }

  tryDelete() {
    Alert.confirmMessageTemplate(
      context: context,
      onPressedText: '삭제',
      onPressed: () {
        deleteBoard();
      },
      message: '댓글을 삭제하면 대댓글도 함께 삭제됩니다.\n삭제하시겠습니까?',
    );
  }

  deleteBoard() async {
    ResponseResult response = await BoardService.of(context).deleteBoard(

      clubId: widget.clubId,
      boardId: boardDetail.boardId,
    );

    if (response.resultCode == ResultCode.OK) {
      Navigator.pop(context);
      widget.boardListReload();
      Alert.message(context: context, text: Text('게시글을 삭제했습니다.'));
    }
  }

  _initFocus() {
    FocusManager.instance.primaryFocus?.unfocus();
    _commentController.text = '';

  }


  @override
  void initState() {
    _commentController = TextEditingController();
    fetchBoardDetail();
    super.initState();
  }

  @override
  void dispose() {
    _commentController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.only(bottom: keyboardHeight),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.background,
          scrolledUnderElevation: 0,
          actions: [
            GestureDetector(
              onTap: () {
                showBottomActionSheet(context,
                  boardDetail: boardDetail,
                  authority: widget.authority,
                  userId : ref.read(loginProvider.notifier).getId()
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Icon(Icons.more_horiz_outlined,
                  size: 30,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
        body: (boardLoading)
          ? const Center(child: CupertinoActivityIndicator(),)
          : GestureDetector(
              onTap: () {
                _initFocus();
              },
              child: CustomScrollView(
                slivers: [
                const SliverPadding(padding: EdgeInsets.symmetric(vertical: 15)),

                // BoardType
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverToBoxAdapter(
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Theme.of(context).colorScheme.secondaryContainer,
                          ),
                          child: Text('groupBoardMenus'.tr(gender: boardDetail.boardType.lang),
                            style: TextStyle(
                                fontSize: Theme.of(context).textTheme.displaySmall!.fontSize,
                                color: Theme.of(context).colorScheme.secondary,
                                fontWeight: FontWeight.w600
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SliverPadding(padding: EdgeInsets.symmetric(vertical: 10)),

                // User
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverToBoxAdapter(
                    child: Row(
                      children: [
                        userProfile(context, diameter: 40, image: boardDetail.user.thumbnailUser),
                        const SizedBox(width: 10,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(boardDetail.user.nickname,
                              style: TextStyle(
                                fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
                                fontWeight: FontWeight.w600
                              ),
                            ),
                            Row(
                              children: [
                                Text(DateTimeFormatter.formatDate(boardDetail.createDate),
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.tertiary,
                                    fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
                                    fontWeight: FontWeight.w500
                                  ),
                                ),
                                if (boardDetail.isUpdate)
                                  Text(' · (수정됨)',
                                    style: TextStyle(
                                      color: Theme.of(context).colorScheme.tertiary,
                                      fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
                                      fontWeight: FontWeight.w500
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                const SliverPadding(padding: EdgeInsets.symmetric(vertical: 10)),

                // Board
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(boardDetail.title,
                          style: TextStyle(
                              fontSize: Theme.of(context).textTheme.displayLarge!.fontSize,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).colorScheme.primary,
                              overflow: TextOverflow.ellipsis
                          ),
                        ),
                        const SizedBox(height: 10,),
                        Text(boardDetail.content,
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: Theme.of(context).textTheme.displayMedium!.fontSize
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SliverPadding(padding: EdgeInsets.symmetric(vertical: 20)),

                // BoardImage
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverList.builder(
                    itemCount: boardDetail.images.length,
                    itemBuilder: (context, index) {
                      BoardImage boardImage = boardDetail.images[index];
                      return GestureDetector(
                        onTap: () {
                          NavigatorHelper.push(context, ImageDetailView(image: boardImage.image),
                            fullscreenDialog: true
                          );
                        },
                        child: Container(
                          clipBehavior: Clip.hardEdge,
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                  color: Theme.of(context).colorScheme.outline
                              )
                          ),
                          child: boardImage.image,
                        ),
                      );
                    },
                  ),
                ),

                // 구분선
                SliverToBoxAdapter(
                  child: Container(
                    height: 7,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                ),

                CommentPageWidget(
                  key: _globalKey,
                  clubId: widget.clubId,
                  boardDetail: boardDetail,
                  handleTap: _handleContainerTap,
                  setReply: setReply,
                  authority: widget.authority,
                ),

                SliverToBoxAdapter(
                  child: Container(
                    height: 7,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                ),


            ],
          ),

          ),

        bottomNavigationBar: SafeArea(
          bottom: keyboardHeight <= 50,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_reply != null)
                Container(
                  margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      userProfile(context, diameter: 30, image: boardDetail.user.thumbnailUser),
                      const SizedBox(width: 25,),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(_reply!.user.nickname,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.w500,
                                fontSize: Theme.of(context).textTheme.bodySmall!.fontSize
                              ),
                            ),
                            Text(_reply!.content,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.w500,
                                fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
                                overflow: TextOverflow.ellipsis
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 15,),
                      GestureDetector(
                        onTap: () {
                          setReply(null);
                        },
                        child: Icon(Icons.close,
                          size: 20,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      )
                    ],
                  ),
                ),
              Container(
                height: 50,
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Row(
                  children: [
                    Icon(Icons.image_outlined, size: 30, color: Theme.of(context).colorScheme.secondary,),
                    const SizedBox(width: 15,),
                    Expanded(
                      child: TextField(
                        onSubmitted: sendComment,
                        focusNode: _focusNode,
                        controller: _commentController,
                        maxLines: null,
                        decoration: InputDecoration(
                          hintText: '댓글을 적어주세요.',
                          hintStyle: TextStyle(
                            fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(100),
                            borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.outline
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(100),
                            borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.outline,
                                width: 2
                            ),
                          ),
                          filled: true,
                          fillColor: Theme.of(context).colorScheme.outline,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                        ),
                      ),
                    ),
                    const SizedBox(width: 15,),
                    GestureDetector(
                      onTap: () {
                        sendComment(_commentController.text);
                      },
                      child: Icon(Icons.send,
                        size: 30,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showBottomActionSheet(BuildContext context, {required BoardDetail boardDetail, required int? userId, required Authority? authority}) {

    bool hasEditAuthority = (boardDetail.user.userId == userId);
    bool hasDeleteAuthority = hasEditAuthority || (authority != null && !authority.isUser());

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
              child: const Text('게시글 신고하기',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            if (hasEditAuthority)
              CupertinoActionSheetAction(
                onPressed: () {
                  Navigator.pop(context);
                  NavigatorHelper.push(context, EditBoardWidget(clubId: widget.clubId, boardDetail: boardDetail, authority: widget.authority!, reload: _boardReload),
                    fullscreenDialog: true
                  );
                },
                child: Text('게시글 수정',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

            if (hasDeleteAuthority)
              CupertinoActionSheetAction(
                onPressed: () {
                  Navigator.pop(context);
                  tryDelete();
                },
                child: Text('게시글 삭제',
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


class CommentPageWidget extends StatefulWidget {
  const CommentPageWidget({super.key, required this.boardDetail, required this.clubId, required this.handleTap, required this.setReply, this.authority,});

  final BoardDetail boardDetail;
  final int clubId;
  final Authority? authority;

  final Function() handleTap;
  final Function(Comment) setReply;


  @override
  State<CommentPageWidget> createState() => _CommentPageWidgetState();
}

class _CommentPageWidgetState extends State<CommentPageWidget> {
  late CommentCollection comments;
  final int _size = 10;
  bool _hasMore = true;
  bool _loading = false;
  bool fetchDisabled = false;

  setCommentsLoading(bool data) {
    setState(() {
      _loading = data;
    });
  }
  setData(List<Comment> fetchList) {
    comments.addAll(fetchList);
    setState(() {
      _loading = false;
      _hasMore = fetchList.length == _size;
    });
  }

  _fetchInitComments() async {
      if (_loading) return;
      setCommentsLoading(true);
      _fetchPageable(reload: false);
      setCommentsLoading(false);
  }

  _fetchPageable({required bool reload}) async {
    ResponseResult result = await CommentService.of(context) .getComments(
        clubId: widget.clubId,
        boardId: widget.boardDetail.boardId,
        start: comments.size(),
        size: _size,
        reload: reload
    );
    if (result.resultCode == ResultCode.OK) {
      comments.totalCount = result.data['totalCount'];
      List<Comment> list = [];
      for (var comment in result.data['comments']) {
        list.add(Comment.fromJson(comment));
      }
      setData(list);
    }
  }

  reload({required bool reload}) async {
    if (fetchDisabled) return;
    setState(() {
      fetchDisabled = true;
    });
    comments.clear();
    await _fetchPageable(reload: reload);
    await Future.delayed(const Duration(seconds: 5));
    setState(() {
      fetchDisabled = false;
    });
  }


  @override
  void initState() {
    comments = CommentCollection();
    super.initState();
    _fetchInitComments();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const SliverToBoxAdapter(child: Center(child: CupertinoActivityIndicator(),),);

    final List<Comment> keys = comments.keys();
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      sliver: SliverMainAxisGroup(
        slivers: [
          SliverToBoxAdapter(
            child: Row(
              children: [
                Text('댓글 ${comments.totalCount}',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 10,),
                GestureDetector(
                  onTap: () {
                    reload(reload : false);
                  },
                  child: Icon(Icons.refresh_outlined,
                    size: 20,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                )
              ],
            ),
          ),
          const SliverToBoxAdapter(child: const SizedBox(height: 20,),),

          (_loading) ? const SliverToBoxAdapter(child: Center(child: CupertinoActivityIndicator(),),)
            : (keys.isEmpty)
              ? SliverToBoxAdapter(
                child: SizedBox(
                  height: 150,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.list_rounded,
                          size: 50, color: Theme.of(context).colorScheme.surfaceVariant,
                        ),
                        Text('댓글을 달아주세요',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.surfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : SliverList.builder(
                itemCount: keys.length + (_hasMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (keys.isNotEmpty && index == keys.length) {
                    _fetchPageable(reload: false);
                    return const Center(child: CupertinoActivityIndicator(),);
                  }
                  Comment comment = keys[index];
                  List<Comment> reply = comments.get(comment);
                  return CommentWidget(
                    comment: comment,
                    replyList: reply,
                    handleTap: widget.handleTap,
                    setReply: widget.setReply,
                    authority: widget.authority,
                    clubId: widget.clubId,
                    boardDetail: widget.boardDetail,
                    reload: reload,
                  );
                },
            )
        ],
      ),
    );
  }

}



