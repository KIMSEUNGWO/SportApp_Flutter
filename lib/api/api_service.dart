
import 'dart:async';
import 'dart:convert';

import 'package:flutter_sport/api/api_result.dart';
import 'package:flutter_sport/api/social_result.dart';
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
  static const Map<String, String> defaultHeader = {"Sport-Authorization" : "NnJtQTdJcTU3SnF3N0tleDdLZXg2NmVv"};


  static ResponseResult _decode(http.Response response) {
    final json = jsonDecode(utf8.decode(response.bodyBytes));
    return ResponseResult.fromJson(json);
  }
  static Future<ResponseResult> post({required String uri, Map<String, String>? header, Object? body}) async {

    Map<String, String> requestHeader = {};
    requestHeader.addAll(defaultHeader);
    if (header != null) requestHeader.addAll(header);

    final response = await http.post(Uri.parse('$server$uri'), headers: requestHeader, body: body);
    return _decode(response);
  }

  static Future<ResponseResult> get({required String uri, Map<String, String>? header}) async {
    Map<String, String> requestHeader = {
      "Content-Type" : "application/json; charset=utf-8",
      "Sport-Authorization" : "NnJtQTdJcTU3SnF3N0tleDdLZXg2NmVv"
    };
    if (header != null) requestHeader.addAll(header);

    final response = await http.get(Uri.parse('$server$uri'), headers: requestHeader);
    return _decode(response);
  }

  static Future<ResponseResult> postMultipart(String uri, {required String? multipartFilePath, required Map<String, dynamic> data}) async {
    var request = http.MultipartRequest('POST', Uri.parse('$server$uri'));
    request.headers.addAll({
      "Sport-Authorization" : "NnJtQTdJcTU3SnF3N0tleDdLZXg2NmVv",
      "Authorization" : "Bearer ${await SecureStorage.readAccessToken()}",
      "Content-Type": "application/json; charset=UTF-8"
    });

    if (multipartFilePath != null) {
      request.files.add(await http.MultipartFile.fromPath('image', multipartFilePath));
    }

    for (String key in data.keys) {
      if (data[key] == null) continue;
      request.fields[key] = data[key];
    }

    final response = await request.send();
    final responseBody = await response.stream.bytesToString();
    final json = jsonDecode(responseBody);
    return ResponseResult.fromJson(json);
}

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
          "Authorization" : "Bearer $refreshToken",
          ...headers}
    );

    final result = jsonDecode(response.body);

    if (response.statusCode == 200) {
      await SecureStorage.saveAccessToken(result['accessToken']);
      await SecureStorage.saveRefreshToken(result['refreshToken']);
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

  static Future<ResultCode> login(SocialResult result) async {
    final response = await http.post(Uri.parse('$server/social/login',),
        headers: headers,
        body: jsonEncode({
          "socialId" : result.socialId,
          "provider" : result.provider.name,
          "accessToken" : result.accessToken
        })
    );

    final json = jsonDecode(response.body);
    ResultCode resultType = ResultCode.valueOf(json['result']);
    if (resultType == ResultCode.OK) {
      await SecureStorage.saveAccessToken(json['data']['accessToken']);
      await SecureStorage.saveRefreshToken(json['data']['refreshToken']);
      print('LINE LOGIN SUCCESS !!!');
    }
    return resultType;
  }

  static Future<UserProfile?> getProfile() async {
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
    return (await _checkAccessToken() || await _refreshingAccessToken());
  }

  static isDistinctNickname(String nickname) async {

    final response = await http.get(Uri.parse('$server/distinct/nickname?nickname=$nickname'),
      headers: {
      "Content-Type" : "application/json; charset=utf-8",
      "Sport-Authorization" : "NnJtQTdJcTU3SnF3N0tleDdLZXg2NmVv",
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['data'];
    }
    return false;
  }

  static Future<ResultCode> register({required String nickname, required String? intro, required String sex, required String birth, required SocialResult social}) async {

    final response = await http.post(Uri.parse('$server/register'),
        headers: {
          "Content-Type" : "application/json; charset=utf-8",
          "Sport-Authorization" : "NnJtQTdJcTU3SnF3N0tleDdLZXg2NmVv",
        },
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

    final json = jsonDecode(response.body);
    ResultCode resultType = ResultCode.valueOf(json['result']);
    if (resultType == ResultCode.OK) {
      await SecureStorage.saveAccessToken(json['data']['accessToken']);
      await SecureStorage.saveRefreshToken(json['data']['refreshToken']);
      print('REGISTER SUCCESS !!!');
    }
    return resultType;
  }

}