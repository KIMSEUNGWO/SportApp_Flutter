import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_sport/models/club/club_data.dart';

class GroupDetailBoardWidget extends StatefulWidget {

  final ClubDetail club;

  const GroupDetailBoardWidget({super.key, required this.club});

  @override
  State<GroupDetailBoardWidget> createState() => _GroupDetailBoardWidgetState();
}

class _GroupDetailBoardWidgetState extends State<GroupDetailBoardWidget> with AutomaticKeepAliveClientMixin{

  int count = 0;

  final List<String> boardMenus = ['all', 'notice', 'firstComment', 'openBoard'];

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
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
            minHeight: 180,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flex(
                direction: Axis.horizontal,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 3,
                    child: Column(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Theme.of(context).colorScheme.onSecondary,
                              ),
                              child: Text('가입인사',
                                style: TextStyle(
                                  fontSize: Theme.of(context).textTheme.displaySmall!.fontSize,
                                  color: Theme.of(context).colorScheme.secondary,
                                  fontWeight: FontWeight.w500
                                ),
                              ),
                            ),
                            const SizedBox(height: 5,),
                            Text('게시글 제목',
                              style: TextStyle(
                                fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).colorScheme.primary,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text('게시글 작성자',
                        style: detailStyle(context),
                      ),
                      Text(' · ',
                        style: detailStyle(context),
                      ),
                      Text('댓글 1',
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
                  Text('좋아요 1',
                    style: detailStyle(context),
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



