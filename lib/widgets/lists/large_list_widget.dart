
import 'package:flutter/material.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_sport/common/navigator_helper.dart';
import 'package:flutter_sport/widgets/pages/groupdetails/club_detail_page.dart';
import 'package:go_router/go_router.dart';

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


  TextStyle detailStyle (BuildContext context) {
    return TextStyle(
      color: Theme.of(context).colorScheme.secondary,
      fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
    );
  }
  @override
  Widget build(BuildContext context) {

    List<Widget> extraWidget = [];

    if (extraInfo != null) {
      extraWidget.add(dot(context));
      extraWidget.add(extraInfo!);
    }
    return GestureDetector(
      onTap: () {
        // context.push('/club/$id');
        NavigatorHelper.push(context, ClubDetailWidget(id: id));
      },
      child: SizedBox(
        width: 180,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 100,
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
                      fontSize: Theme.of(context).textTheme.displaySmall!.fontSize,
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w600,
                      overflow: TextOverflow.ellipsis,
                      height: 1.5
                    ),
                  ),
                  Row(
                    children: [
                      Text(region, style: detailStyle(context),),
                      dot(context),
                      Icon(Icons.people_alt,
                        size: 15,
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                      Text('person', style: detailStyle(context),).tr(args: [personCount.toString()]),
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

  Text dot(BuildContext context) {
    return Text(' · ', style: detailStyle(context),);
  }
}
