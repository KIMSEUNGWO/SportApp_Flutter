
import 'package:flutter_sport/api/error_handler.dart';

class ResponseResult {

  late ResultCode resultCode;
  late dynamic data;

  ResponseResult.fromJson(Map<String, dynamic> json) :
    resultCode = ResultCode.valueOf(json['result']),
    data = json['data'];
}

enum ResultCode {
  OK,

  SOCIAL_LOGIN_FAILD,

  INVALID_DATA,

  REGISTER,

  TOKEN_EXPIRED,

  ACCESS_TOKEN_REQUIRE,

  MAX_UPLOAD_SIZE_EXCEEDED,

  UNKOWN;

  static ResultCode valueOf(String errorCode) {
    List<ResultCode> errorCodes = ResultCode.values;

    for (var error in errorCodes) {
      if (error.name == errorCode) return error;
    }
    return ResultCode.UNKOWN;
  }
}