
enum ResultType {

  OK,
  REGISTER,
  ERROR;


  static ResultType findBy(String result) {
    List<ResultType> lists = ResultType.values;

    for (var o in lists) {
      if (o.name == result) return o;
    }

    return ResultType.ERROR;
  }



}