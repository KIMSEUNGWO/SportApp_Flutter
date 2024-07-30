import 'package:flutter_sport/api/uri_helper.dart';
import 'package:flutter/material.dart';

class UserProfile {

  final int id;
  Image? image;
  String name;
  String? intro;
  final String sex;
  final String birth;

  int groupCount;
  int inviteCount;
  int likeCount;



  UserProfile.fromJson(Map<String, dynamic> json) :
    id = json['id'],
    image = json['image'] == null
        ? null
        : ImageHelper.parseImage(imagePath: ImagePath.ORIGINAL, imageType: ImageType.PROFILE, imageName: json['image'], fit: BoxFit.fill),
    name = json['name'],
    intro = json['intro'],
    sex = json['sex'],
    birth = json['birth'],
    groupCount = json['groupCount'],
    inviteCount = json['inviteCount'],
    likeCount = json['likeCount'];

}