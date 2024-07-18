import 'package:flutter/material.dart';
import 'package:flutter_sport/widgets/initPage.dart';

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

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {

  late ColorScheme currentColorScheme;
  late Color currentCardColor;

  Color lightCardColor = Color(0xFFE3E3E3); // Input 컨테이너컬러
  Color darkCardColor = Color(0xFF212227); // Input 컨테이너컬러

  ColorScheme lightTheme = const ColorScheme.light(
    background: Colors.white,
    onPrimary: Color(0xFF72A8E6), // 메인컬러

    primary: Color(0xFF292929), // 기본 폰트 컬러
    secondary: Color(0xFF686868), // 상세 폰트 컬러
    tertiary: Color(0xFF888888), // 부가 폰트 컬러

    primaryContainer: Color(0xFFE3E3E3), // 선택된 컨테이너 컬러
    secondaryContainer: Color(0xFFDFDFDF), // 상세 폰트 컨테이너 컬러
    tertiaryContainer: Color(0xFFFBFBFB), // 내 모임 카드 컬러

    outline: Color(0xFFC8C8C8), // border outline 컬러


  );

  ColorScheme darkTheme = const ColorScheme.dark(
    background: Color(0xFF19181B),
    onPrimary: Color(0xFF72A8E6), // 메인컬러

    primary: Color(0xFFE6E6E6), // 기본 폰트 컬러
    secondary: Color(0xFFD4D4D4), // 상세 폰트 컬러
    tertiary: Color(0xFFC5C5C5), // 부가 폰트 컬러

    primaryContainer: Color(0xFF2A2A32), // 선택된 컨테이너 컬러
    secondaryContainer: Color(0xFF2A292C), // 상세 폰트 컨테이너 컬러
    tertiaryContainer: Color(0xFF212227), // 내 모임 카드 컬러

    outline: Color(0xFF26262A), // border outline 컬러
  );

  themeLight() {
    setState(() {
      currentColorScheme = lightTheme;
      currentCardColor = lightCardColor;
    });
  }

  themeDark() {
    setState(() {
      currentColorScheme = darkTheme;
      currentCardColor = darkCardColor;
    });
  }

  @override
  void initState() {
    themeLight();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      home: InitPage(themeLight: themeLight, themeDark: themeDark),
      theme: ThemeData(
        fontFamily: 'Pretendard',
        colorScheme: currentColorScheme,
        cardColor: currentCardColor,
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontSize: 21,
          ),
          displayMedium: TextStyle(
            fontSize: 17,
          ),
          displaySmall: TextStyle(
            fontSize: 13,
          ),

          bodyLarge: TextStyle(
            fontSize: 18
          ),
          bodyMedium: TextStyle(
            fontSize: 16
          ),
          bodySmall: TextStyle(
            fontSize: 14,
          ),
        ),

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

