
import 'package:flutter_sport/models/region_data.dart';

class GroupData {

  final int id;
  final String image;
  final String title;
  final String intro;
  final String sportType;
  final Region region;
  final int personCount;

  GroupData({required this.id, required this.image, required this.title, required this.intro, required this.sportType, required this.region, required this.personCount});
}