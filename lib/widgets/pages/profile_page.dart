import 'package:flutter/material.dart';
import 'package:flutter_sport/widgets/pages/language_settings.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: GestureDetector(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => LanguageSettingsWidget(),)),
        child: Text('언어 설정'),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
