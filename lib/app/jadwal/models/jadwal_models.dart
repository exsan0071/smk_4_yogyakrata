// To parse this JSON data, do
//
//     final jadwalTody = jadwalTodyFromJson(jsonString);

import 'dart:convert';

JadwalTody jadwalTodyFromJson(String str) =>
    JadwalTody.fromJson(json.decode(str));

String jadwalTodyToJson(JadwalTody data) => json.encode(data.toJson());

class JadwalTody {
  JadwalTody({
    required this.status,
    required this.pesan,
    required this.data,
  });

  bool status;
  String pesan;
  List<Datum> data;

  factory JadwalTody.fromJson(Map<String, dynamic> json) => JadwalTody(
        status: json["status"],
        pesan: json["pesan"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "pesan": pesan,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  Datum({
    required this.hari,
    required this.jadwal,
  });

  String hari;
  List<Jadwal> jadwal;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        hari: json["hari"],
        jadwal:
            List<Jadwal>.from(json["jadwal"].map((x) => Jadwal.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "hari": hari,
        "jadwal": List<dynamic>.from(jadwal.map((x) => x.toJson())),
      };
}

class Jadwal {
  Jadwal({
    required this.jamMulai,
    required this.jamSelesai,
    required this.namaPelajaran,
    required this.namaGuru,
  });

  String jamMulai;
  String jamSelesai;
  String namaPelajaran;
  String namaGuru;

  factory Jadwal.fromJson(Map<String, dynamic> json) => Jadwal(
        jamMulai: json["jam_mulai"],
        jamSelesai: json["jam_selesai"],
        namaPelajaran: json["nama_pelajaran"],
        namaGuru: json["nama_guru"],
      );

  Map<String, dynamic> toJson() => {
        "jam_mulai": jamMulai,
        "jam_selesai": jamSelesai,
        "nama_pelajaran": namaPelajaran,
        "nama_guru": namaGuru,
      };
}
