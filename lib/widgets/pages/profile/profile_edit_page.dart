import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sport/api/api_result.dart';
import 'package:flutter_sport/api/api_service.dart';
import 'package:flutter_sport/api/method_type.dart';
import 'package:flutter_sport/api/result_code.dart';
import 'package:flutter_sport/common/image.dart';
import 'package:flutter_sport/common/alert.dart';
import 'package:flutter_sport/notifiers/login_notifier.dart';
import 'package:flutter_sport/widgets/pages/profile/profile_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:easy_localization/easy_localization.dart';


class ProfileEditPage extends ConsumerStatefulWidget {

  const ProfileEditPage({super.key});

  @override
  ConsumerState<ProfileEditPage> createState() => _ProfileEditPageState();


}

class _ProfileEditPageState extends ConsumerState<ProfileEditPage> {

  int introCurrentCount = 0;
  int introMaxCount = 30;
  String? editProfileImagePath;
  late Image? editImage;

  late TextEditingController _textNicknameController;
  late TextEditingController _textIntroController;

  editProfile(BuildContext context) async {
    Map<String, dynamic> data = {};
    String nickname = _textNicknameController.text;
    if (nickname.isNotEmpty) {
      data.addAll({'nickname' : nickname});
    }
    data.addAll({'intro' : _textIntroController.text});


    ResponseResult responseResult = await ApiService.multipart('/user/edit', method: MethodType.POST, multipartFilePath: editProfileImagePath, data: data);

    if (responseResult.resultCode == ResultCode.OK) {
      final response = await ApiService.getProfile();
      if (response != null) {
        ref.watch(loginProvider.notifier).setProfile(response);
      }
      Navigator.pop(context);
      return;
    } else if (responseResult.resultCode == ResultCode.MAX_UPLOAD_SIZE_EXCEED) {
      setState(() {
        editImage = ref.read(loginProvider.notifier).state?.image;
      });
      Alert.message(context: context, text: Text('이미지 용량이 초과되었습니다.'));
    }


  }

  selectImage() async {
    final cropper = await ImagePick().getAndCrop(context);
    if (cropper != null) {
      setState(() {
        editImage = Image.file(File(cropper.path), fit: BoxFit.contain,);
        editProfileImagePath = cropper.path;
      });
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
      text: ref.read(loginProvider.notifier).state!.intro ?? ''
    );
    editImage = ref.read(loginProvider.notifier).state!.image;
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
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Theme.of(context).colorScheme.background,
        title: Text('profile').tr(gender: 'editProfile'),
        scrolledUnderElevation: 0,
        actions: [
          GestureDetector(
            onTap: () => editProfile(context),
            child: Container(
              margin: EdgeInsets.only(right: 20),
              child: Text('save',
                style: TextStyle(
                  fontSize: Theme.of(context).textTheme.displayLarge!.fontSize,
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ).tr(),
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
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                padding: EdgeInsets.only(bottom: keyboardHeight),
                decoration: const BoxDecoration(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        selectImage();
                      },
                      child: Stack(
                          children: [
                            (editImage == null)
                                ? EmptyProfileImage()
                                : Container(
                                width: 100, height: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                clipBehavior: Clip.hardEdge,
                                child: editImage
                            ),
                            Positioned(
                              bottom: 0, right: 0,
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
                          ]
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text('user',
                      style: TextStyle(
                        fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).colorScheme.primary
                      ),
                    ).tr(gender: 'nickname'),
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
                          hintText: ref.read(loginProvider.notifier).state!.name
                      ),

                    ),
                    SizedBox(height: 30,),
                    Text('user',
                      style: TextStyle(
                        fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).colorScheme.primary
                      ),
                    ).tr(gender: 'introduce'),
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
                        hintText: ref.read(loginProvider.notifier).state!.intro ?? '자기소개를 적어주세요.',
                        counterText: '$introCurrentCount / $introMaxCount',
                        counterStyle: const TextStyle(fontSize: 14),
                      ),
                    ),

                    SizedBox(
                      height: 10,
                    ),

                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('user',
                              style: TextStyle(
                                fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
                                fontWeight: FontWeight.w700,
                                color: Theme.of(context).colorScheme.primary
                              ),
                            ).tr(gender: 'sex'),
                            SizedBox(height: 15,),
                            Container(
                              width: 150,
                              height: 55,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                // color: Color(0xFFE9F1FA),
                                // color: Color(0xFFE6E6E6),
                                color: Theme.of(context).colorScheme.secondaryContainer
                              ),
                              child: Flex(
                                direction: Axis.horizontal,
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      margin: EdgeInsets.all(5),
                                      decoration: (ref.read(loginProvider.notifier).state!.sex == 'F') ? myBoxDecoration(context) : youBoxDecoration(context) ,
                                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                                      child: Center(
                                        child: Text('female',
                                          style: TextStyle(
                                            fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
                                            fontWeight: FontWeight.w600,
                                            color: (ref.read(loginProvider.notifier).state!.sex == 'F') ? myTextColor : youTextColor,
                                          ),
                                        ).tr(),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      margin: EdgeInsets.all(5),
                                      decoration: (ref.read(loginProvider.notifier).state!.sex == 'M') ? myBoxDecoration(context) : youBoxDecoration(context),
                                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                                      child: Center(
                                          child: Text('male',
                                            style: TextStyle(
                                              fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
                                              fontWeight: FontWeight.w600,
                                              color: (ref.read(loginProvider.notifier).state!.sex == 'M') ? myTextColor : youTextColor,
                                            ),
                                          ).tr()
                                      ),
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
                              Text('user',
                                style: TextStyle(
                                  fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
                                  fontWeight: FontWeight.w700,
                                  color: Theme.of(context).colorScheme.primary
                                ),
                              ).tr(gender: 'birthday'),
                              SizedBox(height: 15,),
                              Container(
                                height: 55,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  // color: Color(0xFFE9F1FA),
                                  // color: Color(0xFFE6E6E6),
                                  color: Theme.of(context).colorScheme.secondaryContainer
                                ),
                                child: Center(
                                  child: Text('${ref.read(loginProvider.notifier).state!.birth}',
                                    style: TextStyle(
                                      // color: Color(0xFF3E3E3E),
                                      // fontSize: 18,
                                      color: Theme.of(context).colorScheme.secondary,
                                      fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
                                      fontWeight: FontWeight.w500
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
            ),
          );
        },
      ),
    );
  }


  BoxDecoration myBoxDecoration(BuildContext context) {
    return BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        // color: Color(0xFFD2E7FE),
        // color: Color(0xFFFFFFFF),
        color: Theme.of(context).colorScheme.tertiary
    );
  }
  BoxDecoration youBoxDecoration(BuildContext context) {
    return BoxDecoration(
        borderRadius: BorderRadius.circular(10),
    );
  }

  // Color myTextColor = Color(0xFF3E3E3E);
  // Color youTextColor = Color(0xFF7E7E7E);
  Color myTextColor = Color(0xFF000000);
  Color youTextColor = Color(0xFF959595);
}

