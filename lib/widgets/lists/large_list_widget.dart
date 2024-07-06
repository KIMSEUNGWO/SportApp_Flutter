
import 'package:flutter/material.dart';
import 'package:flutter_sport/widgets/pages/groupdetails/group_detail_page.dart';

import 'package:easy_localization/easy_localization.dart';

class LargeListWidget extends StatelessWidget {

  final int id;
  final Image image;
  final String title;
  final String region;
  final int personCount;
  final Text? extraInfo;

  const LargeListWidget({
    super.key,
    required this.id,
    required this.image,
    required this.title,
    required this.region,
    required this.personCount,
    this.extraInfo
  });


  final double titleSize = 16;
  final TextStyle detailStyle = const TextStyle(
    color: Color(0xFF878080),
    fontSize: 13,
  );

  @override
  Widget build(BuildContext context) {

    List<Widget> extraWidget = [];

    if (extraInfo != null) {
      extraWidget.add(dot());
      extraWidget.add(extraInfo!);
    }
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => GroupDetailWidget(id: id,),)),
      child: SizedBox(
        width: 210,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 130,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              clipBehavior: Clip.hardEdge,
              child: image,
            ),
            Padding(
              padding: const EdgeInsets.all(5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                    style: TextStyle(
                        fontSize: titleSize,
                        fontWeight: FontWeight.w600,
                        overflow: TextOverflow.ellipsis,
                        height: 1.5
                    ),
                  ),
                  Row(
                    children: [
                      Text(region, style: detailStyle,),
                      dot(),
                      Text('person', style: detailStyle,).tr(args: [personCount.toString()]),
                      ...extraWidget
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Text dot() {
    return Text(' · ', style: detailStyle,);
  }
}
