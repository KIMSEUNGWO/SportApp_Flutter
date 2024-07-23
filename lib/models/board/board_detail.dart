

import 'package:flutter/cupertino.dart';
import 'package:flutter_sport/api/uri_helper.dart';
import 'package:flutter_sport/models/board/board_type.dart';
import 'package:flutter_sport/models/comment/comment.dart';

class BoardDetail {

  final int boardId;
  final String title;
  final String content;
  final DateTime createDate;
  final BoardType boardType;

  final List<BoardImage> images;

  final int likeCount;

  final int userId;
  final Image? thumbnailUser;
  final String nickname;

  final List<Comment> comments;

  BoardDetail.fromJson(Map<String, dynamic> json):
    boardId = json['boardId'],
    title = json['title'],
    content = json['content'],
    boardType = BoardType.valueOf(json['boardType']),
    images = json['images'] == null
        ? []
        : List<BoardImage>.from(json['images'].map((image) => BoardImage.fromJson(image))),
    likeCount = json['likeCount'],
    createDate = DateTime.parse(json['createDate']),

    userId = json['userId'],
    thumbnailUser = json['thumbnailUser'] != null
        ? ImageHelper.parseImage(imagePath: ImagePath.THUMBNAIL, imageType: ImageType.PROFILE, imageName: json['thumbnailUser'], fit: BoxFit.fill,)
        : null,
    nickname = json['nickname'],

    comments = json['comments'] == null ? []
      : List<Comment>.from(json['comments'].map((comment) => Comment.fromJson(comment)));
}

class BoardImage {

  final int imageId;
  final String attachedImage;
  final Image image;

  BoardImage.fromJson(Map<String, dynamic> json):
    imageId = json['imageId'],
    attachedImage = json['attachedImage'],
    image = ImageHelper.parseImage(imagePath: ImagePath.ORIGINAL, imageType: ImageType.BOARD, imageName: json['attachedImage'], fit: BoxFit.fitWidth);
}



