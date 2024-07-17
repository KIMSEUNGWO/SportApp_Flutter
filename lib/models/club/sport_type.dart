
enum SportType {

  SOCCER('soccer'),
  BASEBALL('baseball'),
  BADMINTON('badminton'),
  TENNIS('tennis'),
  BASKETBALL('basketball'),
  RUNNING('running');

  final String lang;

  const SportType(this.lang);

  static SportType? valueOf(String data) {
    List<SportType> values = SportType.values;
    for (var o in values) {
      if (o.name == data) return o;
    }
    return null;
  }

}