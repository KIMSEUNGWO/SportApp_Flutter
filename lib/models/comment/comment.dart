

import 'package:flutter/material.dart';
import 'package:flutter_sport/api/uri_helper.dart';
import 'package:flutter_sport/models/response_user.dart';

class Comment {

  final int? parentCommentId;
  final int commentId;
  String content;
  final DateTime createDate;
  bool isUpdate;

  final UserSimp user;

  Comment.fromJson(Map<String, dynamic> json):
    parentCommentId = json['parentCommentId'],
    commentId = json['commentId'],
    content = json['content'],
    createDate = DateTime.parse(json['createDate']),
    isUpdate = json['update'],
    user = UserSimp.fromJson(json['user']);


  // 동등성 재정의

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Comment && other.commentId == commentId;
  }

  @override
  int get hashCode => commentId.hashCode;
}