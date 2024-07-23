import 'package:flutter/material.dart';
import 'package:flutter_sport/api/uri_helper.dart';
import 'package:flutter_sport/models/board/board_type.dart';

class Board {

  final int boardId;
  final String title;
  final String content;
  final BoardType boardType;

  final Image? thumbnailBoard;

  final int likeCount;
  final int commentCount;
  final DateTime createDate;

  final int userId;
  final Image? thumbnailUser;
  final String nickname;

  Board.fromJson(Map<String, dynamic> json):
    boardId = json['boardId'],
    title = json['title'],
    content = json['content'],
    boardType = BoardType.valueOf(json['boardType']),
    thumbnailBoard = json['thumbnailBoard'] != null
        ? ImageHelper.parseImage(imagePath: ImagePath.THUMBNAIL, imageType: ImageType.BOARD, imageName: json['thumbnailBoard'], fit: BoxFit.fill,)
        : null,
    likeCount = json['likeCount'],
    commentCount = json['commentCount'],
    createDate = DateTime.parse(json['createDate']),

    userId = json['userId'],
    thumbnailUser = json['thumbnailUser'] != null
        ? ImageHelper.parseImage(imagePath: ImagePath.THUMBNAIL, imageType: ImageType.PROFILE, imageName: json['thumbnailUser'], fit: BoxFit.fill,)
        : null,
    nickname = json['nickname'];
}