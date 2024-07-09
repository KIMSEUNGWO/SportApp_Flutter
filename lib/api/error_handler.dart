

import 'package:flutter_sport/api/api_service.dart';
import 'package:flutter_sport/api/line_api.dart';

class ErrorHandler {

  static ErrorCode handle(String jsonError) {
    return ErrorCode.valueOf(jsonError);
  }
}

enum ErrorCode {
  TOKEN_EXPIRED,

  ACCESS_TOKEN_REQUIRE,

  INVALID_ERROR;

  static ErrorCode valueOf(String errorCode) {
    List<ErrorCode> errorCodes = ErrorCode.values;

    for (var error in errorCodes) {
      if (error.name == errorCode) return error;
    }
    return ErrorCode.INVALID_ERROR;
  }
}