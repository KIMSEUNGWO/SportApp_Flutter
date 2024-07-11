

import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_sport/api/api_service.dart';
import 'package:flutter_sport/common/image_cropper.dart';
import 'package:flutter_sport/models/user/profile.dart';
import 'package:flutter_sport/widgets/pages/profile_page.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';

import 'package:image_cropper/image_cropper.dart';


class ProfileEditPage extends StatefulWidget {

  UserProfile userProfile;
  Function(UserProfile) setProfile;

  ProfileEditPage({required this.userProfile, required this.setProfile});


  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {

  int introCurrentCount = 0;
  int introMaxCount = 30;
  String? editProfileImagePath;

  late TextEditingController _textNicknameController;
  late TextEditingController _textIntroController;

  editProfile() async {
    bool result = await ApiService.editProfile(
      profilePath: editProfileImagePath,
      nickname: _textNicknameController.text,
      intro: _textIntroController.text
    );

    if (result) {
      final response = await ApiService.getProfile();
      if (response != null) {
        widget.setProfile(response);
      }
      Navigator.pop(context);
    }


  }

  getPermission() async {

    final status = await Permission.photos.status;
    if (status.isGranted) {
      print('사진첩 허락됨');
    } else if (status.isDenied) {
      print('사진첩 거절됨');
      Permission.photos.request();
    }
  }

  selectImage() async {
    getPermission();
    final status = await Permission.photos.status;
    if (status.isGranted) {
      getImage();
    } else {
      print('권한이 없어서 못함~~~');
    }

  }

  getImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      // 선택한 이미지 경로 사용
      print('이미지 경로: ${image.path}');
      final cropper = await ImageCroppers().getCropper(image, context);
      print(cropper?.path);
      if (cropper != null) {
        setState(() {
          widget.userProfile.image = Image.file(File(cropper.path), fit: BoxFit.contain,);
          editProfileImagePath = cropper.path;
        });
      }
    }
  }

  validLengthText(String text) {
    if (text.length > introMaxCount) {
      text = text.substring(0, introMaxCount);
      _textIntroController.text = text;
    }

    setState(() {
      introCurrentCount = text.length;
    });
  }

  @override
  void initState() {
    _textNicknameController = TextEditingController();
    _textIntroController = TextEditingController(
      text: widget.userProfile.intro ?? ''
    );
    super.initState();
  }

  @override
  void dispose() {
    _textNicknameController.dispose();
    _textIntroController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text('프로필 수정'),
        actions: [
          GestureDetector(
            onTap: () => editProfile(),
            child: Container(
              margin: EdgeInsets.only(right: 20),
              child: Text('저장',
                style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w500
                ),
              ),
            ),
          ),
        ],
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                selectImage();
              },
              child: Stack(
                  children: [
                    (widget.userProfile.image == null)
                        ? EmptyProfileImage()
                        : Container(
                            width: 100, height: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                            ),
                            clipBehavior: Clip.hardEdge,
                            child: widget.userProfile.image
                          ),
                    Positioned(
                      bottom: 0, right: 0,
                      child: GestureDetector(
                        onTap: () {

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
            ),
            SizedBox(
              height: 30,
            ),
            Text('닉네임',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            TextField(
              controller: _textNicknameController,
              style: TextStyle(
                fontSize: 21,
              ),
              decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFE4E2E2), width: 1.5),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFE4E2E2), width: 1.5),
                  ),
                  hintText: widget.userProfile.name
              ),

            ),
            SizedBox(height: 30,),
            Text('자기소개',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            TextFormField(
              controller: _textIntroController,

              keyboardType: TextInputType.multiline,
              onChanged: (text) => validLengthText(text),
              maxLines: null,
              style: const TextStyle(fontSize: 17),
              decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFE4E2E2), width: 1.5),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFE4E2E2), width: 1.5),
                ),
                hintText: widget.userProfile.intro ?? '자기소개를 적어주세요.',
                counterText: '$introCurrentCount / $introMaxCount',
                counterStyle: const TextStyle(fontSize: 14),
              ),
            ),

            SizedBox(
              height: 30,
            ),

            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('성별',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 15,),
                    Container(
                      width: 150,
                      height: 65,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Color(0xFFE9F1FA),
                      ),
                      child: Flex(
                        direction: Axis.horizontal,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Container(
                              decoration: (widget.userProfile.sex == 'F') ? myBoxDecoration : youBoxDecoration ,
                              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                              child: Center(
                                child: Text('여자',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: (widget.userProfile.sex == 'F') ? myTextColor : youTextColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              decoration: (widget.userProfile.sex == 'M') ? myBoxDecoration : youBoxDecoration,
                              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                              child: Center(child: Text('남자',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: (widget.userProfile.sex == 'M') ? myTextColor : youTextColor,
                                ),
                              )),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 15,),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('생년월일',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 15,),
                      Container(
                        height: 65,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Color(0xFFE9F1FA),
                        ),
                        child: Center(
                          child: Text('${widget.userProfile.birth}',
                            style: TextStyle(
                              color: Color(0xFF3E3E3E),
                              fontSize: 18,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),

              ],
            ),

          ],
        ),
      ),
    );
  }

  BoxDecoration myBoxDecoration = BoxDecoration(
    borderRadius: BorderRadius.circular(15),
    color: Color(0xFFD2E7FE),
  );
  BoxDecoration youBoxDecoration = BoxDecoration(
    borderRadius: BorderRadius.circular(15),
  );

  Color myTextColor = Color(0xFF3E3E3E);
  Color youTextColor = Color(0xFF7E7E7E);
}
