

import 'dart:ui';

import 'package:flutter_sport/api/api_service.dart';
import 'package:flutter_sport/common/dateformat.dart';
import 'package:flutter/material.dart';

class UserProfile {

  Image? image;
  String name;
  String? intro;
  final String sex;
  final String birth;

  int groupCount;
  int inviteCount;
  int likeCount;



  UserProfile.fromJson(Map<String, dynamic> json) :
    image = json['data']['image'] == null ? null : Image.network('${ApiService.server}/images/original/profile/${json['data']['image']}', fit: BoxFit.fill,),
    name = json['data']['name'],
    intro = json['data']['intro'],
    sex = json['data']['sex'],
    birth = json['data']['birth'],
    groupCount = json['data']['groupCount'],
    inviteCount = json['data']['inviteCount'],
    likeCount = json['data']['likeCount'];

}