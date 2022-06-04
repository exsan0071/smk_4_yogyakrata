// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'waktu.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Waktu _$WaktuFromJson(Map<String, dynamic> json) => Waktu(
      statuswaktu: json['status_waktu'] as String,
      startdate: json['start_date'] as String,
      enddate: json['end_date'] as String,
      starttime: json['start_time'] as String,
      endtime: json['end_time'] as String,
    );

Map<String, dynamic> _$WaktuToJson(Waktu instance) => <String, dynamic>{
      'status_waktu': instance.statuswaktu,
      'start_date': instance.startdate,
      'end_date': instance.enddate,
      'start_time': instance.starttime,
      'end_time': instance.endtime,
    };
