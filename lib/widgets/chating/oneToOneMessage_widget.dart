import 'package:flutter/material.dart';

import 'package:easy_localization/easy_localization.dart';

class OneToOneMessageWidget extends StatelessWidget {
  const OneToOneMessageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('mainAppBarMenus').tr(gender: 'oneToOneMessage'),
      ),
    );
  }
}
