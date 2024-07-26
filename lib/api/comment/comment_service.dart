
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_sport/api/api_result.dart';
import 'package:flutter_sport/api/api_service.dart';
import 'package:flutter_sport/api/board/board_service.dart';
import 'package:flutter_sport/api/result_code.dart';
import 'package:flutter_sport/common/alert.dart';
import 'package:flutter_sport/common/secure_strage.dart';

class CommentService {

  static _CommentProvider of(BuildContext context) => _CommentProvider(context);



}

class _CommentProvider {

  final CommentError commentError;

  _CommentProvider(BuildContext context): commentError = CommentError(context);

  Future<ResponseResult> getComments({required int clubId, required int boardId, required int start, required int size, required bool reload}) async {
    final response = await ApiService.get(uri: '/club/$clubId/board/$boardId/comment?start=$start&size=$size&reload=$reload',
        header: {
          "Authorization" : "Bearer ${await SecureStorage.readAccessToken()}",
        }
    );
    commentError.defaultErrorHandle(response);
    return response;
  }

  Future<ResponseResult> sendComment({required int? parentId, required String comment, required int clubId, required int boardId}) async {
    Map<String, String> body = {"comment" : comment};
    if (parentId != null) {
      body.addAll({"parentId" : parentId.toString()});
    }
    final response = await ApiService.post(uri: '/club/$clubId/board/$boardId/comment',
        header: {
          "Content-Type" : "application/json",
          "Authorization" : "Bearer ${await SecureStorage.readAccessToken()}",
        },
        body: jsonEncode(body)
    );
    commentError.defaultErrorHandle(response);
    return response;
  }

  Future<ResponseResult> editComment({required int clubId, required int boardId, required int commentId, required String comment}) async {
    final response =  await ApiService.patch(uri: '/club/$clubId/board/$boardId/comment/$commentId',
        header: {
          "Content-Type" : "application/json",
          "Authorization" : "Bearer ${await SecureStorage.readAccessToken()}",
        },
        body: jsonEncode({
          "comment" : comment
        })
    );
    commentError.defaultErrorHandle(response);
    return response;
  }

  Future<ResponseResult> deleteComment({required int clubId, required int boardId, required int commentId}) async {
    final response = await ApiService.delete(uri: '/club/$clubId/board/$boardId/comment/$commentId',
      header: {
        "Content-Type" : "application/json",
        "Authorization" : "Bearer ${await SecureStorage.readAccessToken()}",
      },
    );

    commentError.defaultErrorHandle(response);
    return response;
  }

}

class CommentError extends BoardError {

  CommentError(super.context);

  @override
  bool defaultErrorHandle(ResponseResult response) {
    if (!super.defaultErrorHandle(response)) {
      return false;
    }

    if (context.mounted) {
      if (response.resultCode == ResultCode.NOT_EXISTS_COMMENT) {
        Navigator.pop(context);
        Alert.message(context: context, text: Text('삭제된 댓글입니다.'));
        return false;
      }
    }

    return true;
  }

}