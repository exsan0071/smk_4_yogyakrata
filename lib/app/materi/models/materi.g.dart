// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'materi.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Materi _$MateriFromJson(Map<String, dynamic> json) => Materi(
      id: json['id'] as String,
      judul: json['judul'] as String,
      modified: json['modified'] as String,
      namaguru: json['nama_guru'] as String,
      namapelajaran: json['nama_pelajaran'] as String,
      materitype: json['materi_type'] as String,
    );

Map<String, dynamic> _$MateriToJson(Materi instance) => <String, dynamic>{
      'id': instance.id,
      'judul': instance.judul,
      'modified': instance.modified,
      'nama_guru': instance.namaguru,
      'nama_pelajaran': instance.namapelajaran,
      'materi_type': instance.materitype,
    };
