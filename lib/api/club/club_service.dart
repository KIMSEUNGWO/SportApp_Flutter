
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sport/api/api_result.dart';
import 'package:flutter_sport/api/api_service.dart';
import 'package:flutter_sport/api/error_handler/club_path_data.dart';
import 'package:flutter_sport/api/error_handler/error_handler.dart';
import 'package:flutter_sport/api/method_type.dart';
import 'package:flutter_sport/api/result_code.dart';
import 'package:flutter_sport/common/alert.dart';
import 'package:flutter_sport/models/club/club_data.dart';
import 'package:flutter_sport/models/club/region_data.dart';
import 'package:flutter_sport/models/club/sport_type.dart';

import 'package:flutter_sport/models/user/club_member.dart';
import 'package:go_router/go_router.dart';

class ClubService {

  static _ClubProvider of(BuildContext context) => _ClubProvider(context);

}

class _ClubProvider {

  final ClubError clubError;

  _ClubProvider(BuildContext context): clubError = ClubError(context);

  Future<ClubDetail?> clubData({required BuildContext context, required int clubId}) async {
    ResponseResult response = await ApiService.get(
      uri: '/public/club/$clubId',
      authorization: true,
    );
    await clubError.defaultErrorHandle(response, ClubPath(clubId: clubId));
    return ClubDetail.fromJson(response.data);
  }

  Future<ResponseResult?> clubEdit({
    required String? image, required SportType? sportType, required Region? region,
    required String? title, required String? intro, required int clubId,}) async {

    final response = await ApiService.multipart('/club/$clubId',
      method: MethodType.PATCH,
      multipartFilePath: image,
      data: {
        'image' : image,
        'sportType' : sportType?.name,
        'region' : region?.name,
        'title' : title,
        'intro' : intro,
      },
    );

    clubError.defaultErrorHandle(response, ClubPath(clubId: clubId));
    return response;

  }

  Future<List<ClubSimp>> getMyClubs() async {

    ResponseResult response = await ApiService.get(
      uri: '/user/clubs',
      authorization: true,
    );
    clubError.defaultErrorHandle(response, ClubPath());
    return _getClubSimp(response);
  }
  Future<ResponseResult?> joinClub({required int clubId}) async {

    ResponseResult response = await ApiService.post(
        uri: '/club/$clubId',
        authorization: true,
    );
    clubError.defaultErrorHandle(response, ClubPath(clubId: clubId));
    return response;
  }

  Future<ResponseResult> clubCreate({required SportType sportType, required Region region, required String title, required String? intro}) async {

    final response = await ApiService.post(
        uri : '/club',
        authorization: true,
        header: {
          "Content-Type" : "application/json",
        },
        body: jsonEncode({
          "sportType" : sportType.name,
          "region" : region.name,
          "title" : title,
          "intro" : intro,
        })
    );
    clubError.defaultErrorHandle(response, ClubPath());
    return response;
  }

  Future<List<ClubUser>> getClubUsers({required int clubId}) async {

    ResponseResult response = await ApiService.get(uri: '/public/club/$clubId/users', authorization: false);
    clubError.defaultErrorHandle(response, ClubPath(clubId: clubId));

    if (response.resultCode != ResultCode.OK) return [];
    List<ClubUser> list = [];
    for (var data in response.data) {
      ClubUser clubUser = ClubUser.fromJson(data);
      list.add(clubUser);
    }
    return list;
  }


  List<ClubSimp> _getClubSimp(ResponseResult response) {
    List<ClubSimp> result = [];

    if (response.resultCode == ResultCode.OK) {
      for (var data in response.data) {
        result.add(ClubSimp.fromJson(data));
      }
    }
    return result;
  }

  Future<ResponseResult> exitClub({required int clubId}) async {

    ResponseResult response = await ApiService.delete(
      uri: '/club/$clubId/exit',
      authorization: true,
    );

    clubError.defaultErrorHandle(response, ClubPath(clubId: clubId));
    return response;
  }


}

class ClubError extends ErrorHandler {

  final BuildContext context;

  ClubError(this.context);


  @override
  Future<bool> defaultErrorHandle(ResponseResult response, ClubPath clubPath) async {
    if (context.mounted) {
      if (response.resultCode == ResultCode.CLUB_NOT_EXISTS) {
        Alert.message(context: context, text: Text('존재하지 않는 모임입니다.'),
          onPressed: () {
            context.go('/');
          }
        );
        return false;
      }
    }

    return true;
  }

}