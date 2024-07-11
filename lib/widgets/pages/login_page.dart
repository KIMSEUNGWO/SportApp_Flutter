
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sport/models/login_notifier.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginPageWidget extends ConsumerWidget {

  LoginPageWidget({super.key, this.then});

  Function()? then;

  onTryLogin(BuildContext context, WidgetRef ref) {
    ref.read(loginProvider.notifier).login();
    if (then != null) then!();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Color lineColor = const Color(0xFF06C755);

    return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 30),
        margin: EdgeInsets.only(bottom: 40),
        child: GestureDetector(
          onTap: () => onTryLogin(context, ref),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 20),
            decoration: BoxDecoration(
              color: lineColor,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(color: Colors.grey, offset: Offset(2, 2), blurRadius: 5)
              ],
            ),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SvgPicture.asset('assets/line_logo.svg', width: 40,),
                  Text('Sign in with LINE',
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ]
            ),
          ),
        )
    );
  }

}
