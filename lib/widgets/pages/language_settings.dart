import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../models/login_notifier.dart';

class LanguageSettingsWidget extends ConsumerWidget {

  const LanguageSettingsWidget({super.key});

  onChangeLanguage(BuildContext context, Locale locale) async {
    EasyLocalization.of(context)?.setLocale(locale);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Locale locale = EasyLocalization.of(context)!.locale;

    return Scaffold(
      appBar: AppBar(
        title: Text('언어 설정'),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            RadioListTile(
              title: Text('한국어'),
              value: Locale('ko', 'KR'),
              groupValue: locale,
              onChanged: (value) => onChangeLanguage(context, value!),
            ),
            // RadioListTile(
            //   title: Text('English'),
            //   value: Locale('en', 'US'),
            //   groupValue: locale,
            //   onChanged: (value) => onChangeLanguage(context, value!),
            // ),
            RadioListTile(
              title: Text('日本語'),
              value: Locale('ja', 'JP'),
              groupValue: locale,
              onChanged: (value) => onChangeLanguage(context, value!),
            ),
          ],
        ),
      ),
    );
  }
}
