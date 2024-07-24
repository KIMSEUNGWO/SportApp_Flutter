

import 'package:flutter/material.dart';
import 'package:flutter_sport/api/uri_helper.dart';

class Comment {

  final int? parentCommentId;
  final int commentId;
  final String content;
  final DateTime createDate;

  final int userId;
  final String nickname;
  final Image? profile;

  Comment.fromJson(Map<String, dynamic> json):
    parentCommentId = json['parentCommentId'],
    commentId = json['commentId'],
    content = json['content'],
    createDate = DateTime.parse(json['createDate']),

    userId = json['userId'],
    nickname = json['nickname'],
    profile = json['profile'] == null ? null
      : ImageHelper.parseImage(imagePath: ImagePath.THUMBNAIL, imageType: ImageType.PROFILE, imageName: json['profile'], fit: BoxFit.contain);


  // 동등성 재정의

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Comment && other.commentId == commentId;
  }

  @override
  int get hashCode => commentId.hashCode;
}