

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_sport/api/uri_helper.dart';
import 'package:flutter_sport/models/board/board_type.dart';

class BoardDetail {

  final int boardId;
  final String title;
  final String content;
  final DateTime createDate;
  final BoardType boardType;
  final bool isUpdate;

  final List<BoardImage> images;

  final int likeCount;

  final int userId;
  final Image? thumbnailUser;
  final String nickname;

  BoardDetail.fromJson(Map<String, dynamic> json):
    boardId = json['boardId'],
    title = json['title'],
    content = json['content'],
    boardType = BoardType.valueOf(json['boardType']),
    isUpdate = json['update'],
    images = json['images'] == null
        ? []
        : List<BoardImage>.from(json['images'].map((image) => BoardImage.fromJson(image))),
    likeCount = json['likeCount'],
    createDate = DateTime.parse(json['createDate']),

    userId = json['userId'],
    thumbnailUser = json['thumbnailUser'] != null
        ? ImageHelper.parseImage(imagePath: ImagePath.THUMBNAIL, imageType: ImageType.PROFILE, imageName: json['thumbnailUser'], fit: BoxFit.fill,)
        : null,
    nickname = json['nickname'];
}

class BoardImage {

  final int? imageId;
  final String path;
  final Image image;

  BoardImage.upload(String imagePath):
    imageId = null,
    path = imagePath,
    image = Image.file(File(imagePath), fit: BoxFit.fill,);


  BoardImage.fromJson(Map<String, dynamic> json):
    imageId = json['imageId'],
    path = json['attachedImage'],
    image = ImageHelper.parseImage(imagePath: ImagePath.ORIGINAL, imageType: ImageType.BOARD, imageName: json['attachedImage'], fit: BoxFit.fitWidth);
}




