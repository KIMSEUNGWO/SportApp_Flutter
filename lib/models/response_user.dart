
import 'package:flutter/material.dart';
import 'package:flutter_sport/api/uri_helper.dart';

class UserSimp {

  final int userId;
  final Image? thumbnailUser;
  final String nickname;

  UserSimp.fromJson(Map<String, dynamic> json):
    userId = json['userId'],
    thumbnailUser = json['thumbnailUser'] != null
        ? ImageHelper.parseImage(imagePath: ImagePath.THUMBNAIL, imageType: ImageType.PROFILE, imageName: json['thumbnailUser'], fit: BoxFit.fill,)
        : null,
    nickname = json['nickname'];
}