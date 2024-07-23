
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sport/common/dateformat.dart';
import 'package:flutter_sport/models/comment/comment.dart';

class CommentWidget extends StatelessWidget {
  CommentWidget({
    super.key,
    required this.comment,
    this.handleTap,
    this.setReply,
    this.parentId,
  });

  final Comment comment;
  final int? parentId;

  Function()? handleTap;
  Function(Comment)? setReply;

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
            child: comment.profile ??
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
                            Text(comment.nickname,
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
                                color: Theme.of(context).colorScheme.primaryContainer,
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
                        Text(DateTimeFormatter.formatDate(comment.createDate),
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.tertiary,
                              fontSize: Theme.of(context).textTheme.displaySmall!.fontSize
                          ),
                        ),
                      ],
                    ),
                    Icon(Icons.more_horiz_outlined,
                      color: Theme.of(context).colorScheme.tertiary,
                    )
                  ]
              ),
              const SizedBox(height: 10,),
              Text(comment.content,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.4
                ),
              ),

              const SizedBox(height: 15,),

              if (parentId == null)
                GestureDetector(
                  onTap: () {
                    handleTap!();
                    setReply!(comment);
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
                itemCount: comment.replyComments.length,
                itemBuilder: (context, index) {
                  Comment reply = comment.replyComments[index];
                  return CommentWidget(parentId: comment.commentId, comment: reply,);
                },
              ),

            ],
          ),
        ),
      ],
    );
  }
}
