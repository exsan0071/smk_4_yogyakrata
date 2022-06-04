// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tugas.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Tugas _$TugasFromJson(Map<String, dynamic> json) => Tugas(
      idTugas: json["id_tugas"].toString(),
      idkbm: json["idkbm"].toString(),
      judul: json["judul"].toString(),
      namaGuru: json["nama_guru"].toString(),
      namaPelajaran: json["nama_pelajaran"].toString(),
      statusWaktu: json["status_waktu"].toString(),
      startDate: json["start_date"].toString(),
      endDate: json["end_date"].toString(),
      startTime: json["start_time"].toString(),
      endTime: json["end_time"].toString(),
      idkelas: json["idkelas"].toString(),
      kategoriSoal: json["kategori_soal"].toString(),
      waktuMengerjakan: json["waktu_mengerjakan"].toString(),
      statusWaktuMengerjakan: json["status_waktu_mengerjakan"].toString(),
      statusMengerjakan: json["status_mengerjakan"].toString(),
      statusRemidi: json["status_remidi"].toString(),
      statusResume: json["status_resume"],
    );

Map<String, dynamic> _$TugasToJson(Tugas instance) => <String, dynamic>{
      'idTugas': instance.idTugas,
      'idkbm': instance.idkbm,
      'judul': instance.judul,
      'namaGuru': instance.namaGuru,
      'namaPelajaran': instance.namaPelajaran,
      'statusWaktu': instance.statusWaktu,
      'startDate': instance.startDate,
      'endDate': instance.endDate,
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'idkelas': instance.idkelas,
      'kategoriSoal': instance.kategoriSoal,
      'waktuMengerjakan': instance.waktuMengerjakan,
      'statusWaktuMengerjakan': instance.statusWaktuMengerjakan,
      'statusMengerjakan': instance.statusMengerjakan,
      'statusRemidi': instance.statusRemidi,
      'statusResume': instance.statusResume,
    };
