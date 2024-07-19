import 'package:flutter/material.dart';
import 'package:flutter_sport/models/club/region_data.dart';
import 'package:flutter_sport/models/club/sport_type.dart';
import 'package:flutter_sport/widgets/pages/groupdetails/group_detail_page.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_svg/flutter_svg.dart';


class SmallListWidget extends StatelessWidget {

  final int id;
  final Image? image;
  final String title;
  final String? intro;
  final SportType sport;
  final Region region;
  final int personCount;
  final EdgeInsets? padding;

  const SmallListWidget({
    super.key,
    required this.id,
    required this.image,
    required this.title,
    required this.intro,
    required this.sport,
    required this.region,
    required this.personCount,
    this.padding
  });


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(
          builder: (context) => GroupDetailWidget(id: id,),)
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                width: 65, height: 65,
                margin: const EdgeInsets.only(right: 15),
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: image ?? Center(
                    child: SvgPicture.asset('assets/icons/emptyGroupImage.svg',
                      width: 40, height: 40, color: Color(0xFF878181),
                    )
                )
            ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            // fontSize: 18,
                            fontSize: Theme.of(context).textTheme.displayMedium!.fontSize,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.primary
                          ),
                        ),
                        Text(intro ?? '',
                          style: TextStyle(
                              overflow: TextOverflow.ellipsis,
                              // fontSize: 13,
                              fontSize: Theme.of(context).textTheme.displaySmall!.fontSize,
                              color: Theme.of(context).colorScheme.secondary
                          ),
                          maxLines: 2,
                        ),
                      ],
                    ),
                    const SizedBox(height: 5,),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 1.5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Theme.of(context).colorScheme.secondaryContainer
                          ),
                          child: Text('sportTitle',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 1
                            ),
                          ).tr(gender: sport.lang),
                        ),
                        dot(context),
                        Text(region.getLocaleName(EasyLocalization.of(context)!.locale),
                          style: detailStyle(context),
                        ),
                        dot(context),
                        Icon(Icons.people_alt,
                          size: 17,
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
                        Text('person'.tr(args: [personCount.toString()]),
                          style: detailStyle(context),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],

        ),
      ),
    );
  }

  TextStyle detailStyle(BuildContext context) {
    return TextStyle(
      color: Theme.of(context).colorScheme.tertiary,
      fontSize: 12,
    );
  }

  Text dot(BuildContext context) {
    return Text(' · ', style: detailStyle(context),);
  }
}
