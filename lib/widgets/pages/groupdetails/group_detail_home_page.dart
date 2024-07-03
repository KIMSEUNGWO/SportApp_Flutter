

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_sport/models/alert.dart';

class GroupDetailHomeWidget extends StatefulWidget {
  const GroupDetailHomeWidget({super.key});

  @override
  State<GroupDetailHomeWidget> createState() => _GroupDetailHomeWidgetState();
}

class _GroupDetailHomeWidgetState extends State<GroupDetailHomeWidget> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {

    String intro = r"""
SingleChildScrollView와 CustomScrollView의 성능 차이에 대해서는 상황에 따라 다릅니다. 일반적으로 다음과 같은 차이가 있습니다:

복잡성
SingleChildScrollView는 단일 자식 위젯을 스크롤하므로 구현이 간단합니다.
CustomScrollView는 여러 개의 Sliver 위젯을 관리하므로 구현이 복잡합니다.

메모리 사용량
SingleChildScrollView는 단일 자식 위젯만 관리하므로 메모리 사용량이 적습니다.
CustomScrollView는 여러 개의 Sliver 위젯을 관리하므로 메모리 사용량이 더 많습니다.

렌더링 성능
SingleChildScrollView는 단일 자식 위젯만 렌더링하므로 렌더링 속도가 빠릅니다.
CustomScrollView는 여러 개의 Sliver 위젯을 렌더링해야 하므로 렌더링 속도가 상대적으로 느릅니다.
그러나 이러한 차이는 상황에 따라 다릅니다. 예를 들어, CustomScrollView를 사용하면 복잡한 스크롤 UI를 구현할 수 있지만, 이로 인한 성능 저하가 크지 않을 수 있습니다.

따라서 성능 측면에서 SingleChildScrollView가 더 우수하지만, 스크롤 UI의 복잡성에 따라 CustomScrollView를 사용해야 할 수 있습니다. 실제 사용 사례와 테스트를 통해 적절한 위젯을 선택해야 합니다.
    """;

    return Container(
      child: Stack(
        children: [
          CustomScrollView(
          physics: AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          slivers: [
            CupertinoSliverRefreshControl(
              refreshTriggerPullDistance: 100.0,
              refreshIndicatorExtent: 80.0,
              onRefresh: () async {
                // 위로 새로고침
                await Future.delayed(Duration(seconds: 2));
              },
            ),
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.only(bottom: 20),
                width: double.infinity,
                height: 200,
                child: Image.asset('assets/groupImages/sample1.jpeg', fit: BoxFit.fill,),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('퇴근 후 풋볼 모임',
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.w500,
                        height: 2
                      ),
                    ),
                    Row(
                      children: [
                        Tag(title: '풋볼'),
                        const SizedBox(width: 10),
                        Tag(title: '도쿄구',),
                        const SizedBox(width: 10),
                        Tag(title: '회원 3명',)
                      ],
                    ),
                    const SizedBox(height: 20,),
                    Text(intro, style: TextStyle(fontSize: 14),), // 본문내용
                  ],
                )
              ),
            ),
            SliverToBoxAdapter(child: SizedBox(height: 100,),)
          ],
        ),
          GestureDetector(
            onTap: () {
              Alert.message(context: context, text: const Text('로그인이 필요합니다.'), onPressed: () {});

            },
            child: Container(
              margin: const EdgeInsets.only(left: 20, right: 20, bottom: 40),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(2, 2),
                        color: Colors.grey,
                        blurRadius: 6
                      )
                    ],
                  ),
                  height: 55,
                  alignment: Alignment.center,
                  child: Text('참여하기',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 21,
                      letterSpacing: 1.4,
                    ),
                  ),
                ),
              ),
            ),
          )
        ]
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class Tag extends StatelessWidget {

  final String title;

  const Tag({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Color(0xFFDFDFDF),
      ),
      child: Text(title,
        style: TextStyle(
          color: Color(0xFF605B5B),
          fontSize: 12
        ),
      ),
    );
  }
}

