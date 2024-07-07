import 'package:flutter/material.dart';
import 'package:flutter_sport/widgets/pages/groupdetails/group_detail_page.dart';

import 'package:easy_localization/easy_localization.dart';


class SmallListWidget extends StatelessWidget {

  final int id;
  final Image image;
  final String title;
  final String intro;
  final String sportType;
  final String region;
  final int personCount;
  final EdgeInsets? padding;

  const SmallListWidget({
    super.key,
    required this.id,
    required this.image,
    required this.title,
    required this.intro,
    required this.sportType,
    required this.region,
    required this.personCount,
    this.padding
  });

  final TextStyle detailStyle = const TextStyle(
    color: Color(0xFF707072),
    fontSize: 12,
  );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(
          builder: (context) => GroupDetailWidget(id: id,),)
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 65, height: 65,
              margin: const EdgeInsets.only(right: 15),
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: image,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(intro,
                        style: TextStyle(
                            overflow: TextOverflow.ellipsis,
                            fontSize: 13,
                            color: Theme.of(context).colorScheme.secondary
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5,),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color(0xFFDFDFDF)
                        ),
                        child: Text(sportType,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      dot(),
                      Text(region, style: detailStyle),
                      dot(),
                      Text('person'.tr(args: [personCount.toString()]), style: detailStyle)
                    ],
                  )
                ],
              ),
            )
          ],

        ),
      ),
    );
  }

  Text dot() {
    return Text(' · ', style: detailStyle,);
  }
}
