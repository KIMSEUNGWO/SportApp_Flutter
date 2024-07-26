
import 'package:flutter/material.dart';

class NavigatorHelper {

  static push(BuildContext context, Widget widget, {bool fullscreenDialog = false}) {
    final pageRoute = MaterialPageRoute(
      builder: (context) => widget,
      fullscreenDialog: fullscreenDialog
    );
    Navigator.push(context, pageRoute);
  }


}