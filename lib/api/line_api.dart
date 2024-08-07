import 'package:flutter/services.dart';
import 'package:flutter_line_sdk/flutter_line_sdk.dart';
import 'package:flutter_sport/api/api_result.dart';
import 'package:flutter_sport/api/api_service.dart';
import 'package:flutter_sport/api/social_result.dart';
import 'package:flutter_sport/common/secure_strage.dart';


class LineAPI {

  static Future<SocialResult?> login() async {
    try {
      final result = await LineSDK.instance.login();
      return SocialResult(
        socialId: result.userProfile!.userId,
        provider: Provider.LINE,
        accessToken: result.accessToken.value,
      );

    } on PlatformException catch(e) {
      print('LINE API : PlatformException !!!');
      print(e);
      return null;
    }

  }

  static void logout() async {
    try {
      await LineSDK.instance.logout();
      SecureStorage.removeAllByToken();
    } on PlatformException catch (e) {
      print(e.message);
    }
  }

  static void verifyAccessToken() async {
    try {
      final result = await LineSDK.instance.verifyAccessToken();
    } on PlatformException catch (e) {
      print(e.message);
      // token is not valid, or any other error.
    }
  }

  static void refreshToken() async {
    try {
      final result = await LineSDK.instance.refreshToken();
      print(result.value);
      // access token -> result.value
      // expires duration -> result.expiresIn
    } on PlatformException catch (e) {
      print(e.message);
    }
  }

}
