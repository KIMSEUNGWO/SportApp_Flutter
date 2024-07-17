import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_sport/widgets/pages/common/common_sliver_appbar.dart';
import 'package:flutter_sport/widgets/pages/create_group_page.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MyGroupPage extends ConsumerStatefulWidget {
  const MyGroupPage({super.key});

  @override
  ConsumerState<MyGroupPage> createState() => _MyGroupPageState();
}

class _MyGroupPageState extends ConsumerState<MyGroupPage> with AutomaticKeepAliveClientMixin {

  @override
  Widget build(BuildContext context) {

    super.build(context);
    return Stack(
      children: [
        CustomScrollView(
        slivers: [
          CustomSliverAppBar(),
          CupertinoSliverRefreshControl(
            refreshTriggerPullDistance: 100.0,
            refreshIndicatorExtent: 50.0,
            onRefresh: () async {
              // 위로 새로고침
              await Future.delayed(Duration(seconds: 2));
            },
          ),
          SliverToBoxAdapter(
            child: Container(
              height: 120,
              margin: EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color(0xFFDCD7D7)
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text('내 모임',
                style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w500
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverList.separated(
              separatorBuilder: (context, index) => SizedBox(height: 13,),
              itemCount: 2,
              itemBuilder: (context, index) {
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Color(0xFFFBFBFB),
                    boxShadow: [
                      BoxShadow(color: Color(0xFFF1F1F5), offset: Offset(5, 5), blurRadius: 6)
                    ]
                  ),
                  child: Column (
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('그룹 제목임',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 5,),
                                Row(
                                  children: [
                                    Text('야구'),
                                    Text(' · '),
                                    Text('신주쿠구'),
                                    Text(' · '),
                                    Icon(Icons.people_alt, size: 17, color: Color(0xFF707072),),
                                    Text('3명'),
                                  ],
                                )
                              ],
                            ),
                          ),
                          Container(
                            width: 65, height: 65,
                            margin: EdgeInsets.only(left: 15),
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(
                              color: Color(0xFFE4E4E4),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(child: SvgPicture.asset('assets/icons/emptyGroupImage.svg', width: 35, height: 35, color: Color(0xFF878181),))
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          )
        ],
      ),
        Positioned(
          right: 20,
          bottom: 20,
          child: GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => CreateGroupWidget(),));
            },
            child: Container(
              width: 65, height: 65,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Color(0xFFE9F1FA),
              ),
              child: Icon(Icons.add, size: 40,),
            ),
          ),
        )
      ]
    );
  }

  @override
  bool get wantKeepAlive => true;
}

