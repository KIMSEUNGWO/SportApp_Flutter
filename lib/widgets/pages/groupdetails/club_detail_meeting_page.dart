
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
              SliverList.builder(
                itemCount: 3,
                itemBuilder: (context, index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10, bottom: 10),
                        child: Text('2024-09-01 (화)',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 16
                          ),
                        ),
                      ),
                      Container(
                        height: 150,
                        margin: const EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.background,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Color(0xFFD7D7D7),
                            width: 0.2
                          ),
                          boxShadow: [
                            BoxShadow(color: Color(0xFFE4E4E4), offset: Offset(4, 4), blurRadius: 10)
                          ]
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



