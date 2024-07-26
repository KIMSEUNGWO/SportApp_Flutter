
import 'package:flutter_sport/api/api_result.dart';
import 'package:flutter_sport/api/error_handler/club_path_data.dart';

abstract class ErrorHandler {

  bool defaultErrorHandle(ResponseResult response, ClubPath clubPath);

}