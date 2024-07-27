import 'package:flutter_sport/models/club/authority.dart';
import 'package:flutter_sport/models/response_user.dart';

class ClubUser {

  final UserSimp user;
  final Authority authority;

  ClubUser.fromJson(Map<String, dynamic> json):
    user = UserSimp.fromJson(json['user']),
    authority = Authority.valueOf(json['authority'])!;
}