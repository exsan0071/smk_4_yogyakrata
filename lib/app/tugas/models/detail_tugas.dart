// To parse this JSON data, do
//
//     final tugasDetail = tugasDetailFromJson(jsonString);

import 'dart:convert';

TugasDetail tugasDetailFromJson(String str) =>
    TugasDetail.fromJson(json.decode(str));

String tugasDetailToJson(TugasDetail data) => json.encode(data.toJson());

class TugasDetail {
  TugasDetail({
    required this.status,
    required this.data,
    required this.pesan,
  });

  bool status;
  Data data;
  String pesan;

  factory TugasDetail.fromJson(Map<String, dynamic> json) => TugasDetail(
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
    required this.judul,
    required this.kelas,
    required this.jurusan,
    required this.tugasAvailable,
    required this.status,
    required this.pesan,
    required this.waktu,
    required this.soal,
    required this.jawaban,
  });

  String judul;
  String kelas;
  String jurusan;
  bool tugasAvailable;
  String status;
  String pesan;
  Waktu waktu;
  Soal soal;
  Jawaban jawaban;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        judul: json["judul"],
        kelas: json["kelas"],
        jurusan: json["jurusan"],
        tugasAvailable: json["tugas_available"],
        status: json["status"],
        pesan: json["pesan"],
        waktu: Waktu.fromJson(json["waktu"]),
        soal: Soal.fromJson(json["soal"]),
        jawaban: Jawaban.fromJson(json["jawaban"]),
      );

  Map<String, dynamic> toJson() => {
        "judul": judul,
        "kelas": kelas,
        "jurusan": jurusan,
        "tugas_available": tugasAvailable,
        "status": status,
        "pesan": pesan,
        "waktu": waktu.toJson(),
        "soal": soal.toJson(),
        "jawaban": jawaban.toJson(),
      };
}

class Jawaban {
  Jawaban({
    required this.dijawab,
    required this.persentase,
    required this.statusSusulan,
    required this.posisiSusulan,
    required this.statusRemidi,
    required this.posisiRemidi,
    required this.statusJawaban,
    required this.fileJawab,
  });

  String dijawab;
  int persentase;
  String statusSusulan;
  String posisiSusulan;
  String statusRemidi;
  String posisiRemidi;
  String statusJawaban;
  String fileJawab;

  factory Jawaban.fromJson(Map<String, dynamic> json) => Jawaban(
        dijawab: json["dijawab"].toString(),
        persentase: json["persentase"],
        statusSusulan: json["status_susulan"].toString(),
        posisiSusulan: json["posisi_susulan"].toString(),
        statusRemidi: json["statusRemidi"].toString(),
        posisiRemidi: json["posisiRemidi"].toString(),
        statusJawaban: json["status_jawaban"].toString(),
        fileJawab: json["file_jawab"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "dijawab": dijawab,
        "persentase": persentase,
        "status_susulan": statusSusulan,
        "posisi_susulan": posisiSusulan,
        "statusRemidi": statusRemidi,
        "posisiRemidi": posisiRemidi,
        "status_jawaban": statusJawaban,
        "file_jawab": fileJawab,
      };
}

class Soal {
  Soal({
    required this.soalTipe,
    required this.soalJumlah,
  });

  String soalTipe;
  int soalJumlah;

  factory Soal.fromJson(Map<String, dynamic> json) => Soal(
        soalTipe: json["soal_tipe"],
        soalJumlah: json["soal_jumlah"],
      );

  Map<String, dynamic> toJson() => {
        "soal_tipe": soalTipe,
        "soal_jumlah": soalJumlah,
      };
}

class Waktu {
  Waktu({
    required this.startTanggal,
    required this.endTanggal,
    required this.startTime,
    required this.endTime,
    required this.status,
  });

  String startTanggal;
  String endTanggal;
  String startTime;
  String endTime;
  String status;

  factory Waktu.fromJson(Map<String, dynamic> json) => Waktu(
        startTanggal: json["start_tanggal"],
        endTanggal: json["end_tanggal"],
        startTime: json["start_time"],
        endTime: json["end_time"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "start_tanggal": startTanggal,
        "end_tanggal": endTanggal,
        "start_time": startTime,
        "end_time": endTime,
        "status": status,
      };
}
