

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_sport/models/club/authority.dart';

class ClubUser {

  final int userId;
  final Image? thumbnail;
  final String nickname;
  final Authority authority;

  ClubUser.fromJson(Map<String, dynamic> json):
    userId = json['userId'],
    thumbnail = json['thumbnail'] == null ? null : Image.network(json['thumbnail'], fit: BoxFit.fill,),
    nickname = json['nickname'],
    authority = Authority.valueOf(json['authority'])!;

}