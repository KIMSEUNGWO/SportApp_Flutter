

import 'package:flutter_sport/api/api_result.dart';
import 'package:flutter_sport/api/api_service.dart';
import 'package:flutter_sport/models/board/board_type.dart';
import 'package:flutter_sport/models/upload_image.dart';

class BoardService {

  static Future<ResponseResult> createBoard({required int clubId, required List<UploadImage> images, required BoardType boardType, required String title, required String content}) async {
    return await ApiService.postMultipartList('/club/$clubId/board/create',
      multipartFilePathList: images.map((e) => e.path).toList(),
      data: {
        'title' : title,
        'content' : content,
        'boardType' : boardType.name
      },
    );
  }
}