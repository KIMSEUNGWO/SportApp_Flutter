

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_sport/common/open_app.dart';
import 'package:flutter_sport/models/common/user_profile.dart';
import 'package:flutter_sport/models/response_user.dart';
import 'package:flutter_sport/widgets/lists/user_list_widget.dart';

class MeetingDetailWidget extends StatefulWidget {

  final int clubId;
  final int meetingId;

  const MeetingDetailWidget({super.key, required this.clubId, required this.meetingId});


  @override
  State<MeetingDetailWidget> createState() => _MeetingDetailWidgetState();
}

class _MeetingDetailWidgetState extends State<MeetingDetailWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            clubImage(context, width: double.infinity, height: 150, image: null),

            // 일시, 제목, 주소
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('2024-09-01 (화) 20:00',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w500,
                        fontSize: Theme.of(context).textTheme.displayMedium!.fontSize,
                        letterSpacing: 0.4,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 5),
                    child: Text('일정타이틀자리일정타이틀자리일정타이틀자리일정타이틀자리일정타이틀자리',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w600,
                        fontSize: Theme.of(context).textTheme.displayLarge!.fontSize,
                        letterSpacing: 0.4,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      OpenApp().openMaps();
                    },
                    child: Text('인천광역시 남동구 간석동 772',
                      style: TextStyle(
                        fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.tertiary,
                        letterSpacing: 0.4,
                        decoration: TextDecoration.underline,
                        decorationColor: Theme.of(context).colorScheme.tertiary,
                      ),
                    ),
                  ),

                ],
              ),
            ),

            // 설명글
            Container(
              constraints: const BoxConstraints(
                minHeight: 250
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Text('설명글설명글설명글설명글설명글설명글설명글설명글설명글설명글설명글설명글설명글설명글설명글설명글설명글설명글설명글설명글설명글',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: Theme.of(context).textTheme.displayMedium!.fontSize,
                  fontWeight: FontWeight.w500
                ),
              ),
            ),

            Container(
              padding: const EdgeInsets.symmetric(vertical: 15),
              height: 30,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.outline,
              ),
            ),


            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 10,
                itemBuilder: (context, index) {
                  UserSimp user = UserSimp.fromJson({
                    "nickname" : "asdf",
                    "userId" : 1,
                    "thumbnailUser" : null
                  });
                  return UserSimpWidget(user: user,);
                },
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          padding: const EdgeInsets.symmetric(vertical: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Theme.of(context).colorScheme.onPrimary
          ),
          child: Text('일정 참가',
            style: TextStyle(
              color: Colors.white,
              fontSize: Theme.of(context).textTheme.displayMedium!.fontSize,
              fontWeight: FontWeight.w600,
              letterSpacing: 1
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}


