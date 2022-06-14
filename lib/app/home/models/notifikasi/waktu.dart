import 'package:json_annotation/json_annotation.dart';

part 'waktu.g.dart';

@JsonSerializable()
class Waktu {
  final String statuswaktu;
  final String startdate;
  final String enddate;
  final String starttime;
  final String endtime;

  Waktu({
    required this.statuswaktu,
    required this.startdate,
    required this.enddate,
    required this.starttime,
    required this.endtime,
  });
  factory Waktu.fromJson(Map<String, dynamic> json) => _$WaktuFromJson(json);

  Map<String, dynamic> toJson() => _$WaktuToJson(this);
}
