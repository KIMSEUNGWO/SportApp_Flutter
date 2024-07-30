

import 'package:flutter_sport/api/api_service.dart';
import 'package:flutter_sport/api/result_code.dart';
import 'package:flutter_sport/common/secure_strage.dart';

class TokenService {

  static Future<bool> _checkAccessToken() async {
    final accessToken = await SecureStorage.readAccessToken();
    if (accessToken == null) return false;
    final response = await ApiService.get(uri: '/accessToken', authorization: true);
    return response.resultCode == ResultCode.OK;
  }
  static Future<bool> _refreshingAccessToken() async {
    final refreshToken = await SecureStorage.readRefreshToken();
    if (refreshToken == null) return false;

    final response = await ApiService.post(
      uri: '/social/token',
      authorization: true,
      header: ApiService.contentTypeJson,
    );

    if (response.resultCode == ResultCode.OK) {
      await SecureStorage.saveAccessToken(response.data['accessToken']);
      await SecureStorage.saveRefreshToken(response.data['refreshToken']);
      print('Refreshing AccessToken');
      return true;
    }
    return false;
  }
  static Future<bool> readUser() async {
    return (await _checkAccessToken() || await _refreshingAccessToken());
  }
}