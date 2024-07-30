import 'package:flutter/material.dart';
import 'package:flutter_sport/models/club/authority.dart';
import 'package:flutter_sport/notifiers/login_notifier.dart';
import 'package:flutter_sport/notifiers/region_notifier.dart';
import 'package:flutter_sport/widgets/initPage.dart';

import 'package:flutter_line_sdk/flutter_line_sdk.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sport/widgets/mainPage.dart';
import 'package:flutter_sport/widgets/pages/board/board_detail_page.dart';
import 'package:flutter_sport/widgets/pages/groupdetails/club_detail_page.dart';
import 'package:flutter_sport/widgets/pages/profile/profile_page.dart';
import 'package:flutter_sport/widgets/pages/search_page.dart';
import 'package:go_router/go_router.dart';

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

class App extends ConsumerStatefulWidget {
  const App({super.key});

  @override
  ConsumerState<App> createState() => _AppState();
}

class _AppState extends ConsumerState<App> {

  late ColorScheme currentColorScheme;
  late Color currentCardColor;

  Color lightCardColor = const Color(0xFFE3E3E3); // Input 컨테이너컬러
  Color darkCardColor = const Color(0xFF212227); // Input 컨테이너컬러

  ColorScheme lightTheme = const ColorScheme.light(
    background: Colors.white,
    onPrimary: Color(0xFF72A8E6), // 메인컬러
    onSecondary: Color(0xFFE9F1FA), // 메인컬러 2

    primary: Color(0xFF292929), // 기본 폰트 컬러
    // primary: Color(0xFF433F3F), // 기본 폰트 컬러 -> 이 색도 괜찮은 듯
    secondary: Color(0xFF686868), // 상세 폰트 컬러
    tertiary: Color(0xFF888888), // 부가 폰트 컬러

    primaryContainer: Color(0xFF6E6E6E), // 선택된 컨테이너 컬러
    secondaryContainer: Color(0xFFEDEDED), // 상세 폰트 컨테이너 컬러
    tertiaryContainer: Color(0xFFFBFBFB), // 내 모임 카드 컬러

    surface: Color(0xFFF1F1F5), // 이미지 Empty 컬러

    outline: Color(0xFFF1F1F5), // border outline 컬러
    outlineVariant: Color(0xFFD9D9D9), // border input outline 컬러

    surfaceVariant: Color(0xFFD9D9D9), // List Empty Center 알림 문구 컬러


  );

  ColorScheme darkTheme = const ColorScheme.dark(
    background: Color(0xFF19181B),
    onPrimary: Color(0xFF72A8E6), // 메인컬러
    onSecondary: Color(0xFF85898F), // 메인컬러 2

    primary: Color(0xFFE6E6E6), // 기본 폰트 컬러
    secondary: Color(0xFFD4D4D4), // 상세 폰트 컬러
    tertiary: Color(0xFFC5C5C5), // 부가 폰트 컬러

    primaryContainer: Color(0xFF474750), // 선택된 컨테이너 컬러
    secondaryContainer: Color(0xFF2A292C), // 상세 폰트 컨테이너 컬러
    tertiaryContainer: Color(0xFF212227), // 내 모임 카드 컬러

    surface: Color(0xFF2B2B32), // 이미지 Empty 컬러

    outline: Color(0xFF26262A), // border outline 컬러
    outlineVariant: Color(0xFFD9D9D9), // border input outline 컬러

    surfaceVariant: Color(0xFF3E3B3B), // List Empty Center 알림 문구 컬러

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
  init() async {
    await ref.read(loginProvider.notifier).readUser();
    await ref.read(regionProvider.notifier).init();
  }

  @override
  void initState() {
    super.initState();
    init();
    themeLight();
  }

  @override
  Widget build(BuildContext context) {
    final _router = GoRouter(
      initialLocation: "/",
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => Main(themeLight: themeLight, themeDark: themeDark),
        ),
        GoRoute(
          path: '/search',
          builder: (context, state) => const SearchPage(),
        ),
        GoRoute(
          path: '/club/:clubId',
          builder: (context, state) {
            final String clubId = state.pathParameters['clubId']!;
            return ClubDetailWidget(id: int.parse(clubId));
          },
          routes: [
            GoRoute(
              path: 'board/:boardId',
              builder: (context, state) {
                final String clubId = state.pathParameters['clubId']!;
                final String boardId = state.pathParameters['boardId']!;
                Map<String, dynamic> map = state.extra as Map<String, dynamic>;
                return BoardDetailWidget(
                    clubId: int.parse(clubId),
                    boardId: int.parse(boardId),
                    authority: map['authority'],
                    boardListReload: map['reload']
                );
              },

            ),
          ]

        )
      ],
    );
    // return MaterialApp.router(
    //   routerConfig: _router,
    // // routeInformaterProvider : 라우트 상태를 전달해주는 함수
    // // routeInformationParser: URI String을 상태 및 GoRouter에서 사용할 수 있는 형태로 변환해주는 함수
    // // routerDelegate: routeInformationParser에서 변환된 값을 어떤 라우트로 보여줄 지 정하는 함수
    //   localizationsDelegates: context.localizationDelegates,
    //   supportedLocales: context.supportedLocales,
    //   locale: context.locale,
    //   theme: ThemeData(
    //     fontFamily: 'Pretendard',
    //     colorScheme: currentColorScheme,
    //     cardColor: currentCardColor,
    //     textTheme: const TextTheme(
    //       displayLarge: TextStyle(
    //         fontSize: 21,
    //       ),
    //       displayMedium: TextStyle(
    //         fontSize: 17,
    //       ),
    //       displaySmall: TextStyle(
    //         fontSize: 13,
    //       ),
    //
    //       bodyLarge: TextStyle(
    //           fontSize: 18
    //       ),
    //       bodyMedium: TextStyle(
    //           fontSize: 16
    //       ),
    //       bodySmall: TextStyle(
    //         fontSize: 14,
    //       ),
    //     ),
    //
    //   ),
    // );
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      home: InitPage(themeLight: themeLight, themeDark: themeDark),
      locale: context.locale,
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
            fontSize: 14
          ),
          bodyMedium: TextStyle(
            fontSize: 12
          ),
          bodySmall: TextStyle(
            fontSize: 10,
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

