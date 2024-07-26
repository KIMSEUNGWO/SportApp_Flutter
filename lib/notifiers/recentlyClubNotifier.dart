import 'dart:collection';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sport/models/club/club_data.dart';

class RecentlyClubNotifier extends StateNotifier<List<ClubSimp>> {
  RecentlyClubNotifier() : super([]);

  add(ClubSimp clubSimp) async {
    Set<ClubSimp> set = {...state, clubSimp};
    state = set.toList();
  }

  get() {
    return state;
  }

  length() {
    return state.length;
  }

  ClubSimp index(int idx) {
    return state[idx];
  }

  bool isEmpty() {
    return state.isEmpty;
  }

}

final recentlyClubNotifier = StateNotifierProvider<RecentlyClubNotifier, List<ClubSimp>>((ref) => RecentlyClubNotifier());