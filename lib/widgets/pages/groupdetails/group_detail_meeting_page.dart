
import 'package:flutter/material.dart';

class GroupDetailMeetingWidget extends StatefulWidget {
  const GroupDetailMeetingWidget({super.key});

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
