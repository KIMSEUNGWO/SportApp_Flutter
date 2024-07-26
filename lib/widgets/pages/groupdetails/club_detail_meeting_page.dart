
import 'package:flutter/material.dart';
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
    return Container(
      child: Text('그룹일 모임'),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
