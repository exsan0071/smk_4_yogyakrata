// To parse this JSON data, do
//
//     final soalEssay = soalEssayFromJson(jsonString);

import 'dart:convert';

SoalEssay soalEssayFromJson(String str) => SoalEssay.fromJson(json.decode(str));

String soalEssayToJson(SoalEssay data) => json.encode(data.toJson());

class SoalEssay {
  SoalEssay({
    required this.status,
    required this.data,
  });

  bool status;
  Data data;

  factory SoalEssay.fromJson(Map<String, dynamic> json) => SoalEssay(
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
    required this.jawabansaya,
    required this.soalTipe,
    required this.waktu,
    required this.statusTes,
  });

  String judul;
  String kelas;
  String jurusan;
  String pesan;
  Soal soal;
  Jawabansaya jawabansaya;
  String soalTipe;
  Waktu waktu;
  String statusTes;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        judul: json["judul"].toString(),
        kelas: json["kelas"].toString(),
        jurusan: json["jurusan"].toString(),
        pesan: json["pesan"].toString(),
        soal: Soal.fromJson(json["soal"]),
        jawabansaya: Jawabansaya.fromJson(json["jawabansaya"]),
        soalTipe: json["soal_tipe"].toString(),
        waktu: Waktu.fromJson(json["waktu"]),
        statusTes: json["status_tes"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "judul": judul,
        "kelas": kelas,
        "jurusan": jurusan,
        "pesan": pesan,
        "soal": soal.toJson(),
        "jawabansaya": jawabansaya.toJson(),
        "soal_tipe": soalTipe,
        "waktu": waktu.toJson(),
        "status_tes": statusTes,
      };
}

class Jawabansaya {
  Jawabansaya({
    required this.progress,
    required this.filejawban,
    required this.linkexternal,
    required this.keterangan,
  });

  int progress;
  String filejawban;
  String linkexternal;
  String keterangan;

  factory Jawabansaya.fromJson(Map<String, dynamic> json) => Jawabansaya(
        progress: json["progress"],
        filejawban: json["filejawban"].toString(),
        linkexternal: json["linkexternal"].toString(),
        keterangan: json["keterangan"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "progress": progress,
        "filejawban": filejawban,
        "linkexternal": linkexternal,
        "keterangan": keterangan,
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
