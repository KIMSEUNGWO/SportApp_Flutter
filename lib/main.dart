import 'package:flutter/material.dart';
import 'package:flutter_sport/widgets/mainPage.dart';
import 'package:flutter_sport/widgets/pages/main_page.dart';
import 'package:flutter_sport/widgets/pages/sport/soccer_page.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const Main(),
      theme: ThemeData(
        fontFamily: 'Pretendard',
        colorScheme: ColorScheme.light(
          background: Colors.white,
          onBackground: MyTheme.backgroundColor(),
          primary: MyTheme.mainColor(),
          secondary: MyTheme.mainFontColor()
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontSize: 21),
          displayMedium: TextStyle(fontSize: 16),
          displaySmall: TextStyle(fontSize: 12)
        )
      ),
    );
  }
}

class MyTheme {

  static Color backgroundColor() {
    return const Color(0xFFF6F5FD);
  }

  static Color mainColor() {
    return const Color(0xFF685CFE);
  }

  static Color mainFontColor() {
    return const Color(0xFF707072);
  }
}

