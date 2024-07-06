
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sport/api/line_api.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginPageWidget extends StatelessWidget {

  const LoginPageWidget({super.key});

  onTryLogin() {
     LineAPI.login();
  }

  @override
  Widget build(BuildContext context) {
    final Color lineColor = const Color(0xFF06C755);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 30),
      margin: EdgeInsets.only(bottom: 40),
      child: GestureDetector(
        onTap: onTryLogin,
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
