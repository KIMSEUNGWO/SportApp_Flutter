
import 'dart:async';
import 'dart:convert';

import 'package:flutter_sport/api/api_result.dart';
import 'package:flutter_sport/api/method_type.dart';
import 'package:flutter_sport/common/secure_strage.dart';
import 'package:flutter_sport/models/notification.dart';
import 'package:http/http.dart' as http;


class ApiService {

  static const String server = "http://192.168.1.79:8080";

  static const Map<String, String> defaultHeader = {
    "Sport-Authorization" : "NnJtQTdJcTU3SnF3N0tleDdLZXg2NmVv",
  };
  static const Map<String, String> contentTypeJson = {
    "Content-Type" : "application/json; charset=utf-8",
  };


  static ResponseResult _decode(http.Response response) {
    final json = jsonDecode(utf8.decode(response.bodyBytes));
    return ResponseResult.fromJson(json);
  }

  static Future<Map<String, String>> getAuthorization() async {
    return {"Authorization" : "Bearer ${await SecureStorage.readAccessToken()}"};
  }
  static Future<ResponseResult> post({required String uri, required bool authorization, Map<String, String>? header, Object? body,}) async {

    Map<String, String> requestHeader = {};
    await getHeaders(requestHeader, authorization, header);

    final response = await http.post(Uri.parse('$server$uri'), headers: requestHeader, body: body);
    return _decode(response);
  }

  static Future<ResponseResult> get({required String uri, required bool authorization, Map<String, String>? header}) async {
    Map<String, String> requestHeader = {"Content-Type" : "application/json; charset=utf-8",};
    await getHeaders(requestHeader, authorization, header);

    final response = await http.get(Uri.parse('$server$uri'), headers: requestHeader);
    return _decode(response);
  }

  static getHeaders(Map<String, String> requestHeader, bool authorization, Map<String, String>? header) async {
    requestHeader.addAll(defaultHeader);
    if (authorization) requestHeader.addAll(await getAuthorization());
    if (header != null) requestHeader.addAll(header);
  }

  static Future<ResponseResult> patch({required String uri, required bool authorization, Map<String, String>? header, Object? body}) async {
    Map<String, String> requestHeader = {};
    getHeaders(requestHeader, authorization, header);

    final response = await http.patch(Uri.parse('$server$uri'), headers: requestHeader, body: body);
    return _decode(response);
  }

  static Future<ResponseResult> delete({required String uri, required bool authorization, Map<String, String>? header, Object? body}) async {
    Map<String, String> requestHeader = {};
    getHeaders(requestHeader, authorization, header);

    final response = await http.delete(Uri.parse('$server$uri'), headers: requestHeader, body: body);
    return _decode(response);
  }

  static Future<ResponseResult> multipart(String uri, {required MethodType method, required String? multipartFilePath, required Map<String, dynamic> data}) async {
    var request = http.MultipartRequest(method.name, Uri.parse('$server$uri'));
    request.headers.addAll({"Content-Type": "application/json; charset=UTF-8"});
    getHeaders(request.headers, true, null);

    if (multipartFilePath != null) {
      request.files.add(await http.MultipartFile.fromPath('image', multipartFilePath));
    }

    for (String key in data.keys) {
      if (data[key] == null) continue;
      request.fields[key] = data[key];
    }

    final response = await request.send();
    final responseBody = await response.stream.bytesToString();
    final json = jsonDecode(responseBody);
    return ResponseResult.fromJson(json);
}

  static Future<ResponseResult> multipartList(String uri, {required MethodType method, required List<String> multipartFilePathList, required Map<String, dynamic> data}) async {
    var request = http.MultipartRequest(method.name, Uri.parse('$server$uri'));
    request.headers.addAll({"Content-Type": "application/json; charset=UTF-8"});
    getHeaders(request.headers, true, null);

    for (var multipartFilePath in multipartFilePathList) {
      request.files.add(await http.MultipartFile.fromPath('image', multipartFilePath));
    }

    for (String key in data.keys) {
      if (data[key] == null) continue;
      if (data[key] is List) {
        request.fields[key] = jsonEncode(data[key]);
      } else {
        request.fields[key] = data[key];
      }
    }

    final response = await request.send();
    final responseBody = await response.stream.bytesToString();
    final json = jsonDecode(responseBody);
    return ResponseResult.fromJson(json);
}

  static Future<List<Notifications>> getTestNotification(int count) async {
    List<Notifications> instances = [];
    for (int i = 0; i < count; ++i) {
      final noty = Notifications(id: i.toString(), date: '2024-06-27T15:00:00', thumb: 'https://phinf.pstatic.net/contact/20220724_153/1658672074422w1wxl_JPEG/IMG_8012.JPG?type=f130_130', title: '테스트제목입니다. $i');
      instances.add(noty);
    }
    return instances;
  }

}