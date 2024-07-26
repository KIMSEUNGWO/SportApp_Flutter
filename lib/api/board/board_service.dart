

import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_sport/api/api_result.dart';
import 'package:flutter_sport/api/api_service.dart';
import 'package:flutter_sport/api/club/club_service.dart';
import 'package:flutter_sport/api/method_type.dart';
import 'package:flutter_sport/api/result_code.dart';
import 'package:flutter_sport/common/alert.dart';
import 'package:flutter_sport/common/secure_strage.dart';
import 'package:flutter_sport/models/board/board_detail.dart';
import 'package:flutter_sport/models/board/board_type.dart';

class BoardService {

  static _BoardProvider of(BuildContext context) => _BoardProvider(context);
}

class _BoardProvider {

  final BoardError boardError;

  _BoardProvider(BuildContext context): boardError = BoardError(context);


  Future<ResponseResult> getBoardDetail({required int boardId, required int clubId}) async {
    final response = await ApiService.get(
        uri: '/club/123/board/$boardId',
        header: {
          "Authorization" : "Bearer ${await SecureStorage.readAccessToken()}",
        }
    );
    boardError.defaultErrorHandle(response);
    return response;
  }

  Future<ResponseResult> editBoard({required int clubId, required int boardId, required List<BoardImage> images, required BoardType boardType, required String title, required String content, required List<int> removeImages}) async {
    Map<String, dynamic> body = {
      "boardType" : boardType.name,
      "title" : title,
      "content" : content,
      "removeImages" : removeImages
    };
    final response =  await ApiService.multipartList('/club/$clubId/board/$boardId',
        method: MethodType.PATCH,
        multipartFilePathList: images.map((e) => e.path).toList(),
        data: body
    );
    boardError.defaultErrorHandle(response);
    return response;
  }

  Future<ResponseResult> deleteBoard({required int clubId, required int boardId}) async {
    final response = await ApiService.delete(uri: '/club/$clubId/board/$boardId',
        header: {
          "Authorization" : "Bearer ${await SecureStorage.readAccessToken()}",
        }
    );
    boardError.defaultErrorHandle(response);
    return response;
  }

  Future<ResponseResult> createBoard({required int clubId, required List<BoardImage> images, required BoardType boardType, required String title, required String content}) async {
    final response = await ApiService.multipartList('/club/$clubId/board/create',
      method: MethodType.POST,
      multipartFilePathList: images.map((e) => e.path).toList(),
      data: {
        'title' : title,
        'content' : content,
        'boardType' : boardType.name
      },
    );
    boardError.defaultErrorHandle(response);
    return response;
  }

  Future<ResponseResult> getBoards({required int clubId, required int page, required int size, required String? boardType}) async {
    final response = await ApiService.get(uri: '/club/$clubId/board?boardType=$boardType&page=$page&size=$size');

    boardError.defaultErrorHandle(response);
    return response;
  }


}

class BoardError extends ClubError {
  BoardError(super.context);

  @override
  bool defaultErrorHandle(ResponseResult response) {
    if (!super.defaultErrorHandle(response)) {
      return false;
    }

    if (context.mounted) {
      ResultCode resultCode = response.resultCode;
      if (resultCode == ResultCode.BOARD_NOT_EXISTS) {
        Navigator.pop(context);
        Alert.message(context: context, text: Text('삭제된 게시글입니다.'));
        return false;
      }

    }

    return true;
  }

}