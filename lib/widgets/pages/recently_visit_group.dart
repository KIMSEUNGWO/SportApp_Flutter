import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sport/api/group/club_service.dart';
import 'package:flutter_sport/models/club/club_data.dart';
import 'package:flutter_sport/models/component.dart';
import 'package:flutter_sport/widgets/lists/small_list_widget.dart';

class RecentlyVisitPages extends StatelessWidget {

  List<ClubSimp> clubs;

  RecentlyVisitPages({super.key, required this.clubs});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('최근 본 모임'),
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 30),
        child: ListView.builder(
          itemCount: clubs.length,
          itemBuilder: (context, index) {
            final data = clubs[index];
            if (data.sport != null && data.region != null) {
              return SmallListWidget(
                  id: data.id,
                  image: data.thumbnail,
                  title: data.title,
                  intro: data.intro,
                  sport: data.sport!,
                  region: data.region!,
                  personCount: data.personCount
              );
            }
            return null;
          },
        )
      ),
    );
  }
}
