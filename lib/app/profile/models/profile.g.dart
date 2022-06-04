// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Profile _$ProfileFromJson(Map<String, dynamic> json) => Profile(
      nis: json['nis'].toString(),
      namasiswa: json['nama_siswa'].toString(),
      tempatlahir: json['tempat_lahir'].toString(),
      tgllahir: json['tgl_lahir'].toString(),
      jeniskelamin: json['jenis_kelamin'].toString(),
      agama: json['agama'].toString(),
      alamatasli: json['alamat_asli'].toString(),
      alamattinggal: json['alamat_tinggal'].toString(),
      phone: json['phone'].toString(),
      sekolahasal: json['sekolah_asal'].toString(),
      tahunmasuk: json['tahun_masuk'].toString(),
      namaibu: json['nama_ibu'].toString(),
      photo: json['photo'].toString(),
    );

Map<String, dynamic> _$ProfileToJson(Profile instance) => <String, dynamic>{
      'nis': instance.nis,
      'nama_siswa': instance.namasiswa,
      'tempat_lahir': instance.tempatlahir,
      'tgl_lahir': instance.tgllahir,
      'jenis_kelamin': instance.jeniskelamin,
      'agama': instance.agama,
      'alamat_asli': instance.alamatasli,
      'alamat_tinggal': instance.alamattinggal,
      'phone': instance.phone,
      'sekolah_asal': instance.sekolahasal,
      'tahun_masuk': instance.tahunmasuk,
      'nama_ibu': instance.namaibu,
      'photo': instance.photo,
    };
