
import 'package:flutter_sport/api/error_handler.dart';
import 'package:flutter_sport/api/result_code.dart';

class ResponseResult {

  late ResultCode resultCode;
  late dynamic data;

  ResponseResult.fromJson(Map<String, dynamic> json) :
    resultCode = ResultCode.valueOf(json['result']),
    data = json['data'];
}

