
import 'package:flutter_sport/models/club/authority.dart';

enum BoardType {

  ALL('all'),
  NOTICE('notice'),
  FIRST_COMMENT('firstComment'),
  OPEN_BOARD('openBoard');

  final String lang;

  const BoardType(this.lang);

  static List<BoardType> getBoardMenus(Authority authority) {
    if (authority.isOwner()) {
      return const [BoardType.NOTICE, BoardType.FIRST_COMMENT, BoardType.OPEN_BOARD];
    }
    return const [BoardType.FIRST_COMMENT, BoardType.OPEN_BOARD];
  }

  static BoardType valueOf(String data) {
    for (var boardType in BoardType.values) {
      if (boardType  == BoardType.ALL) continue;
      if (boardType.name == data) return boardType;
    }
    return BoardType.OPEN_BOARD;
  }

}