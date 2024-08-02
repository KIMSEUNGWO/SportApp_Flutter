

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_sport/api/api_result.dart';
import 'package:flutter_sport/api/club/club_service.dart';
import 'package:flutter_sport/api/result_code.dart';
import 'package:flutter_sport/common/alert.dart';
import 'package:flutter_sport/common/navigator_helper.dart';
import 'package:flutter_sport/common/svg_icon.dart';
import 'package:flutter_sport/models/club/region_data.dart';
import 'package:flutter_sport/models/club/sport_type.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_sport/notifiers/login_notifier.dart';
import 'package:flutter_sport/widgets/pages/groupdetails/club_detail_page.dart';
import 'package:flutter_sport/widgets/pages/region_settings.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateClubWidget extends ConsumerStatefulWidget {

  final Function() clubReload;
  const CreateClubWidget({super.key, required this.clubReload});

  @override
  ConsumerState<CreateClubWidget> createState() => _CreateGroupWidgetState();
}

class _CreateGroupWidgetState extends ConsumerState<CreateClubWidget> {

  late TextEditingController _titleController;
  late TextEditingController _introController;
  late TextEditingController _personController;

  String? _titleErrorText;
  String? _introErrorText;
  String? _personErrorText;

  SportType? sportType;
  Region? region;

  selectSportType(SportType type) => setState(() => sportType = type);
  selectRegion(Region? region) => setState(() => this.region = region);

  _personError(String text) => setState(() => _personErrorText = text);
  _titleError(String text) => setState(() => _titleErrorText = text);
  _introError(String text) => setState(() => _introErrorText = text);

  _submit(BuildContext context) async {
    if (!_valid(context)) return;
    final ResponseResult result = await ClubService.of(context).clubCreate(
        sportType: sportType!,
        region: region!,
        title: _titleController.text,
        intro: _introController.text
    );

    print(result.resultCode);
    if (result.resultCode == ResultCode.OK) {
      Alert.message(context: context,
        text: Text('모임이 생성되었습니다.'),
        onPressed: () {
          Navigator.pop(context);
          ref.read(loginProvider.notifier).plusClub();
          widget.clubReload();
          NavigatorHelper.push(context, ClubDetailWidget(id: result.data));
        }
      );
    } else if (result.resultCode == ResultCode.INVALID_DATA) {
      for (var invalid in result.data) {
        if (invalid == 'sportType') _sportTypeValid();
        else if (invalid == 'region') _regionValid();
        if (invalid == 'title') _titleValid();
        if (invalid == 'intro') _introValid();
      }
    } else if (result.resultCode == ResultCode.EXCEED_LIMIT_PERSON) {
      Alert.message(context: context, text: Text('일반 그룹은 최대 10명까지 가입할 수 있습니다.'));
    }
  }

  bool _valid(BuildContext context) {
    return _sportTypeValid() && _regionValid() && _titleValid() && _introValid();
  }

  bool _sportTypeValid() {
    if (sportType == null) {
      Alert.message(context: context, text: Text('스포츠를 선택해주세요.'));
      return false;
    }
    return true;
  }

  bool _regionValid() {
    if (region == null || region == Region.ALL) {
      Alert.message(context: context, text: Text('지역을 설정해주세요.'));
      selectRegion(null);
      return false;
    }
    return true;
  }

  // bool _personValid() {
  //   final int? person = int.tryParse(_personController.text);
  //   if (person == null) {
  //     _personError('유효한 숫자를 입력해주세요.');
  //     return false;
  //   } else if (person < 3) {
  //     _personError('3명 이상으로 설정해주세요.');
  //     return false;
  //   } else if (person > 100) {
  //     _personError('200명 이하로 설정해주세요.');
  //     return false;
  //   }
  //   return true;
  // }
  bool _titleValid() {
    final title = _titleController.text;
    if (title.isEmpty) {
      _titleError('제목을 입력해주세요.');
      return false;
    } else if (title.length < 3) {
      _titleError('제목을 3자 이상 입력해주세요.');
      return false;
    } else if (title.length > 20) {
      _titleError('제목은 20자까지 가능합니다.');
      return false;
    }
    return true;
  }
  bool _introValid() {
    final intro = _introController.text;
    if (intro.length > 300) {
      _introError('소개글은 300자 까지 가능합니다.');
      return false;
    }
    return true;
  }


  @override
  void initState() {
    _titleController = TextEditingController();
    _introController = TextEditingController();
    _personController = TextEditingController();
    _personController.text = '200';
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
        title: Text('모임 생성',
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.w500
          ),
        ),
        scrolledUnderElevation: 0,
        backgroundColor: Theme.of(context).colorScheme.background,
        actions: [
          GestureDetector(
            onTap: () => _submit(context),
            child: Container(
              margin: const EdgeInsets.only(right: 20),
              child: Text('등록',
                style: TextStyle(
                  fontSize: Theme.of(context).textTheme.displayLarge!.fontSize,
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1.1
                ),
              ),
            ),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {

          final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

          return SingleChildScrollView(
            child: GestureDetector(
              onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
              child: Container(
                decoration: const BoxDecoration(),
                padding: EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 15 + keyboardHeight),
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
                            Icon(Icons.location_on, size: 25,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                            const SizedBox(width: 5,),
                            Text('지역',
                              style: TextStyle(
                                fontSize: Theme.of(context).textTheme.displayMedium!.fontSize,
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          ],
                        ),

                        GestureDetector(
                          onTap: () {
                            NavigatorHelper.push(context, RegionSettingsWidget(excludeAll: true, setRegion: selectRegion,));
                          },
                          child: Container(
                            constraints: const BoxConstraints(minWidth: 150),
                            decoration: const BoxDecoration(),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(region?.getFullName(EasyLocalization.of(context)!.locale) ?? '',
                                  style: TextStyle(
                                    fontSize: Theme.of(context).textTheme.displaySmall!.fontSize,
                                    fontWeight: FontWeight.w500,
                                    // color: Color(0xFF6B656E),
                                    color: Theme.of(context).colorScheme.tertiary
                                  ),
                                ),
                                const SizedBox(width: 10,),
                                Text(region?.getLocaleName(EasyLocalization.of(context)!.locale) ?? '',
                                  style: TextStyle(
                                    fontSize: Theme.of(context).textTheme.displayMedium!.fontSize,
                                    fontWeight: FontWeight.w500,
                                      color: Theme.of(context).colorScheme.primary
                                  ),
                                ),
                                const SizedBox(width: 10,),
                                Icon(Icons.arrow_forward_ios, size: 20,)
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 20,),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.people_alt, size: 25,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                            const SizedBox(width: 5,),
                            Text('인원 수',
                              style: TextStyle(
                                fontSize: Theme.of(context).textTheme.displayMedium!.fontSize,
                                fontWeight: FontWeight.w500
                              ),
                            ),
                            const SizedBox(width: 10,),
                            Text('(200명)',
                              style: TextStyle(
                                fontSize: Theme.of(context).textTheme.displaySmall!.fontSize,
                                color: Theme.of(context).colorScheme.secondary,
                                fontWeight: FontWeight.w500
                              ),
                            )
                          ],
                        ),
                        const SizedBox(width: 30,),
                        Expanded(
                          child: TextField(
                            controller: _personController,
                            readOnly: true,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              const CustomRangeTextInputFormatter(max: 200),
                            ],
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFD9D9D9),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: const BorderSide(
                                      color: Color(0xFFD9E7F6),
                                      width: 2
                                  ),
                                ),
                                errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: const BorderSide(
                                        color: Color(0xFFFA5252),
                                        width: 2
                                    )
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: const BorderSide(
                                        color: Color(0xFFFA5252),
                                        width: 2
                                    )
                                ),
                                errorText: _personErrorText,
                                errorStyle: const TextStyle(
                                  color: Color(0xFFFA5252),
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
                        errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(
                                color: Color(0xFFFA5252),
                                width: 2
                            )
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(
                              color: Color(0xFFFA5252),
                              width: 2
                          ),
                        ),
                        hintText: '제목을 입력해주세요.',
                        errorText: _titleErrorText,
                        errorStyle: TextStyle(
                          color: Color(0xFFFA5252),
                        ),
                      ),
                      maxLength: 20,
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
                        errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(
                                color: Color(0xFFFA5252),
                                width: 2
                            )
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(
                              color: Color(0xFFFA5252),
                              width: 2
                          ),
                        ),
                        hintText: '소개글 입력',
                        errorText: _introErrorText,
                        errorStyle: TextStyle(
                          color: Color(0xFFFA5252),
                        ),
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
        },
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
              svgIcon: SvgIcon.asset(sIcon: SIcon.soccer),
              label: 'soccer',
              sportType: SportType.SOCCER,
              target: widget.sportType,
            ),
            SelectMenu(
              select: widget.select,
              svgIcon: SvgIcon.asset(sIcon: SIcon.baseball),
              label: 'baseball',
              sportType: SportType.BASEBALL,
              target: widget.sportType,
            ),
            SelectMenu(
              select: widget.select,
              svgIcon: SvgIcon.asset(sIcon: SIcon.badminton),
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
              svgIcon: SvgIcon.asset(sIcon: SIcon.tennis),
              label: 'tennis',
              sportType: SportType.TENNIS,
              target: widget.sportType,
            ),
            SelectMenu(
              select: widget.select,
              svgIcon: SvgIcon.asset(sIcon: SIcon.basketball),
              label: 'basketball',
              sportType: SportType.BASKETBALL,
              target: widget.sportType,
            ),
            SelectMenu(
              select: widget.select,
              svgIcon: SvgIcon.asset(sIcon: SIcon.trainers),
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
  final SvgIcon svgIcon;
  final String label;
  final Function(SportType) select;
  SportType? target;

  SelectMenu({super.key, required this.sportType, required this.svgIcon, required this.label, required this.select, required this.target});

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
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: widget.sportType == widget.target 
              ? Theme.of(context).colorScheme.primaryContainer
              : Colors.white.withOpacity(0),
          borderRadius: BorderRadius.circular(10)
        ),
        width: 100,
        child: Column(
          children: [
            widget.svgIcon,
            const SizedBox(height: 10,),
            Text('sportTitle',
              style: TextStyle(
                fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w600
              ),
            ).tr(gender: widget.label),
          ],
        ),
      ),
    );
  }
}