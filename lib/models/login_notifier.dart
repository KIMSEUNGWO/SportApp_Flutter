import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sport/api/api_service.dart';
import 'package:flutter_sport/api/line_api.dart';


class LoginNotifier extends StateNotifier<bool> {
  LoginNotifier() : super(false);

  void login() async {
    state = await LineAPI.login();
  }

  void logout() async {
    LineAPI.logout();
    state = false;
  }

  void readUser() async {
    state = await ApiService.readUser();
    if (!state) {
      logout();
    }
  }

}

final loginProvider = StateNotifierProvider<LoginNotifier, bool>((ref) => LoginNotifier(),);