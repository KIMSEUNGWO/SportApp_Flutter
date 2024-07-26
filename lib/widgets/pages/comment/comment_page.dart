
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_sport/api/api_result.dart';
import 'package:flutter_sport/api/comment/comment_service.dart';
import 'package:flutter_sport/common/alert.dart';
import 'package:flutter_sport/common/dateformat.dart';
import 'package:flutter_sport/models/club/authority.dart';
import 'package:flutter_sport/models/comment/comment.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sport/notifiers/login_notifier.dart';


class CommentWidget extends ConsumerStatefulWidget {
  CommentWidget({
    super.key,
    required this.comment,
    this.handleTap,
    this.setReply,
    required this.replyList, this.authority, required this.clubId, required this.boardId, required this.setAllVisible, required this.reload,
  });

  final int clubId;
  final int boardId;
  final Comment comment;
  final List<Comment> replyList;
  final Authority? authority;

  final Function({required bool reload}) reload;
  final Function()? handleTap;
  final Function(Comment)? setReply;
  final Function(bool data) setAllVisible;

  @override
  ConsumerState<CommentWidget> createState() => _CommentWidgetState();
}

class _CommentWidgetState extends ConsumerState<CommentWidget> {

  late TextEditingController _editingController;
  bool editing = false;

  editComment() async {

    final response = await CommentService.editComment(
      clubId: widget.clubId,
      boardId: widget.boardId,
      commentId: widget.comment.commentId,
      comment: _editingController.text
    );
    if (response.resultCode == ResultCode.OK) {
      widget.comment.content = _editingController.text;
      exitEdit();
    }

  }

  deleteComment() async {

    final response = await CommentService.deleteComment(
        clubId: widget.clubId,
        boardId: widget.boardId,
        commentId: widget.comment.commentId,
    );
    if (response.resultCode == ResultCode.OK) {
      widget.reload(reload: false);
      Alert.message(context: context, text: Text('댓글을 삭제했습니다.'));
    }
  }

  setEdit(String text) {
    _editingController.text = text;
    setState(() {
      editing = true;
    });
  }

  exitEdit() {
    _editingController.text = '';
    setState(() {
      editing = false;
    });
  }

  tryDelete() {
    Alert.confirmMessageTemplate(
        context: context,
        onPressedText: '삭제',
        onPressed: () {
          Navigator.pop(context);
          deleteComment();
        },
        message: '댓글을 삭제하면 대댓글도 함께 삭제됩니다.\n삭제하시겠습니까?',
    );
  }




  @override
  void initState() {
    _editingController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _editingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            width: 35, height: 35,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: Theme.of(context).colorScheme.surface,
            ),
            child: widget.comment.profile ??
                const Center(
                    child: Icon(Icons.person, size: 20, color: const Color(0xFF878181),)
                )
        ),
        const SizedBox(width: 15,),
        Expanded(
          child: Column (
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(widget.comment.nickname,
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.secondary,
                                  fontWeight: FontWeight.w500,
                                  fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize
                              ),
                            ),
                            const SizedBox(width: 7,),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 1),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.outline,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text('작성자',
                                style: TextStyle(
                                    color: Theme.of(context).colorScheme.tertiary,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500
                                ),
                              ),
                            )
                          ],
                        ),
                        Text(DateTimeFormatter.formatDate(widget.comment.createDate),
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.tertiary,
                              fontSize: Theme.of(context).textTheme.displaySmall!.fontSize
                          ),
                        ),
                      ],
                    ),
                    PopupMenuButton<String>(
                      icon: Icon(Icons.more_vert,
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                      offset: const Offset(-40, 0),
                      surfaceTintColor: Theme.of(context).colorScheme.background,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                      ),
                      itemBuilder: (BuildContext context) {
                        return commentPopupList(context, ref, commentUserId: widget.comment.userId);
                      },
                    ),
                    // Icon(Icons.more_horiz_outlined,
                    //   color: Theme.of(context).colorScheme.tertiary,
                    // )
                  ]
              ),
              const SizedBox(height: 10,),
              (!editing)
              ? Text(widget.comment.content,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w500,
                    fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
                    letterSpacing: 0.4
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _editingController,
                          autofocus: true,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.w500,
                            fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
                            letterSpacing: 0.4,
                          ),
                          maxLines: null,
                        ),
                      ),
                      const SizedBox(width: 20,),
                      GestureDetector(
                        onTap: () {
                          widget.setAllVisible(true);
                          exitEdit();
                        },
                        child: Text('취소',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary
                          ),
                        ),
                      ),
                      const SizedBox(width: 15,),
                      GestureDetector(
                        onTap: () {
                          widget.setAllVisible(true);
                          editComment();
                        },
                        child: Text('수정',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.primary
                          ),
                        ),
                      )
                    ],
                  ),
              ),

              const SizedBox(height: 15,),

              if (widget.comment.parentCommentId == null)
                GestureDetector(
                  onTap: () {
                    widget.handleTap!();
                    widget.setReply!(widget.comment);
                  },
                  child: Text('답글쓰기',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.tertiary,
                    fontSize: Theme.of(context).textTheme.displaySmall!.fontSize,
                    fontWeight: FontWeight.w500
                  ),
                                  ),
                ),

              const SizedBox(height: 10,),

              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: widget.replyList.length,
                itemBuilder: (context, index) {
                  Comment reply = widget.replyList[index];
                  return CommentWidget(comment: reply, replyList: [], clubId: widget.clubId, boardId: widget.boardId, reload: widget.reload, setAllVisible: widget.setAllVisible,);
                },
              ),

            ],
          ),
        ),
      ],
    );
  }

  List<PopupMenuItem<String>> commentPopupList(BuildContext context, WidgetRef ref, {required int commentUserId}) {
    int? id = ref.read(loginProvider.notifier).getId();
    List<PopupMenuItem<String>> list = [];
    list.add(
      PopupMenuItem<String>(
        child: Text('댓글 신고',
          style: TextStyle(
            color: Colors.red.shade400
          ),
        ),
        onTap: () {
          print('??');
        },
      ),
    );
    if (commentUserId == id) {
      list.add(
        PopupMenuItem<String>(
          child: Text('댓글 수정',
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary
            ),
          ),
          onTap: () {
            widget.setAllVisible(false);
            setEdit(widget.comment.content);
          },
        ),
      );
    }
    if (widget.authority == Authority.OWNER || widget.authority == Authority.MANAGER || commentUserId == id) {
      list.add(
        PopupMenuItem<String>(
          child: Text('댓글 삭제',
            style: TextStyle(
                color: Theme.of(context).colorScheme.primary
            ),
          ),
          onTap: () {
            tryDelete();
          },
        ),
      );
    }
    return list;
  }
}
