import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sport/common/alert.dart';
import 'package:flutter_sport/notifiers/login_notifier.dart';
class LoginChecker {

  static bool loginCheck(BuildContext context, WidgetRef ref) {
    bool hasLogin = ref.read(loginProvider.notifier).has();
    if (hasLogin) {
      return true;
    }

    Alert.requireLogin(context);
    return false;
  }
}