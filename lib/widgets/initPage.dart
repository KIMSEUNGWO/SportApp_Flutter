import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sport/notifiers/login_notifier.dart';
import 'package:flutter_sport/notifiers/region_notifier.dart';
import 'package:flutter_sport/widgets/mainPage.dart';

class InitPage extends ConsumerWidget {
  const InitPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(loginProvider.notifier).readUser();
    ref.watch(regionProvider.notifier).init();
    return Main();
  }
}
