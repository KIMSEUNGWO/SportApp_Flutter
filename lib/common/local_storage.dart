import 'package:flutter_sport/models/club/region_data.dart';
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

  static Future<List<String>> getRecentlySearchWords() async{
    final storage = await SharedPreferences.getInstance();
    List<String>? words = storage.getStringList(LocalStorageKey.RECENTLY_SEARCH_WORD.name);
    return (words == null) ? [] : words;
  }

  static saveByRecentlySearchWord(List<String> words) async {
    final storage = await SharedPreferences.getInstance();
    if (words.length > 6) words = words.sublist(0, 6);
    storage.setStringList(LocalStorageKey.RECENTLY_SEARCH_WORD.name, words);
  }

  static saveRecentlyViewClubList(List<String> clubList) async {
    final storage = await SharedPreferences.getInstance();
    if (clubList.length > 10) clubList = clubList.sublist(0, 10);
    storage.setStringList(LocalStorageKey.RECENTLY_VIEW_CLUB.name, clubList);
  }

  static Future<List<String>> getRecentlyViewClubList() async{
    final storage = await SharedPreferences.getInstance();
    List<String>? words = storage.getStringList(LocalStorageKey.RECENTLY_VIEW_CLUB.name);
    return (words == null) ? [] : words;
  }

}

enum LocalStorageKey {

  REGION,
  RECENTLY_SEARCH_WORD,
  RECENTLY_VIEW_CLUB;

}