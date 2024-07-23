
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

  MAX_UPLOAD_SIZE_EXCEED,


  // 클럽 예외
  CLUB_NOT_EXISTS,

  // 클럽 생성
  EXCEED_LIMIT_PERSON, // 생성시 : 최대 인원 수보다 많게 설정한 경우, 수정시 : 현재 인원 보다 적게 설정한 경우

  // 클럽 수정
  CLUB_NOT_OWNER,

  // 클럽 참가
  CLUB_JOIN_FULL, // 모임이 꽉 차 있을 때
  CLUB_ALREADY_JOINED, // 이미 참여 중인 모임일 때
  EXCEED_MAX_CLUB, // 참옇ㄹ 수 있는 방 개수를 초과 했을 때

  // 게시글
  CLUB_NOT_JOIN_USER, // 모임에 참가 중인 회원이 아닌 경우


  // 댓글
  NOT_EXISTS_COMMENT, // 대댓글을 작성할 때 부모댓글이 존재하지 않은 경우

  UNKOWN;

  static ResultCode valueOf(String errorCode) {
    List<ResultCode> errorCodes = ResultCode.values;

    for (var error in errorCodes) {
      if (error.name == errorCode) return error;
    }
    return ResultCode.UNKOWN;
  }
}