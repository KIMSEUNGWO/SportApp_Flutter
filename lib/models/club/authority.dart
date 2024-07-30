
enum Authority {

  OWNER('owner'),
  MANAGER('manager'),
  USER('user');

  final String lang;

  const Authority(this.lang);

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

  bool isUser() {
    return this == Authority.USER;
  }
}