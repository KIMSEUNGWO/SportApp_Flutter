
import 'dart:async';
import 'dart:convert';

import 'package:flutter_sport/common/secure_strage.dart';
import 'package:flutter_sport/models/notification.dart';
import 'package:flutter_sport/models/user/profile.dart';
import 'package:http/http.dart' as http;

class ApiService {

  static const String server = "http://localhost:8080";

  static Future<List<Notifications>> getTestNotification(int count) async {
    List<Notifications> instances = [];
    for (int i = 0; i < count; ++i) {
      final noty = Notifications(id: i.toString(), date: '2024-06-27T15:00:00', thumb: 'https://phinf.pstatic.net/contact/20220724_153/1658672074422w1wxl_JPEG/IMG_8012.JPG?type=f130_130', title: '테스트제목입니다. $i');
      instances.add(noty);
    }
    return instances;
  }

  static Future<bool> login({required String userId, required String provider, required String accessToken}) async {

    final response = await http.post(Uri.parse('$server/social/login'),
        headers: {"Content-Type" : "application/json"},
        body: jsonEncode({
          "socialId" : userId,
          "provider" : provider,
          "accessToken" : accessToken
        })
    );

    if (response.statusCode == 200) {
      SecureStorage.saveAccessToken(accessToken);
      print('LINE LOGIN SUCCESS !!!');
      return true;
    } else if (response.statusCode == 400 || response.statusCode == 403 ) {
      String message = jsonDecode(response.body)['message'];
      print('ERROR : $message');
      return false;
    }
    return false;
  }

  static Future<UserProfile> getProfile() async {
    final response = await http.get(Uri.parse('$server/user/profile'),
      headers: {
        "Content-Type" : "application/json; charset=utf-8",
        ""
        "Authorization" : "Bearer ${await SecureStorage.readAccessToken()}"
      },
    );
    final decodedResponse = utf8.decode(response.bodyBytes);
    final json = jsonDecode(decodedResponse);

    return UserProfile.fromJson(json);
  }



}