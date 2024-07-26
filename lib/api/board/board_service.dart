

import 'package:flutter_sport/api/api_result.dart';
import 'package:flutter_sport/api/api_service.dart';
import 'package:flutter_sport/api/method_type.dart';
import 'package:flutter_sport/common/secure_strage.dart';
import 'package:flutter_sport/models/board/board_detail.dart';
import 'package:flutter_sport/models/board/board_type.dart';

class BoardService {

  static Future<ResponseResult> createBoard({required int clubId, required List<BoardImage> images, required BoardType boardType, required String title, required String content}) async {
    return await ApiService.multipartList('/club/$clubId/board/create',
      method: MethodType.POST,
      multipartFilePathList: images.map((e) => e.path).toList(),
      data: {
        'title' : title,
        'content' : content,
        'boardType' : boardType.name
      },
    );
  }

  static Future<ResponseResult> getBoards({required int clubId, required int page, required int size, required String? boardType}) async {
    return await ApiService.get(uri: '/club/$clubId/board?boardType=$boardType&page=$page&size=$size',
    );
  }

  static Future<ResponseResult> getBoardDetail({required int boardId, required int clubId}) async {
    return await ApiService.get(
      uri: '/club/$clubId/board/$boardId',
      header: {
        "Authorization" : "Bearer ${await SecureStorage.readAccessToken()}",
      }
    );
  }

  static Future<ResponseResult> editBoard({required int clubId, required int boardId, required List<BoardImage> images, required BoardType boardType, required String title, required String content, required List<int> removeImages}) async {
    Map<String, dynamic> body = {
      "boardType" : boardType.name,
      "title" : title,
      "content" : content,
      "removeImages" : removeImages
    };
    return await ApiService.multipartList('/club/$clubId/board/$boardId',
      method: MethodType.PATCH,
      multipartFilePathList: images.map((e) => e.path).toList(),
      data: body
    );
  }

  static Future<ResponseResult> deleteBoard({required int clubId, required int boardId}) async {
    return ApiService.delete(uri: '/club/$clubId/board/$boardId',
      header: {
        "Authorization" : "Bearer ${await SecureStorage.readAccessToken()}",
      }
    );
  }
}