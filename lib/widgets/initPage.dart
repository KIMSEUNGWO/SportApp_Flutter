import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sport/notifiers/login_notifier.dart';
import 'package:flutter_sport/notifiers/region_notifier.dart';
import 'package:flutter_sport/widgets/mainPage.dart';


class InitPage extends ConsumerStatefulWidget {
  const InitPage({super.key});

  @override
  ConsumerState<InitPage> createState() => _InitPageState();
}

class _InitPageState extends ConsumerState<InitPage> {

  @override
  void initState() {
    ref.read(loginProvider.notifier).readUser();
    ref.read(regionProvider.notifier).init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Main();
  }
}
