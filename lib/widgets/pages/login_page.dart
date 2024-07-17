import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_sport/api/api_result.dart';
import 'package:flutter_sport/notifiers/login_notifier.dart';
import 'package:flutter_sport/widgets/pages/register_page.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginPageWidget extends ConsumerWidget {

  const LoginPageWidget({super.key, required this.modalContext});

  final BuildContext modalContext;


  _onTryLogin(BuildContext context, WidgetRef ref) async {
    final resultType = await ref.read(loginProvider.notifier).login();
    if (resultType == ResultCode.REGISTER) {
      Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterWidget()));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Color lineColor = const Color(0xFF06C755);

    return Scaffold(
      appBar: AppBar(
        title: Text('로그인'),
        automaticallyImplyLeading: false,
        scrolledUnderElevation: 0,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: Container(
            color: Colors.grey[300], // border 색상
            height: 1.0, // border 높이
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: GestureDetector(
              child: Icon(Icons.close, size: 30,),
              onTap: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('어서오세요!',
                        style: TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.w600
                        ),
                      ),
                      SizedBox(height: 5,),
                      Text('어쩌구저쩌구 소개글입니다.',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      Text('뭐하고 뭐하고 뭐하세요~~',
                        style: TextStyle(
                          fontSize: 16,
                        )
                      )
                    ],
                  ),
                  SizedBox(
                    height: 250,
                    child: SvgPicture.asset('assets/icons/loginLogo.svg', fit: BoxFit.contain,),
                  ),

                ],
              ),
              Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      _onTryLogin(context, ref);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      decoration: BoxDecoration(
                        color: lineColor,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(color: Colors.grey, offset: Offset(2, 2), blurRadius: 5),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SvgPicture.asset(
                            'assets/line_logo.svg',
                            width: 40,
                          ),
                          Text(
                            'Sign in with LINE',
                            style: TextStyle(
                              fontSize: 23,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }

}
