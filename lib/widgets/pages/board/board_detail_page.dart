

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_sport/api/api_result.dart';
import 'package:flutter_sport/api/board/board_service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_sport/models/board/board_detail.dart';
import 'package:flutter_sport/models/comment/comment.dart';
import 'package:flutter_sport/widgets/pages/common/image_detail_view.dart';

class BoardDetailWidget extends StatefulWidget {

  final int clubId;
  final int boardId;

  const BoardDetailWidget({super.key, required this.boardId, required this.clubId});

  @override
  State<BoardDetailWidget> createState() => _BoardDetailWidgetState();
}

class _BoardDetailWidgetState extends State<BoardDetailWidget> {

  late BoardDetail boardDetail;
  bool isLoading = true;

  setLoading(bool data) {
    setState(() {
      isLoading = data;
    });
  }

  fetchImage() async {
    ResponseResult result = await BoardService.getBoardDetail(clubId: widget.clubId, boardId: widget.boardId);
    if (result.resultCode == ResultCode.OK) {
      boardDetail = BoardDetail.fromJson(result.data);
      setLoading(false);
    }
  }
  @override
  void initState() {
    fetchImage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: (isLoading)
        ? Center(child: CupertinoActivityIndicator(),)
        : CustomScrollView(
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
                margin: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.outline,
                ),
              ),
            ),

            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('댓글 ${boardDetail.comments.length}',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 20,),

                    // 댓글
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 35, height: 35,
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: boardDetail.thumbnailUser ??
                            const Center(
                                child: Icon(Icons.person, size: 20, color: const Color(0xFF878181),)
                            )
                        ),
                        const SizedBox(width: 15,),
                        Expanded(
                          child: Column (
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
                                          Text('작성자',
                                            style: TextStyle(
                                                color: Theme.of(context).colorScheme.primary,
                                                fontWeight: FontWeight.w600,
                                                fontSize: Theme.of(context).textTheme.displayMedium!.fontSize
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
                                      Text('3시간 전',
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
                              Text('댓글내용댓글내용댓글내용댓글내용댓글내용댓글내용댓글내용댓글내용댓글내용댓글내용',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.4
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                  ],
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Container(
                height: 7,
                margin: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.outline,
                ),
              ),
            ),
            

          ],
        ),

      bottomNavigationBar: SafeArea(
        child: Container(
          height: 50,
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Row(
            children: [
              Icon(Icons.image_outlined, size: 30, color: Theme.of(context).colorScheme.secondary,),
              SizedBox(width: 10,),
              Icon(Icons.location_on_outlined, size: 30, color: Theme.of(context).colorScheme.secondary,),
              SizedBox(width: 15,),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Theme.of(context).colorScheme.primaryContainer
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
              )
            ],
          ),
        )
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
