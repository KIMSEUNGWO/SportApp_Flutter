
import 'dart:async';
import 'dart:convert';

import 'package:flutter/src/services/text_input.dart';
import 'package:flutter_sport/api/api_result.dart';
import 'package:flutter_sport/common/secure_strage.dart';
import 'package:flutter_sport/models/notification.dart';
import 'package:flutter_sport/models/user/profile.dart';
import 'package:http/http.dart' as http;


class ApiService {

  static const String server = "http://localhost:8080";
  static const Map<String, String>  headers = {
    "Content-Type" : "application/json",
    "Sport-Authorization" : "NnJtQTdJcTU3SnF3N0tleDdLZXg2NmVv"
  };

  static Future<bool> _checkAccessToken() async {
    final accessToken = await SecureStorage.readAccessToken();
    if (accessToken == null) return false;
    final response = await http.get(Uri.parse('$server/accessToken'),
      headers: {
      "Content-Type" : "application/json",
      "Sport-Authorization" : "NnJtQTdJcTU3SnF3N0tleDdLZXg2NmVv",
      "Authorization" : "Bearer $accessToken"
      },
    );
    return response.statusCode == 200;
  }
  static Future<bool> _refreshingAccessToken() async {

    final refreshToken = await SecureStorage.readRefreshToken();
    if (refreshToken == null) return false;

    final response = await http.post(Uri.parse('$server/social/token'),
        headers: {
          "Authorization" : "Bearer refreshToken",
          ...headers}
    );

    final result = jsonDecode(response.body);

    if (response.statusCode == 200) {
      SecureStorage.saveAccessToken(result['accessToken']);
      SecureStorage.saveRefreshToken(result['refreshToken']);
      print('Refreshing AccessToken');
      return true;
    }
    return false;
  }

  static Future<List<Notifications>> getTestNotification(int count) async {
    List<Notifications> instances = [];
    for (int i = 0; i < count; ++i) {
      final noty = Notifications(id: i.toString(), date: '2024-06-27T15:00:00', thumb: 'https://phinf.pstatic.net/contact/20220724_153/1658672074422w1wxl_JPEG/IMG_8012.JPG?type=f130_130', title: '테스트제목입니다. $i');
      instances.add(noty);
    }
    return instances;
  }

  static Future<ResultType> login({required String userId, required String provider, required String accessToken}) async {

    final response = await http.post(Uri.parse('$server/social/login'),
        headers: headers,
        body: jsonEncode({
          "socialId" : userId,
          "provider" : provider,
          "accessToken" : accessToken
        })
    );

    final json = jsonDecode(response.body);
    ResultType resultType = ResultType.findBy(json['result']);
    if (response.statusCode == 200) {
      SecureStorage.saveAccessToken(json['data']['accessToken']);
      SecureStorage.saveRefreshToken(json['data']['accessToken']);
      print('LINE LOGIN SUCCESS !!!');
    }
    return resultType;
  }

  static Future<UserProfile?> getProfile() async {
    print('getProfile');

    final isValid = await _checkAccessToken();
    if (!isValid) {
      final refresh = await _refreshingAccessToken();
      if (!refresh) {
        return null;
      }
    }

    final response = await http.get(Uri.parse('$server/user/profile'),
      headers: {
        "Content-Type" : "application/json; charset=utf-8",
        "Sport-Authorization" : "NnJtQTdJcTU3SnF3N0tleDdLZXg2NmVv",
        "Authorization" : "Bearer ${await SecureStorage.readAccessToken()}"
      },
    );

    final decodedResponse = utf8.decode(response.bodyBytes);
    final json = jsonDecode(decodedResponse);

    if (response.statusCode == 200) {
      return UserProfile.fromJson(json);
    }
    return null;
  }

  static Future<bool> readUser() async {
    if (await _checkAccessToken()) return true;
    return await _refreshingAccessToken();
  }


  static Future<bool> editProfile({required String? profilePath, required String? nickname, required String intro }) async {
    var request = http.MultipartRequest('POST', Uri.parse('$server/user/edit'));
    request.headers.addAll({
      "Sport-Authorization" : "NnJtQTdJcTU3SnF3N0tleDdLZXg2NmVv",
      "Authorization" : "Bearer ${await SecureStorage.readAccessToken()}"
    });

    if (profilePath != null) {
      request.files.add(await http.MultipartFile.fromPath('image', profilePath));
    }
    if (nickname != null) {
      request.fields['nickName'] = nickname;
    }

    request.fields['intro'] = intro;

    final response = await request.send();
    return response.statusCode == 200;
  }

  static isDistinctNickname(String nickname) async {

    final response = await http.get(Uri.parse('$server/distinct/nickname?nickname=$nickname'),
      headers: {
      "Content-Type" : "application/json; charset=utf-8",
      "Sport-Authorization" : "NnJtQTdJcTU3SnF3N0tleDdLZXg2NmVv",
      "Authorization" : "Bearer ${await SecureStorage.readAccessToken()}"
      },
    );

    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['data'];
    }
    return false;
  }

  static Future<bool> register({required String nickname, required String? intro, required String sex, required String birth}) async {

    final response = await http.post(Uri.parse('$server/register'),
        headers: {
          "Content-Type" : "application/json; charset=utf-8",
          "Sport-Authorization" : "NnJtQTdJcTU3SnF3N0tleDdLZXg2NmVv",
          "Authorization" : "Bearer ${await SecureStorage.readAccessToken()}"
        },
      body: jsonEncode({
        "nickname" : nickname,
        "intro" : intro,
        "sex" : sex,
        "birth" : birth
      })
    );

    final json = jsonDecode(response.body);
    if (json['result'] == 'OK') {
      return true;
    }
    return false;
  }

  static registerClear() async {
    final response = await http.delete(Uri.parse('$server/register/clear'),
        headers: {
          "Content-Type" : "application/json; charset=utf-8",
          "Sport-Authorization" : "NnJtQTdJcTU3SnF3N0tleDdLZXg2NmVv",
          "Authorization" : "Bearer ${await SecureStorage.readAccessToken()}"
        },
    );
    final json = jsonDecode(response.body);

    if (response.statusCode == 200 && json['data'] == true) {
      SecureStorage.removeAllByToken();
    }
  }

}