import 'package:flutter/material.dart';
import 'package:flutter_sport/widgets/mainPage.dart';
import 'package:flutter_sport/widgets/pages/main_page.dart';
import 'package:flutter_sport/widgets/pages/sport/soccer_page.dart';

import 'package:flutter_line_sdk/flutter_line_sdk.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  const String channelId = '2005763087';

  WidgetsFlutterBinding.ensureInitialized();
  // LINE Login API 연동
  LineSDK.instance.setup(channelId).then((_) => print('LineSDK Prepared'));

  // 언어팩
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('ko', 'KR'), Locale('ja', 'JP')],
      path: 'assets/translations',
      fallbackLocale: const Locale('ko', 'KR'),
      child: const ProviderScope(child: App()),
    )
  );
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      home: Main(),
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

