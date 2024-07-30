

import 'dart:convert';

import 'package:flutter_sport/api/api_service.dart';
import 'package:flutter_sport/api/result_code.dart';
import 'package:flutter_sport/api/social_result.dart';
import 'package:flutter_sport/common/secure_strage.dart';
import 'package:flutter_sport/models/user/profile.dart';

class UserService {

  static Future<ResultCode> login(SocialResult result) async {
    final response = await ApiService.post(
      uri: '/social/login',
      authorization: false,
      header: ApiService.contentTypeJson,
      body: jsonEncode({
        "socialId" : result.socialId,
        "provider" : result.provider.name,
        "accessToken" : result.accessToken
      }),
    );

    if (response.resultCode == ResultCode.OK) {
      await SecureStorage.saveAccessToken(response.data['accessToken']);
      await SecureStorage.saveRefreshToken(response.data['refreshToken']);
      print('LINE LOGIN SUCCESS !!!');
    }
    return response.resultCode;
  }

  static Future<UserProfile?> getProfile() async {

    final response = await ApiService.get(
      uri: '/user/profile',
      authorization: true,
    );

    if (response.resultCode == ResultCode.OK) {
      return UserProfile.fromJson(response.data);
    }
    return null;
  }

  static isDistinctNickname(String nickname) async {

    final response = await ApiService.get(
      uri: '/distinct/nickname?nickname=$nickname',
      authorization: false,
    );

    if (response.resultCode == ResultCode.OK) {
      return response.data;
    }
    return false;
  }

  static Future<ResultCode> register({required String nickname, required String? intro, required String sex, required String birth, required SocialResult social}) async {

    final response = await ApiService.post(
      uri: '/register',
      authorization: false,
      header: ApiService.contentTypeJson,
      body: jsonEncode({
        "nickname" : nickname,
        "intro" : intro,
        "sex" : sex,
        "birth" : birth,
        "socialId" : social.socialId,
        "provider" : social.provider.name,
        "accessToken" : social.accessToken
      })
    );

    if (response.resultCode == ResultCode.OK) {
      await SecureStorage.saveAccessToken(response.data['accessToken']);
      await SecureStorage.saveRefreshToken(response.data['refreshToken']);
      print('REGISTER SUCCESS !!!');
    }
    return response.resultCode;
  }

}