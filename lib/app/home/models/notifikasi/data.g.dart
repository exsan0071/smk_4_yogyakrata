// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Data _$DataFromJson(Map<String, dynamic> json) => Data(
      dari: json['dari'] as String,
      detail: json['detail'] as String,
      waktu: Waktu.fromJson(json['waktu'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
      'dari': instance.dari,
      'detail': instance.detail,
      'waktu': instance.waktu.toJson(),
    };
