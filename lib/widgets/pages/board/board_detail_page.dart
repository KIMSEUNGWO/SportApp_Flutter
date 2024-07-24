

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_sport/api/api_result.dart';
import 'package:flutter_sport/api/board/board_service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_sport/api/comment/comment_service.dart';
import 'package:flutter_sport/models/board/board_detail.dart';
import 'package:flutter_sport/models/comment/comment.dart';
import 'package:flutter_sport/models/comment/comment_collection.dart';
import 'package:flutter_sport/widgets/pages/comment/comment_page.dart';
import 'package:flutter_sport/widgets/pages/common/image_detail_view.dart';

class BoardDetailWidget extends StatefulWidget {

  final int clubId;
  final int boardId;

  const BoardDetailWidget({super.key, required this.boardId, required this.clubId});

  @override
  State<BoardDetailWidget> createState() => _BoardDetailWidgetState();
}

class _BoardDetailWidgetState extends State<BoardDetailWidget> {

  final GlobalKey<_CommentPageWidgetState> _globalKey = GlobalKey<_CommentPageWidgetState>();
  late TextEditingController _commentController;
  final FocusNode _focusNode = FocusNode();
  bool _isVisible = false;
  Comment? _reply;

  late BoardDetail boardDetail;
  bool boardLoading = true;

  setBoardLoading(bool data) {
    setState(() {
      boardLoading = data;
    });
  }

  fetchImage() async {
    if (!boardLoading) return;
    setBoardLoading(true);

    ResponseResult result = await BoardService.getBoardDetail(clubId: widget.clubId, boardId: widget.boardId);
    if (result.resultCode == ResultCode.OK) {
      boardDetail = BoardDetail.fromJson(result.data);

      setBoardLoading(false);
    }
  }

  sendComment(String text) async {
    _commentController.text = '';

    final result = await CommentService.sendComment(clubId: widget.clubId, boardId: widget.boardId, parentId: _reply?.commentId, comment: text);

    if (result.resultCode == ResultCode.OK) {
      _initFocus();
      await _globalKey.currentState?._fetchPageable();
    }
  }

  setReply(Comment? comment) {
    setState(() {
      _reply = comment;
    });
  }

  _handleContainerTap() {
    if (!_focusNode.hasFocus) {
      FocusScope.of(context).requestFocus(_focusNode);
    }
  }

  _initFocus() {
    FocusManager.instance.primaryFocus?.unfocus();
    _commentController.text = '';
    setState(() {
      _isVisible = false;
      _reply = null;
    });
  }

  @override
  void initState() {
    _commentController = TextEditingController();
    fetchImage();
    _focusNode.addListener(() {
      setState(() {
        _isVisible = _focusNode.hasFocus;
      });
    });
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
              onTap: () => showBottomActionSheet(context),
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
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Theme.of(context).colorScheme.secondaryContainer,
                          ),
                          child: Text('groupBoardMenus'.tr(gender: boardDetail.boardType.lang),
                            style: TextStyle(
                                fontSize: Theme.of(context).textTheme.bodySmall!.fontSize,
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
                        Container(
                            width: 40, height: 40,
                            margin: const EdgeInsets.only(right: 10),
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surface,
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: boardDetail.thumbnailUser ??
                                const Center(
                                    child: Icon(Icons.person, size: 20, color: const Color(0xFF878181),)
                                )
                        ),
                        Text(boardDetail.nickname,
                          style: TextStyle(
                              fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
                              fontWeight: FontWeight.w600
                          ),
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
                          Navigator.of(context).push(MaterialPageRoute(
                            fullscreenDialog: true,
                            builder: (context) {
                              return ImageDetailView(image: boardImage.image);
                            },
                          ));
                        },
                        child: Container(
                          clipBehavior: Clip.hardEdge,
                          margin: EdgeInsets.only(bottom: 10),
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

                CommentPageWidget(key: _globalKey, clubId: widget.clubId,boardDetail: boardDetail, handleTap: _handleContainerTap, setReply: setReply),

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

        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Visibility(
              visible: !_isVisible,
              child: SafeArea(
                child: Container(
                  height: 50,
                  margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Row(
                    children: [
                      Icon(Icons.image_outlined, size: 30, color: Theme.of(context).colorScheme.secondary,),
                      const SizedBox(width: 10,),
                      // Icon(Icons.location_on_outlined, size: 30, color: Theme.of(context).colorScheme.secondary,),
                      // const SizedBox(width: 15,),
                      Expanded(
                        child: GestureDetector(
                          onTap: _handleContainerTap,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: Theme.of(context).colorScheme.outline
                            ),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text('댓글을 입력해주세요.',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.tertiary,
                                  fontWeight: FontWeight.w500,

                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )

              ),
            ),
            if (_reply != null)
              Container(
                margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        width: 30, height: 30,
                        margin: const EdgeInsets.only(right: 10),
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: boardDetail.thumbnailUser ??
                            const Center(
                                child: Icon(Icons.person, size: 20, color: const Color(0xFF878181),)
                            )
                    ),
                    const SizedBox(width: 15,),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_reply!.nickname,
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
            AnimatedOpacity(
              opacity: _isVisible ? 1 : 0,
              duration: const Duration(milliseconds: 500),
              child: Container(
                height: _isVisible ? 50 : 0,
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
                        decoration: InputDecoration(
                          hintText: '댓글을 적어주세요.',
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
            ),
          ],
        ),
      ),
    );
  }
}


class CommentPageWidget extends StatefulWidget {
  const CommentPageWidget({super.key, required this.boardDetail, required this.clubId, required this.handleTap, required this.setReply,});

  final BoardDetail boardDetail;
  final int clubId;

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

  _fetchComments() async {
      if (_loading) return;
      setCommentsLoading(true);
      _fetchPageable();
      setCommentsLoading(false);
  }

  _fetchPageable() async {
    print('_CommentPageWidgetState._fetchPageable');
    ResponseResult result = await CommentService.getComments(
        clubId: widget.clubId,
        boardId: widget.boardDetail.boardId,
        start: comments.size(),
        size: _size
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

  reload() async {
    if (fetchDisabled) return;
    setState(() {
      fetchDisabled = true;
    });
    comments.clear();
    await _fetchPageable();
    await Future.delayed(const Duration(seconds: 5));
    setState(() {
      fetchDisabled = false;
    });
  }


  @override
  void initState() {
    comments = CommentCollection();
    super.initState();
    _fetchComments();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const SliverToBoxAdapter(child: Center(child: CupertinoActivityIndicator(),),);
    
    final List<Comment> keys = comments.keys();
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      sliver: SliverToBoxAdapter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
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
                    reload();
                  },
                  child: Icon(Icons.refresh_outlined,
                    size: 20,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                )
              ],
            ),

            const SizedBox(height: 20,),

            (_loading) ? const SliverToBoxAdapter(child: Center(child: CupertinoActivityIndicator(),),)
            : (keys.isEmpty) ? const Center(
              child: Column(
                children: [
                  Icon(Icons.list_rounded,
                    size: 80, color: const Color(0xFF878181),
                  ),
                  Text('댓글을 달아주세요',
                    style: TextStyle(
                      color: const Color(0xFF878181),
                    ),
                  ),
                ],
              ),
            )
            : ListView.builder(
                itemCount: keys.length + (_hasMore ? 1 : 0),
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  if (keys.isNotEmpty && index == keys.length) {
                    _fetchPageable();
                    return const Center(child: CupertinoActivityIndicator(),);
                  }
                  Comment comment = keys[index];
                  List<Comment> reply = comments.get(comment);
                  return CommentWidget(comment: comment, replyList: reply, handleTap: widget.handleTap, setReply: widget.setReply);
                },
              ),
            // 댓글
          ],
        ),
      ),
    );
  }
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
            child: const Text('게시글 신고하기',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

            CupertinoActionSheetAction(
              onPressed: () {

              },
              child: Text('게시글 수정',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          CupertinoActionSheetAction(
              onPressed: () {

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
