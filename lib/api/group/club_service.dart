
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_sport/api/api_result.dart';
import 'package:flutter_sport/api/api_service.dart';
import 'package:flutter_sport/common/local_storage.dart';
import 'package:flutter_sport/models/alert.dart';
import 'package:flutter_sport/models/club/club_data.dart';
import 'package:flutter_sport/models/club/region_data.dart';
import 'package:flutter_sport/models/club/sport_type.dart';

import 'package:flutter_sport/common/secure_strage.dart';

class ClubService {

  static final String _club = '/club';

  static Future<ResponseResult> clubCreate({
          required SportType sportType,
          required Region region,
          required int limitPerson,
          required String title,
          required String? intro}) async {

    return await ApiService.post(
      uri : '${ApiService.server}$_club/create',
      header: {
        "Content-Type" : "application/json",
        "Authorization" : "Bearer ${await SecureStorage.readAccessToken()}"
      },
      body: jsonEncode({
        "sportType" : sportType.name,
        "region" : region.name,
        "title" : title,
        "intro" : intro,
        "limitPerson" : limitPerson
      })
    );
  }

  static Future<ClubDetail> clubData({required BuildContext context, required int clubId}) async {
    ResponseResult response = await ApiService.get(
      uri: '${ApiService.server}$_club/$clubId',
      header : {
        "Authorization" : "Bearer ${await SecureStorage.readAccessToken()}"
      }
    );

    if (response.resultCode == ResultCode.CLUB_NOT_EXISTS) {
      Alert.message(context: context, text: Text('존재하지 않는 모임입니다.'), onPressed: () {
        Navigator.pop(context);
      });
    }
    print(json);
    return ClubDetail.fromJson(response.data);
  }

  static Future<List<ClubSimp>> getRecentlyViewClubs() async {
    // List<String> clubs = await LocalStorage.getRecentlyViewClubList();
    List<String> clubs = ['1'];

    String queryString = clubs.map((clubId) => 'clubs=$clubId').join('&');
    ResponseResult response = await ApiService.get(
        uri: '${ApiService.server}?$queryString',
        header : {
          "Authorization" : "Bearer ${await SecureStorage.readAccessToken()}"
        }
    );
    List<ClubSimp> result = [];

    if (response.resultCode == ResultCode.OK) {
      for (var data in response.data) {
        result.add(ClubSimp.fromJson(data));
      }
    }

    return result;
  }
}