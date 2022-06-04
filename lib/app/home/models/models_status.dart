// To parse this JSON data, do
//
//     final statusSiswa = statusSiswaFromJson(jsonString);

import 'dart:convert';
StatusSiswa statusSiswaFromJson(String str) =>
    StatusSiswa.fromJson(json.decode(str));
String statusSiswaToJson(StatusSiswa data) => json.encode(data.toJson());

class StatusSiswa {
  StatusSiswa({
    required this.data,
    required this.pesan,
    required this.status,
  });
  List<Datum> data;
  String pesan;
  bool status;
  factory StatusSiswa.fromJson(Map<String, dynamic> json) => StatusSiswa(
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        pesan: json["pesan"],
        status: json["status"],
      );
  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "pesan": pesan,
        "status": status,
      };
}

class Datum {
  Datum({
    required this.id,
    required this.author,
    required this.nama,
    required this.tipe,
    required this.judul,
    required this.detail,
    required this.tanggal,
    required this.komencount,
    required this.img,
  });

  int id;
  String author;
  String nama;
  String tipe;
  String judul;
  String detail;
  DateTime tanggal;
  int komencount;
  String img;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"]..toString(),
        author: json["author"].toString(),
        nama: json["nama"].toString(),
        tipe: json["tipe"].toString(),
        judul: json["judul"].toString(),
        detail: json["detail"].toString(),
        tanggal: DateTime.parse(json["tanggal"]),
        komencount: json["komencount"],
        img: json["img"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "author": author,
        "nama": nama,
        "tipe": tipe,
        "judul": judul,
        "detail": detail,
        "tanggal": tanggal.toIso8601String(),
        "komencount": komencount,
        "img": img,
      };
}
