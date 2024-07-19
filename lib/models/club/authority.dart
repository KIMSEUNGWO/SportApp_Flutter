
enum Authority {

  OWNER,
  MANAGER,
  USER;

  static Authority? valueOf(String? data) {
    List<Authority> values = Authority.values;
    for (var o in values) {
      if (o.name == data) return o;
    }
    return null;
  }

  bool isOwner() {
    return this == Authority.OWNER;
  }
}