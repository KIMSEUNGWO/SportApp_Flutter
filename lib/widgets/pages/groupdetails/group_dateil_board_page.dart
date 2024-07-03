import 'package:flutter/material.dart';

class GroupDetailBoardWidget extends StatefulWidget {
  const GroupDetailBoardWidget({super.key});

  @override
  State<GroupDetailBoardWidget> createState() => _GroupDetailBoardWidgetState();
}

class _GroupDetailBoardWidgetState extends State<GroupDetailBoardWidget> with AutomaticKeepAliveClientMixin{

  int count = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('$count'),
        IconButton(onPressed: () => setState(() => count++), icon: Icon(Icons.plus_one))
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
