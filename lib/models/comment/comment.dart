

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

  final List<Comment> replyComments;

  Comment.fromJson(Map<String, dynamic> json):
    parentCommentId = json['parentCommentId'],
    commentId = json['commentId'],
    content = json['content'],
    createDate = DateTime.parse(json['createDate']),

    userId = json['userId'],
    nickname = json['nickname'],
    profile = json['profile'] == null ? null
      : ImageHelper.parseImage(imagePath: ImagePath.THUMBNAIL, imageType: ImageType.PROFILE, imageName: json['profile'], fit: BoxFit.contain),
    replyComments = json['replyComments'] == null ? []
      : List<Comment>.from(
          json['replyComments'].map((json) => Comment.fromJson(json))
        );
}