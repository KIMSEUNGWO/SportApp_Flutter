
import 'package:flutter/material.dart';

class SettingWidget extends StatelessWidget {

  final Function() themeLight;
  final Function() themeDark;

  const SettingWidget({super.key, required this.themeLight, required this.themeDark});

  @override
  Widget build(BuildContext context) {

    final brightness = MediaQuery.of(context).platformBrightness;
    print(brightness);

    return Scaffold(
      appBar: AppBar(
        title: Text('설정'),
      ),
      body: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () {
                themeLight();
              },
              child: Text('주간모드'),
            ),
            GestureDetector(
              onTap: () {
                themeDark();
              },
              child: Text('야간모드'),
            )
          ],
        ),
      ),
    );
  }
}
