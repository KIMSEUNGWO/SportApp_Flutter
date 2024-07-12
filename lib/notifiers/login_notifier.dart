import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sport/api/api_result.dart';
import 'package:flutter_sport/api/api_service.dart';
import 'package:flutter_sport/api/line_api.dart';
import 'package:flutter_sport/models/user/profile.dart';



class UserNotifier extends StateNotifier<UserProfile?> {
  UserNotifier() : super(null);

  void setProfile(UserProfile newProfile) {
    state = newProfile;
  }

  Future<ResultType> login() async {
    final result = await LineAPI.login();
    if (result == ResultType.OK) {
      state = await ApiService.getProfile();
    }
    return result;
  }

  Future<bool> register({required String nickname, required String? intro, required String sex, required String birth}) async {
    final response = await ApiService.register(
        nickname: nickname,
        intro: intro,
        sex: sex,
        birth: birth
    );
    if (response) {
      readUser();
      return true;
    }
    return false;
  }

  void logout() async {
    LineAPI.logout();
    state = null;
  }

  void readUser() async {
    final result = await ApiService.readUser();
    if (result) {
      state = await ApiService.getProfile();
    } else {
      logout();
    }
  }

}

final loginProvider = StateNotifierProvider<UserNotifier, UserProfile?>((ref) => UserNotifier(),);