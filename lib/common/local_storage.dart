import 'package:flutter_sport/models/region_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {

  static Future<Region> findByRegion() async {
    final storage = await SharedPreferences.getInstance();
    String? regionName = storage.getString(LocalStorageKey.REGION.name);
    return Region.findByName(regionName);
  }

  static saveByRegion(Region region) async {
    final storage = await SharedPreferences.getInstance();
    storage.setString(LocalStorageKey.REGION.name, region.name);
  }

}

enum LocalStorageKey {

  REGION;

}