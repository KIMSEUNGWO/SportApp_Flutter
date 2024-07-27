import 'dart:collection';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReloadNotifier extends StateNotifier<Map<ReloadType, Function()>> {
  ReloadNotifier() : super(HashMap());

  setReload({required ReloadType reloadType, required Function() reload}) {
    if (state.containsKey(reloadType)) {
      state[reloadType] = reload;
    } else {
      state.putIfAbsent(reloadType, () => reload,);
    }
  }

  reload(ReloadType reloadType) async {
    if (state[reloadType] != null) {
      await state[reloadType];
    }
  }

  remove(ReloadType reloadType) {
    if (state.containsKey(reloadType)) {
      state.remove(reloadType);
    }
  }


}

enum ReloadType {

  CLUB_RELOAD

}

final reloadProvider = StateNotifierProvider<ReloadNotifier, Map<ReloadType, Function()>>((ref) => ReloadNotifier());