import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_sport/models/board/board_type.dart';
import 'package:flutter_sport/models/club/club_data.dart';
import 'package:flutter_sport/widgets/pages/board/create_board_page.dart';

import 'package:flutter_svg/flutter_svg.dart';

class GroupDetailBoardWidget extends StatefulWidget {

  final ClubDetail club;

  const GroupDetailBoardWidget({super.key, required this.club});

  @override
  State<GroupDetailBoardWidget> createState() => _GroupDetailBoardWidgetState();
}

class _GroupDetailBoardWidgetState extends State<GroupDetailBoardWidget> with AutomaticKeepAliveClientMixin{

  final List<String> boardMenus = ['all', ...BoardType.values.map((e) => e.lang)];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 15),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 13),
                  child: Row(
                    children: boardMenus
                      .map((menu) =>
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 7),
                          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Theme.of(context).colorScheme.onSecondary,
                          ),
                          child: Text('groupBoardMenus',
                            style: TextStyle(
                              fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).colorScheme.primary
                            ),
                          ).tr(gender: menu),
                        )
                    ).toList(),
                  ),
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 30,)),
          const BoardNoticeWidget(),
          // SliverToBoxAdapter(child: HrBox(),)
          const SliverToBoxAdapter(child: SizedBox(height: 30,)),
          const BoardListWidget(),

          const SliverToBoxAdapter(child: SizedBox(height: 50,),)
        ],
      ),
        if (widget.club.authority != null)
          Positioned(
          right: 20,
          bottom: 70,
          child: GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => CreateBoardWidget(clubId: widget.club.id, authority: widget.club.authority),
                fullscreenDialog: true,
              ));
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              child: Row(
                children: [
                  Icon(Icons.add,
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


class BoardNoticeWidget extends StatelessWidget {

  const BoardNoticeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      sliver: SliverList.separated(
        itemCount: 3,
        separatorBuilder: (context, index) {
          return const SizedBox(height: 5,);
        },
        itemBuilder: (context, index) {
          return Flex(
            direction: Axis.horizontal,
            children: [
              Container(
                padding: const EdgeInsets.only(right: 3, top: 5, bottom: 5,),
                decoration: BoxDecoration(
                ),
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
                child: Text('공지사항내용입니다공지사항내용입니다공지사항내용입니다공지사항내용입니다공지사항내용입니다공지사항내용입니다.',
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


class BoardListWidget extends StatelessWidget {
  const BoardListWidget({super.key});

  @override
  Widget build(BuildContext context) {
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
      itemCount: 5,
      itemBuilder: (context, index) {
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
                  Container(
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
                            child: const Center(
                                child: Icon(Icons.person, size: 20, color: const Color(0xFF878181),)
                            )
                        ),
                        Text('아아아아아아아아아아',
                          style: TextStyle(
                              fontSize: Theme.of(context).textTheme.bodySmall!.fontSize
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 10,),
                  Flex(
                    direction: Axis.horizontal,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('게시글 제목',
                              style: TextStyle(
                                fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).colorScheme.primary,
                                overflow: TextOverflow.ellipsis
                              ),
                            ),
                            const SizedBox(height: 6,),
                            Text('게시물 내용게시물 내용게시물 내용게시물 내용게시물 내용게시물 내용게시물 내용게시물 내용게시물 내용게시물 내용게시물 내용게시물 내용게시물 내용게시물 내용게시물 내용게시물 내용게시물 내용게시물 내용게시물 내용게시물 내용게시물 내용게시물 내용게시물 내용내용게시물내용게시물내용게시물',
                              maxLines: 2,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.secondary,
                                fontSize: Theme.of(context).textTheme.bodySmall!.fontSize
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        // width: 70, height: 70,
                        width: 112, height: 73,
                        margin: const EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        clipBehavior: Clip.hardEdge,
                        child: Image.asset('assets/groupImages/sample1.jpeg', fit: BoxFit.fill,),
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
                      Text(' 1',
                        style: detailStyle(context),
                      ),
                      Text(' · ',
                        style: detailStyle(context),
                      ),
                      SvgPicture.asset('assets/icons/emptyGroupImage.svg',
                        color: Colors.grey,
                        width: 20,
                      ),
                      Text(' 1',
                        style: detailStyle(context),
                      ),
                      Text(' · ',
                        style: detailStyle(context),
                      ),
                      Text('13분 전',
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
                    child: Text('가입인사',
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
      },
    );

  }
  TextStyle detailStyle(BuildContext context) {
    return TextStyle(
      fontSize: Theme.of(context).textTheme.displaySmall!.fontSize,
      color: Theme.of(context).colorScheme.tertiary,
    );
  }
}



