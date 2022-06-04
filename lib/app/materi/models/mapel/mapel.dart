import 'package:json_annotation/json_annotation.dart';

part 'mapel.g.dart';

@JsonSerializable()
class Mapel {
  final String id;
  final String nama;
  final String img;
  final String idkelas;

  Mapel({
    required this.id,
    required this.nama,
    required this.img,
    required this.idkelas,
  });
  factory Mapel.fromJson(Map<String, dynamic> json) => _$MapelFromJson(json);
  Map<String, dynamic> toJson() => _$MapelToJson(this);
}
