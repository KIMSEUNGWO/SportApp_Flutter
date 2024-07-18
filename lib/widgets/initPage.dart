import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sport/notifiers/login_notifier.dart';
import 'package:flutter_sport/notifiers/region_notifier.dart';
import 'package:flutter_sport/widgets/mainPage.dart';


class InitPage extends ConsumerStatefulWidget {

  final Function() themeLight;
  final Function() themeDark;

  const InitPage({super.key, required this.themeLight, required this.themeDark});

  @override
  ConsumerState<InitPage> createState() => _InitPageState();
}

class _InitPageState extends ConsumerState<InitPage> {

  @override
  void initState() {
    init();
    super.initState();
  }
  init() async {
    await ref.read(loginProvider.notifier).readUser();
    await ref.read(regionProvider.notifier).init();
  }

  @override
  Widget build(BuildContext context) {
    return Main(themeLight: widget.themeLight, themeDark: widget.themeDark);
  }
}
