
import 'package:flutter_sport/models/response_user.dart';

class Meeting {

  final int id;
  final String originalImage;
  final String thumbnailImage;
  final String title;
  final String description;
  final UserSimp user;
  final DateTime meetingDate;
  final List<UserSimp> joinUsers;

  Meeting.fromJson(Map<String, dynamic> json):
    id = json['id'],
    originalImage = json['originalImage'],
    thumbnailImage = json['thumbnailImage'],
    title = json['title'],
    description = json['description'],
    user = UserSimp.fromJson(json['user']),
    meetingDate = DateTime.parse(json['meetingDate']),
    joinUsers = List<UserSimp>.from(json['joinUsers'].map((image) => UserSimp.fromJson(image)));

}