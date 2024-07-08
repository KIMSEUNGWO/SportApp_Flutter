

import 'package:flutter_sport/common/dateformat.dart';

class UserProfile {

  final String? image;
  final String name;
  final String sex;
  final String birth;

  final int groupCount;
  final int inviteCount;
  final int likeCount;



  UserProfile.fromJson(Map<String, dynamic> json) :
    image = json['image'],
    name = json['name'],
    sex = json['sex'],
    birth = json['birth'],
    groupCount = json['groupCount'],
    inviteCount = json['inviteCount'],
    likeCount = json['likeCount'];

}