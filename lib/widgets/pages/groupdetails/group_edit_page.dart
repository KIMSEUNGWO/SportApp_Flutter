
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sport/api/api_result.dart';
import 'package:flutter_sport/api/group/club_service.dart';
import 'package:flutter_sport/common/alert.dart';
import 'package:flutter_sport/common/image.dart';
import 'package:flutter_sport/models/club/club_data.dart';
import 'package:flutter_sport/models/club/region_data.dart';
import 'package:flutter_sport/models/club/sport_type.dart';
import 'package:flutter_sport/notifiers/login_notifier.dart';
import 'package:flutter_sport/widgets/pages/create_group_page.dart';
import 'package:flutter_sport/widgets/pages/groupdetails/group_detail_page.dart';
import 'package:flutter_sport/widgets/pages/region_settings.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ClubEditWidget extends ConsumerStatefulWidget {

  final ClubDetail club;
  final Function() reload;

  const ClubEditWidget({super.key, required this.club, required this.reload});

  @override
  ConsumerState<ClubEditWidget> createState() => _ClubEditWidgetState();
}

class _ClubEditWidgetState extends ConsumerState<ClubEditWidget> {

  late TextEditingController _titleController;
  late TextEditingController _introController;
  late TextEditingController _personController;

  String? _titleErrorText;
  String? _introErrorText;
  String? _personErrorText;

  String? editProfileImagePath;
  Image? editImage;

  SportType? sportType;
  Region? region;

  selectSportType(SportType type) => setState(() => sportType = type);
  selectRegion(Region? region) => setState(() => this.region = region);

  _personError(String text) => setState(() => _personErrorText = text);
  _titleError(String text) => setState(() => _titleErrorText = text);
  _introError(String text) => setState(() => _introErrorText = text);

  _submit(BuildContext context) async {
    if (!_valid(context)) return;
    final ResponseResult result = await ClubService.clubEdit(
      clubId: widget.club.id,
      image: editProfileImagePath,
      sportType: sportType != widget.club.sport ? sportType : null,
      region: region != widget.club.region ? region : null,
      title: _titleController.text.isEmpty ? null : _titleController.text,
      intro: _introController.text.isEmpty ? null : _introController.text,
    );

    if (result.resultCode == ResultCode.OK) {
      Alert.message(context: context,
          text: Text('설정이 변경되었습니다.'),
          onPressed: () {
            Navigator.pop(context);
            widget.reload();
          }
      );
    } else if (result.resultCode == ResultCode.INVALID_DATA) {
      for (var invalid in result.data) {
        if (invalid == 'sportType') _sportTypeValid();
        else if (invalid == 'region') _regionValid();
        if (invalid == 'title') _titleValid();
        if (invalid == 'intro') _introValid();
      }
    } else if (result.resultCode == ResultCode.CLUB_NOT_OWNER) {
      Alert.message(context: context, text: Text('모임장만 변경할 수 있습니다,'),
        onPressed: () => Navigator.pop(context),
      );

    } else if (result.resultCode == ResultCode.EXCEED_LIMIT_PERSON) {
      print('EXCEED_LIMIT_PERSON');
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
  //   if (person == null) return true;
  //
  //   if (person < 3) {
  //     _personError('3명 이상으로 설정해주세요.');
  //     return false;
  //   } else if (person > 100) {
  //     _personError('100명 이하로 설정해주세요.');
  //     return false;
  //   } else if (person < widget.club.personCount) {
  //     _personError('현재 인원보다 적게 설정할 수 없습니다.');
  //   }
  //   return true;
  // }
  bool _titleValid() {
    final title = _titleController.text;
    if (title.isEmpty) {
      return true;
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

  selectImage() async {
    final image = await ImagePick().get();
    if (image != null) {
      setState(() {
        editImage = Image.file(File(image.path), fit: BoxFit.fill,);
        editProfileImagePath = image.path;
      });
    }
  }


  @override
  void initState() {
    _titleController = TextEditingController();
    _introController = TextEditingController();
    _personController = TextEditingController();
    editImage = widget.club.image;
    sportType = widget.club.sport;
    region = widget.club.region;
    if (widget.club.intro != null) _introController.text = widget.club.intro!;
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
        title: Text('모임 수정'),
        scrolledUnderElevation: 0,
        actions: [
          GestureDetector(
            onTap: () => _submit(context),
            child: Container(
              margin: EdgeInsets.only(right: 20),
              child: Text('등록',
                style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w500
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
              child: Column(
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        decoration: editImage == null ? const BoxDecoration(color: Color(0xFFF1F1F5)) : const BoxDecoration(),
                        width: double.infinity,
                        height: 200,
                        child: editImage ?? Center(
                          child: SvgPicture.asset('assets/icons/emptyGroupImage.svg',
                            width: 40, height: 40, color: Color(0xFF878181),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: -20, right: 20,
                        child: GestureDetector(
                          onTap: () {
                            print('??');
                            selectImage();
                          },
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: Colors.black,
                            ),
                            child: Icon(Icons.camera_alt,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ]
                  ),
                  Container(
                    decoration: const BoxDecoration(),
                    padding: EdgeInsets.only(left: 20, right: 20, top: 30, bottom: 15 + keyboardHeight),
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
                              child: Container(
                                constraints: const BoxConstraints(minWidth: 150),
                                decoration: const BoxDecoration(),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(region?.getFullName(EasyLocalization.of(context)!.locale) ?? '',
                                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: Color(0xFF6B656E),),
                                    ),
                                    SizedBox(width: 5,),
                                    Text(region?.getLocaleName(EasyLocalization.of(context)!.locale) ?? '',
                                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                                    ),
                                    SizedBox(width: 20,),
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
                                Icon(Icons.people_alt, size: 25,),
                                const SizedBox(width: 5,),
                                Text('인원 수',
                                  style: TextStyle(
                                      fontSize: 17
                                  ),
                                ),
                                const SizedBox(width: 10,),
                                Text('(200명)')
                              ],
                            ),
                            SizedBox(width: 30,),
                            Expanded(
                              child: TextField(
                                controller: _personController,
                                keyboardType: TextInputType.number,
                                readOnly: true,
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
                                      )
                                  ),
                                  errorText: _personErrorText,
                                  errorStyle: TextStyle(
                                    color: Color(0xFFFA5252),
                                  ),
                                  hintText: widget.club.maxPerson.toString()
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
                            hintText: widget.club.title,
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
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
