
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Alert {

  static void message({required BuildContext context, required Text text, required VoidCallback onPressed}) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          content: text,
          actions: [
            CupertinoDialogAction(
              child: Text('OK'),
              onPressed: () {
                onPressed();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}