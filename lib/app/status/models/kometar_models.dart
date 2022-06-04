// To parse this JSON data, do
//
//     final komentModels = komentModelsFromJson(jsonString);

import 'dart:convert';

KomentModels komentModelsFromJson(String str) =>
    KomentModels.fromJson(json.decode(str));

String komentModelsToJson(KomentModels data) => json.encode(data.toJson());

class KomentModels {
  KomentModels({
    required this.pesan,
    required this.data,
    required this.countall,
    required this.status,
  });

  String pesan;
  List<Datum> data;
  int countall;
  bool status;

  factory KomentModels.fromJson(Map<String, dynamic> json) => KomentModels(
        pesan: json["pesan"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        countall: json["countall"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "pesan": pesan,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "countall": countall,
        "status": status,
      };
}

class Datum {
  Datum({
    required this.komentarId,
    required this.komentarNama,
    required this.komentarIsi,
    required this.komentarTanggal,
    required this.source,
    required this.photo,
  });

  String komentarId;
  String komentarNama;
  String komentarIsi;
  String komentarTanggal;
  String source;
  String photo;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        komentarId: json["komentar_id"],
        komentarNama: json["komentar_nama"],
        komentarIsi: json["komentar_isi"],
        komentarTanggal: json["komentar_tanggal"],
        source: json["source"],
        photo: json["photo"],
      );

  Map<String, dynamic> toJson() => {
        "komentar_id": komentarId,
        "komentar_nama": komentarNama,
        "komentar_isi": komentarIsi,
        "komentar_tanggal": komentarTanggal,
        "source": source,
        "photo": photo,
      };
}
