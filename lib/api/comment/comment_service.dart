
import 'dart:convert';

import 'package:flutter_sport/api/api_result.dart';
import 'package:flutter_sport/api/api_service.dart';
import 'package:flutter_sport/common/secure_strage.dart';

class CommentService {
  static Future<ResponseResult> getComments({required int clubId, required int boardId}) async {
    return await ApiService.get(uri: '/club/$clubId/board/$boardId/comment',
      header: {
        "Authorization" : "Bearer ${await SecureStorage.readAccessToken()}",
      }
    );
  }

  static Future<ResponseResult> sendComment({required int? parentId, required String comment, required int clubId, required int boardId}) async {
    Map<String, String> body = {"comment" : comment};
    if (parentId != null) {
      body.addAll({"parentId" : parentId.toString()});
    }
    return await ApiService.post(uri: '/club/$clubId/board/$boardId/comment',
      header: {
        "Content-Type" : "application/json",
        "Authorization" : "Bearer ${await SecureStorage.readAccessToken()}",
      },
      body: jsonEncode(body)
    );
  }

}