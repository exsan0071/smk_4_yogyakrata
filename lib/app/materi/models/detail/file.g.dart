// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'file.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FileMateri _$FileMateriFromJson(Map<String, dynamic> json) => FileMateri(
      fileextension: json['file_extension'] as String,
      media: json['media'] as String,
      dataurl: json['data_url'] as String,
    );

Map<String, dynamic> _$FileMateriToJson(FileMateri instance) =>
    <String, dynamic>{
      'file_extension': instance.fileextension,
      'media': instance.media,
      'data_url': instance.dataurl,
    };
