import 'package:flutter/material.dart';
import 'package:flutter_sport/models/group_data.dart';
import 'package:flutter_sport/models/region_data.dart';
import 'package:flutter_sport/widgets/lists/small_list_widget.dart';

class RecentlyVisitPages extends StatelessWidget {
  RecentlyVisitPages({super.key});

  final List<GroupData> recentlyVisitGroups = [
    GroupData(
      id: 1,
      image: 'assets/groupImages/sample1.jpeg',
      title: '野球団野球団野球団野球団野球団野球団野球団野球団',
      intro: '新人さんを待っています',
      sportType: '야구',
      region: Region.SHINJUKU,
      personCount: 3,
    ),

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('최근 본 모임'),
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 30),
        child: ListView.builder(
          itemCount: recentlyVisitGroups.length,
          itemBuilder: (context, index) {
            final data = recentlyVisitGroups[index];
            return SmallListWidget(
                id: data.id,
                image: Image.asset(data.image, fit: BoxFit.fill,),
                title: data.title,
                intro: data.intro,
                sportType: data.sportType,
                region: data.region,
                personCount: data.personCount
            );
          },
        ),
      ),
    );
  }
}
