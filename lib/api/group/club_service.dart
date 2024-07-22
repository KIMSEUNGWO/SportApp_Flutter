
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sport/api/api_result.dart';
import 'package:flutter_sport/api/api_service.dart';
import 'package:flutter_sport/common/local_storage.dart';
import 'package:flutter_sport/common/alert.dart';
import 'package:flutter_sport/models/club/club_data.dart';
import 'package:flutter_sport/models/club/region_data.dart';
import 'package:flutter_sport/models/club/sport_type.dart';

import 'package:flutter_sport/common/secure_strage.dart';
import 'package:flutter_sport/models/user/club_member.dart';

class ClubService {

  static Future<ResponseResult> clubCreate({
          required SportType sportType,
          required Region region,
          required String title,
          required String? intro}) async {

    return await ApiService.post(
      uri : '/club/create',
      header: {
        "Content-Type" : "application/json",
        "Authorization" : "Bearer ${await SecureStorage.readAccessToken()}"
      },
      body: jsonEncode({
        "sportType" : sportType.name,
        "region" : region.name,
        "title" : title,
        "intro" : intro,
      })
    );
  }

  static bool isClubExists(ResponseResult response, BuildContext context) {
    if (response.resultCode == ResultCode.CLUB_NOT_EXISTS) {
      Future.delayed(const Duration(milliseconds: 300));
      Navigator.pop(context);
      Alert.message(context: context, text: Text('존재하지 않는 모임입니다.'));
      return false;
    }
    return true;
  }

  static Future<ClubDetail?> clubData({required BuildContext context, required int clubId}) async {
    ResponseResult response = await ApiService.get(
      uri: '/club/$clubId',
      header : {
        "Authorization" : "Bearer ${await SecureStorage.readAccessToken()}"
      }
    );
    if (!isClubExists(response, context)) return null;

    return ClubDetail.fromJson(response.data);
  }

  static Future<List<ClubSimp>> getRecentlyViewClubs() async {
    // List<String> clubs = await LocalStorage.getRecentlyViewClubList();
    List<String> clubs = ['1'];

    String queryString = clubs.map((clubId) => 'clubs=$clubId').join('&');
    ResponseResult response = await ApiService.get(
        uri: '?$queryString',
        header : {
          "Authorization" : "Bearer ${await SecureStorage.readAccessToken()}"
        }
    );
    return _getClubSimp(response);
  }

  static List<ClubSimp> _getClubSimp(ResponseResult response) {
    List<ClubSimp> result = [];

    if (response.resultCode == ResultCode.OK) {
      for (var data in response.data) {
        result.add(ClubSimp.fromJson(data));
      }
    }
    return result;
  }

  static Future<List<ClubSimp>> getMyClubs() async {

    ResponseResult response = await ApiService.get(
      uri: '/user/clubs',
      header: {
        "Authorization" : "Bearer ${await SecureStorage.readAccessToken()}"
      }
    );

    return _getClubSimp(response);
  }

  static Future<ResponseResult?> joinClub({required int clubId, required BuildContext context}) async {

    ResponseResult response = await ApiService.post(
        uri: '/club/$clubId/join',
        header: {
          "Authorization" : "Bearer ${await SecureStorage.readAccessToken()}"
        }
    );
    if (!isClubExists(response, context)) {
      return null;
    }
    return response;
  }

  static Future<ResponseResult?> clubEdit({
    required String? image,
    required SportType? sportType,
    required Region? region,
    required String? title,
    required String? intro,
    required int clubId,
    required BuildContext context
  }) async {

    final response = await ApiService.postMultipart('/club/$clubId/edit',
      multipartFilePath: image,
      data: {
        'image' : image,
        'sportType' : sportType?.name,
        'region' : region?.name,
        'title' : title,
        'intro' : intro,
      },
    );

    if (!isClubExists(response, context)) return null;
    return response;

  }

  static Future<List<ClubUser>> getClubUsers({required int clubId}) async {

    ResponseResult response = await ApiService.get(uri: '/club/$clubId/users');
    if (response.resultCode != ResultCode.OK) return [];

    List<ClubUser> list = [];
    for (var data in response.data) {
      ClubUser clubUser = ClubUser.fromJson(data);
      list.add(clubUser);
    }
    return list;
  }
}