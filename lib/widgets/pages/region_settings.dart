
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sport/models/region.dart';
import 'package:flutter_sport/models/club/region_data.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sport/notifiers/region_notifier.dart';

class RegionSettingsWidget extends ConsumerStatefulWidget {

  final bool excludeAll;
  Function(Region)? setRegion;

  RegionSettingsWidget({super.key, this.excludeAll = false, this.setRegion});

  @override
  ConsumerState<RegionSettingsWidget> createState() => _RegionSettingsWidgetState();
}

class _RegionSettingsWidgetState extends ConsumerState<RegionSettingsWidget> {

  late List<Region> find;

  onChangedResult(List<Region> data) {
    setState(() {
      if (widget.excludeAll) {
        find = data;
      } else {
        find = [Region.ALL, ...data];
      }
    });
  }

  @override
  void initState() {
    find = widget.excludeAll ? [] : [Region.ALL];
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    Locale locale = EasyLocalization.of(context)!.locale;

    return Scaffold(
      appBar: AppBar(
        title: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Color(0xFFE3E3E3),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  onChanged: (word) {
                    onChangedResult(FindRegion.findAll(word, locale));
                  },
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'alert'.tr(gender: 'placeholder_regionSearch'),
                    hintStyle: TextStyle(
                      color: Color(0xFF908E9B),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10,),
              Icon(Icons.search,
                color: Color(0xFF9F9B9B),
                size: 30,
              ),
            ],
          ),
        ),
      ),
      body: ListView.separated(
        separatorBuilder: (context, index) => Container(
          margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
          height: 1,
          decoration: BoxDecoration(
            color: Color(0xFFE4DDDD),
          ),
        ),
        itemCount: find.length,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            padding: EdgeInsets.symmetric(vertical: 10),
            child: FindResultRegionWidget(locale: locale, region: find[index], setRegion: widget.setRegion,),
          );
        },
      )
    );
  }
}

class FindResultRegionWidget extends ConsumerStatefulWidget {

  final Function(Region)? setRegion;
  final Region region;
  final Locale locale;

  const FindResultRegionWidget({super.key, required this.region, required this.locale, this.setRegion});

  @override
  ConsumerState<FindResultRegionWidget> createState() => _FindResultRegionWidgetState();
}

class _FindResultRegionWidgetState extends ConsumerState<FindResultRegionWidget> {
  @override
  Widget build(BuildContext context) {
    String name = widget.region.getLocaleName(widget.locale);
    String fullName = widget.region.getFullName(widget.locale);
    return GestureDetector(
      onTap: () {
        Region r = Region.findByName(widget.region.name);
        if (widget.setRegion != null && r != Region.ALL) {
          widget.setRegion!(r);
        } else {
          ref.watch(regionProvider.notifier).changeRegion(r);
        }
        Navigator.pop(context);
      },
      child: Row(
        children: [
          Text(name,
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          SizedBox(width: 10,),
          Text(fullName,
            style: TextStyle(
              color: Color(0xFF6B656E),
            ),
          ),
        ],
      ),
    );
  }
}

// @override
// Widget build(BuildContext context) {
//   return Scaffold(
//     appBar: AppBar(
//       title: Text('내 지역'),
//     ),
//     body: Container(
//       margin: EdgeInsets.symmetric(horizontal: 30, vertical: 50),
//       child: Flex(
//         direction: Axis.horizontal,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Row(
//             children: [
//               Icon(Icons.star_border,
//                 size: 30,
//                 color: Color(0xFF2B2828),
//               ),
//               SizedBox(width: 3,),
//               Text('관심 지역',
//                 style: TextStyle(
//                     fontSize: 19,
//                     fontWeight: FontWeight.w500,
//                     color: Color(0xFF2B2828)
//                 ),
//               )
//             ],
//           ),
//           SizedBox(width: 30),
//           Expanded(
//             child: Container(
//               padding: EdgeInsets.all(10),
//               decoration: BoxDecoration(
//                 color: Color(0xFFEAE3E3),
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: Text('시부야',
//                 style: TextStyle(
//                   fontSize: 17,
//                   fontWeight: FontWeight.w500,
//                   color: Color(0xFF393636),
//                 ),
//               ),
//             ),
//           )
//         ],
//       ),
//     ),
//   );
// }