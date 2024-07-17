
import 'package:flutter/material.dart';
import 'package:flutter_sport/models/club/authority.dart';
import 'package:flutter_sport/models/club/region_data.dart';
import 'package:flutter_sport/models/club/sport_type.dart';

class ClubDetail {

  final int id;
  final Image? image;
  final String title;
  final String? intro;
  final SportType? sport;
  final Region? region;
  final int personCount;
  final bool isInclude;
  final Authority? authority;

  ClubDetail.fromJson(Map<String, dynamic> json):
    id = json['id'],
    image = json['image'] != null ? Image.network(json['image'], fit: BoxFit.fill,) : null,
    title = json['title'],
    intro = json['intro'],
    sport = SportType.valueOf(json['sport']),
    region = Region.valueOf(json['region']),
    personCount = json['personCount'],
    isInclude = json['include'] != null ? json['include'] : false,
    authority = Authority.valueOf(json['authority']);

}

class ClubSimp {

  final int id;
  final Image? thumbnail;
  final String title;
  final String? intro;
  final SportType? sport;
  final Region? region;
  final int personCount;
  final DateTime createDate;

  ClubSimp.fromJson(Map<String, dynamic> json):
      id = json['id'],
      thumbnail = json['thumbnail'] != null ? Image.network(json['thumbnail'], fit: BoxFit.fill,) : null,
      title = json['title'],
      intro = json['intro'],
      sport = SportType.valueOf(json['sport']),
      region = Region.valueOf(json['region']),
      personCount = json['personCount'],
      createDate = DateTime.parse(json['createDate']);
}