// To parse this JSON data, do
//
//     final riwayatPengerjaan = riwayatPengerjaanFromJson(jsonString);

import 'dart:convert';

RiwayatPengerjaan riwayatPengerjaanFromJson(String str) =>
    RiwayatPengerjaan.fromJson(json.decode(str));

String riwayatPengerjaanToJson(RiwayatPengerjaan data) =>
    json.encode(data.toJson());

class RiwayatPengerjaan {
  RiwayatPengerjaan({
    required this.status,
    required this.data,
  });

  bool status;
  Data data;

  factory RiwayatPengerjaan.fromJson(Map<String, dynamic> json) =>
      RiwayatPengerjaan(
        status: json["status"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data.toJson(),
      };
}

class Data {
  Data({
    required this.opsijawaban,
  });

  Opsijawaban opsijawaban;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        opsijawaban: Opsijawaban.fromJson(json["opsijawaban"]),
      );

  Map<String, dynamic> toJson() => {
        "opsijawaban": opsijawaban.toJson(),
      };
}

class Opsijawaban {
  Opsijawaban({
    required this.nomor,
    required this.opsi,
  });

  int nomor;
  Opsi opsi;

  factory Opsijawaban.fromJson(Map<String, dynamic> json) => Opsijawaban(
        nomor: json["nomor"],
        opsi: Opsi.fromJson(json["opsi"]),
      );

  Map<String, dynamic> toJson() => {
        "nomor": nomor,
        "opsi": opsi.toJson(),
      };
}

class Opsi {
  Opsi({
    required this.key,
    required this.jawab,
    required this.status,
  });

  String key;
  String jawab;
  String status;

  factory Opsi.fromJson(Map<String, dynamic> json) => Opsi(
        key: json["key"],
        jawab: json["jawab"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "key": key,
        "jawab": jawab,
        "status": status,
      };
}
