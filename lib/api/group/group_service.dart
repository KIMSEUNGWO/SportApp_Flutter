
import 'dart:convert';

import 'package:flutter_sport/api/api_result.dart';
import 'package:flutter_sport/api/api_service.dart';
import 'package:flutter_sport/models/region_data.dart';
import 'package:flutter_sport/models/sport_type.dart';

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
}