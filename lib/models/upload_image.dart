
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';

class UploadImage {

  final String path;
  final Image image;

  UploadImage(this.path) : image = Image.file(File(path), fit: BoxFit.fill,);
}