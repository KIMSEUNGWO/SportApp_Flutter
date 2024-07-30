import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_sport/notifiers/login_notifier.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';


class LoginPageWidget extends ConsumerStatefulWidget {
  const LoginPageWidget({super.key});

  @override
  ConsumerState<LoginPageWidget> createState() => _LoginPageWidgetState();
}

class _LoginPageWidgetState extends ConsumerState<LoginPageWidget> {

  bool isLoading = false;

  loading(bool loading) {
    setState(() {
      isLoading = loading;
    });
  }
  _onTryLogin(BuildContext context, WidgetRef ref) async {
    final resultType = await ref.read(loginProvider.notifier).login(context, loading: loading);
    loading(false);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    const Color lineColor = Color(0xFF06C755);
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text('로그인',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w500
              ),
            ),
            automaticallyImplyLeading: false,
            scrolledUnderElevation: 0,
            backgroundColor: Theme.of(context).colorScheme.background,
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(1.0),
              child: Container(
                // color: Colors.grey[300], // border 색상
                color: Theme.of(context).colorScheme.outline,
                height: 1.0, // border 높이
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: GestureDetector(
                  child: Icon(Icons.close, size: 30,
                    color: Theme.of(context).colorScheme.primary,
                  ),
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
                              // fontSize: 21,
                              fontSize: Theme.of(context).textTheme.displayLarge!.fontSize,
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.w700
                            ),
                          ),
                          SizedBox(height: 10,),
                          Text('어쩌구저쩌구 소개글입니다.\n뭐하고 뭐하고 뭐하세요~~',
                            style: TextStyle(
                              fontSize: Theme.of(context).textTheme.displayMedium!.fontSize,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            textAlign: TextAlign.center,
                          ),
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
        ),
        Positioned(
          top: 0, left: 0,
          width: isLoading ? MediaQuery.of(context).size.width : 0,
          height: isLoading ? MediaQuery.of(context).size.height : 0,
          child: AnimatedOpacity(
            duration: const Duration(seconds: 1),
            opacity: isLoading ? 1 : 0,
            child: isLoading
              ? Container(
                decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.5)
                ),
                child: Center(
                  child: Container(
                    width: 200,
                    height: 70,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CupertinoActivityIndicator(radius: 13,),
                        Text('로그인 중',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 19,
                            decoration: TextDecoration.none
                          ),
                        )
                      ],
                    ),
                  ),
                ),
          )
              : SizedBox(),
          ),
        ),
      ],
    );
  }
}

