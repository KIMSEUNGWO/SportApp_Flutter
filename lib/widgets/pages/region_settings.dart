
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sport/models/region.dart';
import 'package:flutter_sport/models/region_data.dart';

import 'package:easy_localization/easy_localization.dart';

class RegionSettingsWidget extends StatefulWidget {

  final Function(Region data) changeRegion;

  const RegionSettingsWidget({super.key, required this.changeRegion});

  @override
  State<RegionSettingsWidget> createState() => _RegionSettingsWidgetState();
}

class _RegionSettingsWidgetState extends State<RegionSettingsWidget> {

  List<Region> find = [Region.ALL];

  onChangedResult(List<Region> data) {
    setState(() {
      find = [Region.ALL, ...data];
    });
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
            child: FindResultRegionWidget(locale: locale, region: find[index], changeRegion : widget.changeRegion),
          );
        },
      )
    );
  }
}

class FindResultRegionWidget extends StatefulWidget {

  final Region region;
  final Locale locale;
  final Function(Region data) changeRegion;

  const FindResultRegionWidget({super.key, required this.region, required this.locale, required this.changeRegion});

  @override
  State<FindResultRegionWidget> createState() => _FindResultRegionWidgetState();
}

class _FindResultRegionWidgetState extends State<FindResultRegionWidget> {
  @override
  Widget build(BuildContext context) {
    String name = widget.region.getLocaleName(widget.locale);
    String fullName = widget.region.getFullName(widget.locale);
    return GestureDetector(
      onTap: () {
        widget.changeRegion(Region.findByName(widget.region.name));
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