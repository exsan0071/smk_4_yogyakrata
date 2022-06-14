// To parse this JSON data, do
//
//     final getOptions = getOptionsFromJson(jsonString);

import 'dart:convert';

GetOptions getOptionsFromJson(String str) =>
    GetOptions.fromJson(json.decode(str));

String getOptionsToJson(GetOptions data) => json.encode(data.toJson());

class GetOptions {
  GetOptions({
    required this.status,
    required this.data,
  });

  bool status;
  Data data;

  factory GetOptions.fromJson(Map<String, dynamic> json) => GetOptions(
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
    required this.judul,
    required this.kelas,
    required this.jurusan,
    required this.pesan,
    required this.soal,
    required this.opsijawaban,
    required this.soalTipe,
    required this.waktu,
    required this.statusTes,
  });

  String judul;
  String kelas;
  String jurusan;
  String pesan;
  Soal soal;
  List<Opsijawaban> opsijawaban;
  String soalTipe;
  Waktu waktu;
  String statusTes;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        judul: json["judul"].toString(),
        kelas: json["kelas"].toString(),
        jurusan: json["jurusan"].toString(),
        pesan: json["pesan"].toString(),
        soal: Soal.fromJson(json["soal"]),
        opsijawaban: List<Opsijawaban>.from(
            json["opsijawaban"].map((x) => Opsijawaban.fromJson(x))),
        soalTipe: json["soal_tipe"].toString(),
        waktu: Waktu.fromJson(json["waktu"]),
        statusTes: json["status_tes"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "judul": judul,
        "kelas": kelas,
        "jurusan": jurusan,
        "pesan": pesan.toString(),
        "soal": soal.toJson(),
        "opsijawaban": List<dynamic>.from(opsijawaban.map((x) => x.toJson())),
        "soal_tipe": soalTipe,
        "waktu": waktu.toJson(),
        "status_tes": statusTes,
      };
}

class Opsijawaban {
  Opsijawaban({
    required this.nomor,
    required this.opsi,
  });

  int nomor;
  List<Opsi> opsi;

  factory Opsijawaban.fromJson(Map<String, dynamic> json) => Opsijawaban(
        nomor: json["nomor"],
        opsi: List<Opsi>.from(json["opsi"].map((x) => Opsi.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "nomor": nomor,
        "opsi": List<dynamic>.from(opsi.map((x) => x.toJson())),
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
        key: json["key"].toString(),
        jawab: json["jawab"].toString(),
        status: json["status"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "key": key,
        "jawab": jawab,
        "status": status,
      };
}

class Soal {
  Soal({
    required this.file,
    required this.status,
    required this.ext,
    required this.type,
    required this.pesan,
    required this.text,
  });

  String file;
  bool status;
  String ext;
  String type;
  String pesan;
  String text;

  factory Soal.fromJson(Map<String, dynamic> json) => Soal(
        file: json["file"].toString(),
        status: json["status"],
        ext: json["ext"].toString(),
        type: json["type"].toString(),
        pesan: json["pesan"].toString(),
        text: json["text"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "file": file,
        "status": status,
        "ext": ext,
        "type": type,
        "pesan": pesan,
      };
}

class Waktu {
  Waktu({
    required this.startTanggal,
    required this.endTanggal,
    required this.startTime,
    required this.endTime,
    required this.status,
    required this.waktuStatus,
  });

  String startTanggal;
  String endTanggal;
  String startTime;
  String endTime;
  String status;
  String waktuStatus;

  factory Waktu.fromJson(Map<String, dynamic> json) => Waktu(
        startTanggal: json["start_tanggal"].toString(),
        endTanggal: json["end_tanggal"].toString(),
        startTime: json["start_time"].toString(),
        endTime: json["end_time"].toString(),
        status: json["status"].toString(),
        waktuStatus: json["waktu_status"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "start_tanggal": startTanggal,
        "end_tanggal": endTanggal,
        "start_time": startTime,
        "end_time": endTime,
        "status": status,
        "waktu_status": waktuStatus,
      };
}
