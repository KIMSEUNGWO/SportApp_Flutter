
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_sport/common/navigator_helper.dart';
import 'package:flutter_sport/main.dart';
import 'package:flutter_sport/models/club/authority.dart';
import 'package:flutter_sport/models/club/club_data.dart';
import 'package:flutter_sport/models/common/user_profile.dart';
import 'package:flutter_sport/models/response_user.dart';

class ClubDetailMeetingWidget extends StatefulWidget {

  final ClubDetail club;

  const ClubDetailMeetingWidget({super.key, required this.club});

  @override
  State<ClubDetailMeetingWidget> createState() => _ClubDetailMeetingWidgetState();
}

class _ClubDetailMeetingWidgetState extends State<ClubDetailMeetingWidget> with AutomaticKeepAliveClientMixin {

  final List<UserSimp> testData = [
    UserSimp.fromJson({
      "userId" : 1,
      "thumbnailUser" : null,
      "nickname" : "asdfasdf"
    }),
    UserSimp.fromJson({
      "userId" : 1,
      "thumbnailUser" : null,
      "nickname" : "asdfasdf"
    }),
  ];
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Stack(
        children: [
          CustomScrollView(
            slivers: [
              const SliverPadding(padding: EdgeInsets.only(top: 30)),

              // TODO 이전 모임도 함께 볼거지 선택하는 스위치 구현예정
              SliverToBoxAdapter(
                child: Center(
                  child: IOSStyleToggleButton(),
                ),
              ),

              SliverList.builder(
                itemCount: 3,
                itemBuilder: (context, index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10, bottom: 10),
                        child: Text('2024-09-01 (화) 20:00 ~ 24:00',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 16
                          ),
                        ),
                      ),
                      Container(
                        height: 130,
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.background,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: const Color(0xFFD7D7D7),
                            width: 0.2
                          ),
                          boxShadow: const [
                            BoxShadow(color: Color(0xFFE4E4E4), offset: Offset(4, 4), blurRadius: 10)
                          ]
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 110,
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            const SizedBox(width: 15,),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('일정이름일정이름일정이름일정이름일정이름',
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: Theme.of(context).colorScheme.primary,
                                          fontWeight: FontWeight.w600
                                        ),
                                      ),
                                      Text('인천광역시 남동구 간석동 772',
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: Theme.of(context).colorScheme.secondary,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      userProfile(context, diameter: 20, image: null),
                                      SizedBox(width: 10,),
                                      Text('이름이름',
                                        style: TextStyle(
                                          color: Theme.of(context).colorScheme.secondary,
                                          fontWeight: FontWeight.w600
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      _JoinUsersWidget(users: testData),
                      const SizedBox(height: 40,),
                    ],
                  );
                },
              ),

            ],
          ),

          if (widget.club.authority == Authority.OWNER || widget.club.authority == Authority.MANAGER)
            Positioned(
              right: 0,
              bottom: 70,
              child: GestureDetector(
                onTap: () {
                  NavigatorHelper.push(context, Scaffold(
                    appBar: AppBar(),
                  ),
                      fullscreenDialog: true
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.add,
                        size: 30,
                        color: Colors.white,
                      ),
                      SizedBox(width: 8,),
                      Text('일정추가',
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

        ],
      )
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class _JoinUsersWidget extends StatelessWidget {

  final List<UserSimp> users;
  final int maxCount = 5;

  const _JoinUsersWidget({super.key, required this.users});

  maxLength() {
    return min(users.length, maxCount);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _OverlappingCircles(users: users.sublist(0, maxLength())),
        const SizedBox(width: 10,),
        Text('${users.length}명 참여',
          style: TextStyle(
            color: Theme.of(context).colorScheme.tertiary,
            fontWeight: FontWeight.w500
          ),
        ),
      ],
    );
  }
}

class _OverlappingCircles extends StatelessWidget {

  final List<UserSimp> users;
  final double circleDiameter = 35.0;
  final double overlapPercentage = 0.5;

  const _OverlappingCircles({super.key, required this.users});

  @override
  Widget build(BuildContext context) {
    if (users.isEmpty) return SizedBox(height: circleDiameter,);
    final double overlapAmount = circleDiameter * overlapPercentage;

    return SizedBox(
      width: circleDiameter + max(users.length - 1, 0) * (circleDiameter - overlapAmount),
      height: circleDiameter,
      child: Stack(
        children: List.generate(users.length, (index) =>
          Positioned(
            left: index * (circleDiameter - overlapAmount),
            child: userProfile(context, diameter: circleDiameter, image: users[index].thumbnailUser)
          ),
        ),
      ),
    );
  }
}


class IOSStyleToggleButton extends StatefulWidget {
  @override
  _IOSStyleToggleButtonState createState() => _IOSStyleToggleButtonState();
}

class _IOSStyleToggleButtonState extends State<IOSStyleToggleButton> {
  bool isToggled = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isToggled = !isToggled;
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        width: 70,
        height: 35,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: isToggled ? Colors.green : Colors.grey,
        ),
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: Duration(milliseconds: 200),
              curve: Curves.easeIn,
              left: isToggled ? 35.0 : 0.0,
              right: isToggled ? 0.0 : 35.0,
              child: Container(
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


