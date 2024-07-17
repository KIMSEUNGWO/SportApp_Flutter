
import 'package:flutter/material.dart';
import 'package:flutter_sport/models/club/club_data.dart';

class GroupDetailMeetingWidget extends StatefulWidget {

  final ClubDetail club;

  const GroupDetailMeetingWidget({super.key, required this.club});

  @override
  State<GroupDetailMeetingWidget> createState() => _GroupDetailMeetingWidgetState();
}

class _GroupDetailMeetingWidgetState extends State<GroupDetailMeetingWidget> with AutomaticKeepAliveClientMixin {


  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('그룹일 모임'),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
