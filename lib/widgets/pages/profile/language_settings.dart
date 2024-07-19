import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';


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
        title: const Text('Language',
          style: TextStyle(
            fontWeight: FontWeight.w500
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
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
