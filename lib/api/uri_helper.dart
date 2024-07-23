

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sport/api/api_service.dart';

class ImageHelper {
  
  static parse({required ImagePath imagePath, required ImageType imageType, required String imageName}) {
    return '${ApiService.server}/images${imagePath.path}${imageType.path}/$imageName';
  }

  static Image parseImage({required ImagePath imagePath, required ImageType imageType, required String imageName, required BoxFit fit}) {
    String uri = parse(imagePath: imagePath, imageType: imageType, imageName: imageName);
    return Image.network(uri, fit: fit,);
  }
}

enum ImagePath {
  
  ORIGINAL('/original'),
  THUMBNAIL('/thumbnail');
  
  final String path;
  
  const ImagePath(this.path);
}

enum ImageType {
  
  PROFILE('/profile'),
  CLUB('/club'),
  BOARD('/board');
  
  final String path;
  
  const ImageType(this.path);
}