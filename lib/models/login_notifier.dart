import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sport/api/line_api.dart';


class LoginNotifier extends StateNotifier<bool> {
  LoginNotifier() : super(false);

  void login() async {
    state = await LineAPI.login();
  }

  void logout() {
    state = false;
  }

}

final loginProvider = StateNotifierProvider<LoginNotifier, bool>((ref) => LoginNotifier(),);