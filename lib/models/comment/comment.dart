

import 'package:flutter/material.dart';
import 'package:flutter_sport/api/uri_helper.dart';

class Comment {

  final int commentId;
  final String content;
  final DateTime createDate;

  final int userId;
  final String nickname;
  final Image? profile;

  Comment.fromJson(Map<String, dynamic> json):
    commentId = json['commentId'],
    content = json['content'],
    createDate = DateTime.parse(json['createDate']),

    userId = json['userId'],
    nickname = json['nickname'],
    profile = json['profile'] == null ? null
      : ImageHelper.parseImage(imagePath: ImagePath.THUMBNAIL, imageType: ImageType.PROFILE, imageName: json['profile'], fit: BoxFit.contain);
}