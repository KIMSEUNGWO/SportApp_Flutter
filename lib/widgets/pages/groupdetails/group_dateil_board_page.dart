import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:easy_localization/easy_localization.dart';

class GroupDetailBoardWidget extends StatefulWidget {
  const GroupDetailBoardWidget({super.key});

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
              child: Row(
                children: [
                  const SizedBox(width: 13,) ,
                  ...boardMenus.map((menu) =>
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 7),
                        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color(0xFFEAEAEA),
                        ),
                        child: Text('groupBoardMenus',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF433F3F),
                          ),
                        ).tr(gender: menu),
                      )),
                  const SizedBox(width: 13,) ,
                ],
              ),
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 30,)),
        BoardNoticeWidget(),
        // SliverToBoxAdapter(child: HrBox(),)
        const SliverToBoxAdapter(child: SizedBox(height: 30,)),
        BoardListWidget(),

        SliverToBoxAdapter(child: SizedBox(height: 50,),)
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
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFF35353),
                  ),
                ),
              ),
              const SizedBox(width: 10, ),
              Expanded(
                flex: 3,
                child: Text('공지사항내용입니다공지사항내용입니다공지사항내용입니다공지사항내용입니다공지사항내용입니다공지사항내용입니다.',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
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
      separatorBuilder: (context, index) => Container(
        margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
        height: 1,
        decoration: BoxDecoration(
          color: Color(0xFFE4DDDD),
        ),
      ),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Container(
          padding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
          constraints: BoxConstraints(
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
                                color: Color(0xFFF3EFEF),
                              ),
                              child: Text('가입인사',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFF5C5959),
                                  fontWeight: FontWeight.w500
                                ),
                              ),
                            ),
                            SizedBox(height: 5,),
                            Text('게시글 제목',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 6,),
                            Text('게시물 내용게시물 내용게시물 내용게시물 내용게시물 내용게시물 내용게시물 내용게시물 내용게시물 내용게시물 내용게시물 내용게시물 내용게시물 내용게시물 내용게시물 내용게시물 내용게시물 내용게시물 내용게시물 내용게시물 내용게시물 내용게시물 내용게시물 내용내용게시물내용게시물내용게시물',
                              maxLines: 3,
                              style: TextStyle(
                                color: Color(0xFF333131),
                              ),
                            ),
                          ],
                        ),

                      ],
                    ),
                  ),
                  Container(
                    width: 70, height: 70,
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
                        style: TextStyle(
                          fontSize: 13,
                        ),
                      ),
                      Text(' · ',
                        style: TextStyle(
                          fontSize: 13,
                        ),
                      ),
                      Text('댓글 1',
                        style: TextStyle(
                          fontSize: 13,
                        ),
                      ),
                      Text(' · ',
                        style: TextStyle(
                          fontSize: 13,
                        ),
                      ),
                      Text('13분 전',
                        style: TextStyle(
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  Text('좋아요 1',
                    style: TextStyle(
                      fontSize: 13,
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
}



