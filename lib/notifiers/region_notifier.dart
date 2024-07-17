import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sport/common/local_storage.dart';
import 'package:flutter_sport/models/region_data.dart';

class RegionNotifier extends StateNotifier<Region> {
  RegionNotifier() : super(Region.ALL);

  void init() async {
    state = await LocalStorage.findByRegion();
  }

  void changeRegion(Region newRegion) async {
    state = newRegion;
    LocalStorage.saveByRegion(newRegion);
  }

  String getLocalName(Locale locale) {
    return state.getLocaleName(locale);
  }

}

final regionProvider = StateNotifierProvider<RegionNotifier, Region>((ref) => RegionNotifier());