

import 'dart:ui';

import 'package:flutter_sport/common/language_enum.dart';
import 'package:flutter_sport/models/region_data.dart';

class FindRegion {

  static List<Region> findAll(String word, Locale locale) {
    if (word.isEmpty) return List.empty();

    LanguageType langType = LanguageType.getLangType(word);

    List<Region> result = [];

    Region.values
        .where((region) => region != Region.ALL && region.isStartWith(langType, word))
        .forEach((region) => result.add(region));

    if (result.isEmpty) {
      RegionParent.values
          .where((region) => region != RegionParent.ALL && region.isStartWith(langType, word))
          .forEach((region) => result.addAll(region.getRegionChildList()));
    }

    result.sort((a, b) => a.compareTo(b, locale));

    return result;
  }
}