import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_sport/widgets/pages/main_page.dart';
import 'package:flutter_sport/widgets/pages/my_group_page.dart';
import 'package:flutter_sport/widgets/pages/profile_page.dart';
import 'package:flutter_sport/widgets/pages/search_page.dart';

import 'package:easy_localization/easy_localization.dart';

class Main extends StatefulWidget {
  const Main({super.key});

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {

  final PageController _pageController = PageController();
  int _currentIndex = 0;

  onChangePage(int index) {
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
      backgroundColor: Colors.white,
      body: PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        children: [
          MainPage(),
          SearchPage(),
          MyGroupPage(),
          ProfilePage(),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
        elevation: 0,
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            BottomNavigator(
              title: 'home', icon: Icons.home,
              callback: () => onChangePage(0), isPressed: _currentIndex == 0,
            ),
            BottomNavigator(
              title: 'search', icon: Icons.search,
              callback: () => onChangePage(1), isPressed: _currentIndex == 1,
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
          Icon(icon, size: 35, color: isPressed ? pressedColor : defaultColor,),
          Text('bottomAppBarMenus', style: TextStyle(color: isPressed ? pressedColor : defaultColor),)
            .tr(gender: title),
        ],
      ),
    );
  }
}
