import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_sport/common/login_checker.dart';
import 'package:flutter_sport/widgets/pages/main_page.dart';
import 'package:flutter_sport/widgets/pages/my_group_page.dart';
import 'package:flutter_sport/widgets/pages/profile/profile_page.dart';
import 'package:flutter_sport/widgets/pages/search_page.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Main extends ConsumerStatefulWidget {

  final Function() themeLight;
  final Function() themeDark;

  const Main({super.key, required this.themeLight, required this.themeDark});

  @override
  ConsumerState<Main> createState() => _MainState();
}

class _MainState extends ConsumerState<Main> {

  final PageController _pageController = PageController();
  int _currentIndex = 0;

  onChangePage(int index) {
    if (index == 2) {
      bool hasLogin = LoginChecker.loginCheck(context, ref);
      print(hasLogin);
      if (!hasLogin) return;
    }
    setState(() { _currentIndex = index;});
    _pageController.jumpToPage(index);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        children: [
          MainPage(),
          SearchPage(),
          MyGroupPage(),
          ProfilePage(themeLight: widget.themeLight, themeDark: widget.themeDark),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: Color(0xFFF1F1F5), width: 0.2)
          ),
        ),
        child: BottomAppBar(
          elevation: 0,
          color: Theme.of(context).colorScheme.background,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              BottomNavigator(
                title: 'home', icon: Icons.home,
                callback: () => onChangePage(0), isPressed: _currentIndex == 0,
              ),
              BottomNavigator(
                title: 'search', icon: Icons.search,
                // callback: () => onChangePage(1),
                callback: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SearchPage(),)),
                isPressed: _currentIndex == 1,
              ),
              BottomNavigator(
                title: 'myGroups', icon: Icons.chat_bubble,
                callback: () => onChangePage(2), isPressed: _currentIndex == 2,
              ),
              BottomNavigator(
                title: 'profile', icon: Icons.person,
                callback: () => onChangePage(3), isPressed: _currentIndex == 3,
              ),
            ],
          ),
        ),
      ),

    );
  }
}


class BottomNavigator extends StatelessWidget {

  final GestureTapCallback callback;
  final IconData icon;
  final String title;
  bool isPressed;

  final Color pressedColor = const Color(0xFF565360);
  final Color defaultColor = const Color(0xFF908E9B);

  BottomNavigator({
    super.key,
    required this.callback,
    required this.icon,
    required this.title,
    required this.isPressed
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: callback,
      child: Column(
        children: [
          Icon(icon,
            size: 35,
            color: isPressed
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.secondary,
          ),
          Text('bottomAppBarMenus',
            style: TextStyle(
              color: isPressed
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.secondary,
              fontSize: Theme.of(context).textTheme.bodySmall!.fontSize,
              fontWeight: FontWeight.w500
            ),
          ).tr(gender: title),
        ],
      ),
    );
  }
}
