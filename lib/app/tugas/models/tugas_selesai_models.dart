// To parse this JSON data, do
//
//     final tugasSiswaSelesai = tugasSiswaSelesaiFromJson(jsonString);

import 'dart:convert';

TugasSiswaSelesai tugasSiswaSelesaiFromJson(String str) =>
    TugasSiswaSelesai.fromJson(json.decode(str));

String tugasSiswaSelesaiToJson(TugasSiswaSelesai data) =>
    json.encode(data.toJson());

class TugasSiswaSelesai {
  TugasSiswaSelesai({
    required this.status,
    required this.pesan,
    required this.data,
    required this.total,
  });

  bool status;
  String pesan;
  List<Datum> data;
  int total;

  factory TugasSiswaSelesai.fromJson(Map<String, dynamic> json) =>
      TugasSiswaSelesai(
        status: json["status"],
        pesan: json["pesan"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "pesan": pesan,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "total": total,
      };
}

class Datum {
  Datum({
    required this.idTugas,
    required this.idkbm,
    required this.judul,
    required this.namaGuru,
    this.avatarGuru,
    required this.namaPelajaran,
    required this.statusWaktu,
    required this.startDate,
    required this.endDate,
    required this.startTime,
    required this.endTime,
    required this.idkelas,
    required this.kategoriSoal,
    required this.waktuMengerjakan,
    required this.statusWaktuMengerjakan,
    required this.statusMengerjakan,
    required this.statusRemidi,
    required this.statusResume,
  });

  String idTugas;
  String idkbm;
  String judul;
  String namaGuru;
  dynamic avatarGuru;
  String namaPelajaran;
  String statusWaktu;
  DateTime startDate;
  DateTime endDate;
  String startTime;
  String endTime;
  String idkelas;
  String kategoriSoal;
  String waktuMengerjakan;
  String statusWaktuMengerjakan;
  String statusMengerjakan;
  String statusRemidi;
  int statusResume;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        idTugas: json["id_tugas"],
        idkbm: json["idkbm"],
        judul: json["judul"],
        namaGuru: json["nama_guru"],
        avatarGuru: json["avatar_guru"],
        namaPelajaran: json["nama_pelajaran"],
        statusWaktu: json["status_waktu"],
        startDate: DateTime.parse(json["start_date"]),
        endDate: DateTime.parse(json["end_date"]),
        startTime: json["start_time"],
        endTime: json["end_time"],
        idkelas: json["idkelas"],
        kategoriSoal: json["kategori_soal"],
        waktuMengerjakan: json["waktu_mengerjakan"],
        statusWaktuMengerjakan: json["status_waktu_mengerjakan"],
        statusMengerjakan: json["status_mengerjakan"],
        statusRemidi: json["status_remidi"],
        statusResume: json["status_resume"],
      );

  Map<String, dynamic> toJson() => {
        "id_tugas": idTugas,
        "idkbm": idkbm,
        "judul": judul,
        "nama_guru": namaGuru,
        "avatar_guru": avatarGuru,
        "nama_pelajaran": namaPelajaran,
        "status_waktu": statusWaktu,
        "start_date":
            "${startDate.year.toString().padLeft(4, '0')}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}",
        "end_date":
            "${endDate.year.toString().padLeft(4, '0')}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')}",
        "start_time": startTime,
        "end_time": endTime,
        "idkelas": idkelas,
        "kategori_soal": kategoriSoal,
        "waktu_mengerjakan": waktuMengerjakan,
        "status_waktu_mengerjakan": statusWaktuMengerjakan,
        "status_mengerjakan": statusMengerjakan,
        "status_remidi": statusRemidi,
        "status_resume": statusResume,
      };
}
