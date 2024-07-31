
import 'package:flutter_sport/api/api_result.dart';
import 'package:flutter_sport/api/api_service.dart';

class MeetingService {

  MeetingService._privateConstructor();

  static final MeetingService _instance = MeetingService._privateConstructor();

  factory MeetingService() {
    return _instance;
  }

  Future<ResponseResult> getMeetings({required int clubId, required int page, required int size}) async {
    return await ApiService.get(
      uri: '/public/club/$clubId/meeting',
      authorization: false,
    );
  }

  Future<ResponseResult> getMeetingDetail({required int clubId, required int meetingId}) async {
    return await ApiService.get(
      uri: '/club/$clubId/meeting/$meetingId',
      authorization: true,
    );
  }

  Future<ResponseResult> joinMeeting({required int clubId, required int meetingId}) async {
    return await ApiService.post(
      uri: '/club/$clubId/meeting/$meetingId',
      authorization: true,
    );
  }




}