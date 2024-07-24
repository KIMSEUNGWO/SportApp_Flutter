import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sport/api/api_result.dart';
import 'package:flutter_sport/api/api_service.dart';
import 'package:flutter_sport/api/line_api.dart';
import 'package:flutter_sport/api/social_result.dart';
import 'package:flutter_sport/models/user/profile.dart';
import 'package:flutter_sport/widgets/pages/register_page.dart';



class UserNotifier extends StateNotifier<UserProfile?> {
  UserNotifier() : super(null);

  void setProfile(UserProfile newProfile) {
    state = newProfile;
  }

  Future<ResultCode> login(BuildContext context, {required Function(bool isLoading) loading}) async {
    final socialResult = await LineAPI.login();
    if (socialResult == null) {
      state = null;
      return ResultCode.SOCIAL_LOGIN_FAILD;
    }
    loading(true);
    final result = await ApiService.login(socialResult);
    if (result == ResultCode.OK) {
      readUser();
      Navigator.pop(context);
    } else if (result == ResultCode.REGISTER) {
      Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterWidget(socialResult)));
    }
    return result;
  }

  Future<bool> register({required String nickname, required String? intro, required String sex, required String birth, required SocialResult social}) async {
    final response = await ApiService.register(
      nickname: nickname,
      intro: intro,
      sex: sex,
      birth: birth,
      social: social,
    );
    if (response == ResultCode.OK) {
      readUser();
      return true;
    }
    return false;
  }

  void logout() async {
    LineAPI.logout();
    state = null;
  }

  bool has() {
    return state != null;
  }

  readUser() async {
    final result = await ApiService.readUser();
    if (result) {
      state = await ApiService.getProfile();
    } else {
      logout();
    }
  }

  void plusClub() {
    state?.groupCount++;
  }
  void minusClub() {
    if (state == null) return;
    state!.groupCount = max(0, state!.groupCount - 1);
  }

  int? getId() {
    return state?.id;
  }

}

final loginProvider = StateNotifierProvider<UserNotifier, UserProfile?>((ref) => UserNotifier(),);