

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_sport/models/region_data.dart';
import 'package:flutter_sport/models/sport_type.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_sport/widgets/pages/region_settings.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateGroupWidget extends StatefulWidget {
  const CreateGroupWidget({super.key});

  @override
  State<CreateGroupWidget> createState() => _CreateGroupWidgetState();
}

class _CreateGroupWidgetState extends State<CreateGroupWidget> {

  late TextEditingController _titleController;
  late TextEditingController _introController;
  late TextEditingController _personController;

  SportType? sportType;
  Region? region;

  selectSportType(SportType type) {
    setState(() {
      sportType = type;
    });
  }

  selectRegion(Region region) {
    setState(() {
      this.region = region;
    });
  }

  @override
  void initState() {
    _titleController = TextEditingController();
    _introController = TextEditingController();
    _personController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _introController.dispose();
    _personController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          GestureDetector(
            onTap: () => {
              print('asdf')
            },
            child: Container(
              margin: EdgeInsets.only(right: 20),
              child: Text('등록',
                style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w500
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SelectSportTypeWidget(select: selectSportType, sportType: sportType),

              const SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 25,),
                      SizedBox(width: 5,),
                      Text('지역',
                        style: TextStyle(
                            fontSize: 17
                        ),
                      )
                    ],
                  ),

                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return RegionSettingsWidget(excludeAll: true, setRegion: selectRegion,);
                      },));
                    },
                    child: Row(
                      children: [
                        Text(region?.getLocaleName(EasyLocalization.of(context)!.locale) ?? '',
                          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                        ),
                        SizedBox(width: 20,),
                        Icon(Icons.arrow_forward_ios, size: 20,)
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20,),
              Row(
                children: [
                  Row(
                    children: [
                      Icon(Icons.people_alt, size: 25,),
                      const SizedBox(width: 5,),
                      Text('인원 수',
                        style: TextStyle(
                            fontSize: 17
                        ),
                      ),
                      const SizedBox(width: 10,),
                      Text('(3 ~ 100명)')
                    ],
                  ),
                  SizedBox(width: 30,),
                  Expanded(
                    child: TextField(
                      controller: _personController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        CustomRangeTextInputFormatter(max: 100),
                      ],
                      style: TextStyle(
                        fontSize: 16,
                      ),
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(
                              color: Color(0xFFD9D9D9),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(
                                color: Color(0xFFD9E7F6),
                                width: 2
                            ),
                          ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20,),
              TextField(
                controller: _titleController,
                style: TextStyle(
                  fontSize: 16,
                ),
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(
                        color: Color(0xFFD9D9D9),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(
                      color: Color(0xFFD9E7F6),
                      width: 2
                    ),
                  ),
                  hintText: '제목을 입력해주세요.'
                ),
              ),
              const SizedBox(height: 20,),
              TextField(
                controller: _introController,
                style: TextStyle(
                  fontSize: 16,
                ),
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(
                      color: Color(0xFFD9D9D9),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(
                      color: Color(0xFFD9E7F6),
                      width: 2
                    ),
                  ),
                  hintText: '소개글 입력'
                ),
                maxLines: 8,
                maxLength: 300,
              ),
              const SizedBox(height: 20,),

            ],
          ),
        ),
      ),
    );
  }
}

class CustomRangeTextInputFormatter extends TextInputFormatter {

  final int max;

  const CustomRangeTextInputFormatter({required this.max});

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) return newValue;

    final int? value = int.tryParse(newValue.text);
    if (value == null) {
      return oldValue;
    }
    if (value > max) {
      return TextEditingValue(text: '$max');
    };

    return newValue;
  }
}

class SelectSportTypeWidget extends StatefulWidget {

  final Function(SportType) select;
  SportType? sportType;

  SelectSportTypeWidget({super.key, required this.select, required this.sportType});


  @override
  State<SelectSportTypeWidget> createState() => _SelectSportTypeWidgetState();
}

class _SelectSportTypeWidgetState extends State<SelectSportTypeWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SelectMenu(
              select: widget.select,
              assetSvg: 'assets/icons/soccer.svg',
              label: 'soccer',
              sportType: SportType.SOCCER,
              target: widget.sportType,
            ),
            SelectMenu(
              select: widget.select,
              assetSvg: 'assets/icons/baseball.svg',
              label: 'baseball',
              sportType: SportType.BASEBALL,
              target: widget.sportType,
            ),
            SelectMenu(
              select: widget.select,
              assetSvg: 'assets/icons/badminton.svg',
              label: 'badminton',
              sportType: SportType.BADMINTON,
              target: widget.sportType,
            ),
          ],
        ),
        SizedBox(height: 20,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SelectMenu(
              select: widget.select,
              assetSvg: 'assets/icons/tennis.svg',
              label: 'tennis',
              sportType: SportType.TENNIS,
              target: widget.sportType,
            ),
            SelectMenu(
              select: widget.select,
              assetSvg: 'assets/icons/basketball.svg',
              label: 'basketball',
              sportType: SportType.BASKETBALL,
              target: widget.sportType,
            ),
            SelectMenu(
              select: widget.select,
              assetSvg: 'assets/icons/trainers.svg',
              label: 'running',
              sportType: SportType.RUNNING,
              target: widget.sportType,
            ),
          ],
        ),
      ],
    );
  }
}


class SelectMenu extends StatefulWidget {

  final SportType sportType;
  final String assetSvg;
  final String label;
  final Function(SportType) select;
  SportType? target;

  SelectMenu({super.key, required this.sportType, required this.assetSvg, required this.label, required this.select, required this.target});

  @override
  State<SelectMenu> createState() => _SelectMenuState();
}

class _SelectMenuState extends State<SelectMenu> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.select(widget.sportType);
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: widget.sportType == widget.target ? const Color(0xFFD9E7F6) : Colors.white,
          borderRadius: BorderRadius.circular(10)
        ),
        width: 80,
        child: Column(
          children: [
            SvgPicture.asset(widget.assetSvg),
            const SizedBox(height: 6,),
            Text('sportTitle').tr(gender: widget.label),
          ],
        ),
      ),
    );
  }
}