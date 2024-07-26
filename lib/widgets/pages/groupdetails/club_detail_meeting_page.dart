
import 'package:flutter/material.dart';
import 'package:flutter_sport/common/navigator_helper.dart';
import 'package:flutter_sport/main.dart';
import 'package:flutter_sport/models/club/authority.dart';
import 'package:flutter_sport/models/club/club_data.dart';

class ClubDetailMeetingWidget extends StatefulWidget {

  final ClubDetail club;

  const ClubDetailMeetingWidget({super.key, required this.club});

  @override
  State<ClubDetailMeetingWidget> createState() => _ClubDetailMeetingWidgetState();
}

class _ClubDetailMeetingWidgetState extends State<ClubDetailMeetingWidget> with AutomaticKeepAliveClientMixin {


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverPadding(padding: EdgeInsets.only(top: 30)),
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
                        margin: const EdgeInsets.only(bottom: 30),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.background,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(color: Color(0xFFD8D8D8), offset: Offset(4, 4), blurRadius: 10)
                          ]
                        ),
                      ),
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
        ],
      )
    );
  }

  @override
  bool get wantKeepAlive => true;
}
