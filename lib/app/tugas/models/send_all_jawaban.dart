class ItemsJawabanAll {
  ItemsJawabanAll({
    required this.data,
  });
  List<Datum> data;
}

class Datum {
  Datum({
    required this.key,
    required this.jawab,
  });

  String key;
  String jawab;
}
