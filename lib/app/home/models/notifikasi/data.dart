import 'package:json_annotation/json_annotation.dart';
import '../notifikasi/waktu.dart';
part 'data.g.dart';

@JsonSerializable(explicitToJson: true)
class Data {
  final String dari;
  final String detail;
  final Waktu waktu;

  Data({
    required this.dari,
    required this.detail,
    required this.waktu,
  });
  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);
  Map<String, dynamic> toJson() => _$DataToJson(this);
}
