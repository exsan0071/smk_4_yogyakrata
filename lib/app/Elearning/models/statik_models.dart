// To parse this JSON data, do
//
//     final statistik = statistikFromJson(jsonString);

import 'dart:convert';

Statistik statistikFromJson(String str) => Statistik.fromJson(json.decode(str));
String statistikToJson(Statistik data) => json.encode(data.toJson());

class Statistik {
  Statistik({
    required this.status,
    required this.data,
    required this.pesan,
  });

  bool status;
  Data data;
  String pesan;

  factory Statistik.fromJson(Map<String, dynamic> json) => Statistik(
        status: json["status"],
        data: Data.fromJson(json["data"]),
        pesan: json["pesan"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data.toJson(),
        "pesan": pesan,
      };
}

class Data {
  Data({
    required this.tahun,
    required this.semester,
    required this.statistik,
  });

  String tahun;
  String semester;
  StatistikClass statistik;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        tahun: json["tahun"],
        semester: json["semester"],
        statistik: StatistikClass.fromJson(json["statistik"]),
      );

  Map<String, dynamic> toJson() => {
        "tahun": tahun,
        "semester": semester,
        "statistik": statistik.toJson(),
      };
}

class StatistikClass {
  StatistikClass({
    required this.semuaTugas,
    required this.belumDikerjakan,
    required this.jumlahRemidi,
    required this.remidiSelesai,
  });

  int semuaTugas;
  int belumDikerjakan;
  int jumlahRemidi;
  int remidiSelesai;

  factory StatistikClass.fromJson(Map<String, dynamic> json) => StatistikClass(
        semuaTugas: json["semua_tugas"],
        belumDikerjakan: json["belum_dikerjakan"],
        jumlahRemidi: json["jumlah_remidi"],
        remidiSelesai: json["remidi_selesai"],
      );

  Map<String, dynamic> toJson() => {
        "semua_tugas": semuaTugas,
        "belum_dikerjakan": belumDikerjakan,
        "jumlah_remidi": jumlahRemidi,
        "remidi_selesai": remidiSelesai,
      };
}
