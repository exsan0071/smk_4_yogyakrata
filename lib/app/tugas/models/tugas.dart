import 'package:json_annotation/json_annotation.dart';

part 'tugas.g.dart';

@JsonSerializable()
class Tugas {
  final String idTugas;
  final String idkbm;
  final String judul;
  final String namaGuru;
  final String namaPelajaran;
  final String statusWaktu;
  final String startDate;
  final String endDate;
  final String startTime;
  final String endTime;
  final String idkelas;
  final String kategoriSoal;
  final String waktuMengerjakan;
  final String statusWaktuMengerjakan;
  final String statusMengerjakan;
  final String statusRemidi;
  final int statusResume;

  Tugas({
    required this.idTugas,
    required this.idkbm,
    required this.judul,
    required this.namaGuru,
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
  factory Tugas.fromJson(Map<String, dynamic> json) => _$TugasFromJson(json);
  Map<String, dynamic> toJson() => _$TugasToJson(this);
}
