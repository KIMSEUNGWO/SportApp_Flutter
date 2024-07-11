

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

  final int groupCount;
  final int inviteCount;
  final int likeCount;



  UserProfile.fromJson(Map<String, dynamic> json) :
    image = json['image'] == null ? null : Image.network('${ApiService.server}/images/original/profile/${json['image']}', fit: BoxFit.fill,),
    name = json['name'],
    intro = json['intro'],
    sex = json['sex'],
    birth = json['birth'],
    groupCount = json['groupCount'],
    inviteCount = json['inviteCount'],
    likeCount = json['likeCount'];

}