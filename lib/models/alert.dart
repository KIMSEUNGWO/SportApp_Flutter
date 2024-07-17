
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_sport/widgets/pages/login_page.dart';

class Alert {

  static void message({required BuildContext context, required Text text, VoidCallback? onPressed}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 0,
            child: Container(
              width: 100,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                    child: text,
                  ),

                  Container(
                    height: 45,
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).pop(false);
                                if (onPressed != null) {
                                  onPressed();
                                }
                              },
                              splashColor: Colors.transparent, // 기본 InkWell 효과 삭제
                              highlightColor: Colors.grey.withOpacity(0.2), // 누르고있을때 색상
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border(top: alertBorderSide,),
                                ),
                                child: Center(
                                  child: Text('확인'),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )

                ],
              ),
            )
        );
      },
    );
  }
  
  static void _confirmMessageTemplate({
    required BuildContext context, 
    required String onPressedText,
    required VoidCallback onPressed,
    required Text message,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 0,
            child: Container(
              width: 100,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                    child: message,
                  ),

                  Container(
                    height: 45,
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).pop(false);
                              },
                              splashColor: Colors.transparent, // 기본 InkWell 효과 삭제
                              highlightColor: Colors.grey.withOpacity(0.2), // 누르고있을때 색상
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                      top: alertBorderSide,
                                      right: alertBorderSide
                                  ),
                                ),
                                child: Center(
                                  child: Text('취소'),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: onPressed,
                              splashColor: Colors.transparent, // 기본 InkWell 효과 삭제
                              highlightColor: Colors.grey.withOpacity(0.2), // 누르고있을때 색상
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                      top: alertBorderSide
                                  ),
                                ),
                                child: Center(
                                  child: Text(onPressedText,
                                    style: TextStyle(
                                        color: Colors.blue
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )

                ],
              ),
            )
        );
      },
    );
  }

  static void requireLogin(BuildContext context) {
    _confirmMessageTemplate(
      context: context,
      onPressedText: '로그인',
      onPressed: () {
        _pageMoveToLoginPage(context);
      },
      message: Text('로그인이 필요한 기능입니다.\n지금 로그인 하시겠습니까?',
        style: TextStyle(
            fontSize: 16
        ),
      ),
    );
  }

  static BorderSide alertBorderSide = const BorderSide(
    color: Colors.grey,
    width: 0.2
  );

  static void _pageMoveToLoginPage(BuildContext context) {
    Navigator.pop(context); // Alert 닫음
    Navigator.push(context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => LoginPageWidget(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var begin = Offset(0.0, 1.0);
          var end = Offset.zero;
          var curve = Curves.ease;

          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
        transitionDuration: Duration(milliseconds: 400),
      ),
    );
  }
}