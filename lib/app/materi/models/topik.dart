import 'package:json_annotation/json_annotation.dart';

part 'topik.g.dart';

@JsonSerializable()
class Topik {
  final String id;
  final String nama;

  Topik({
    required this.id,
    required this.nama,
  
  });
  factory Topik.fromJson(Map<String, dynamic> json) => _$TopikFromJson(json);
  Map<String, dynamic> toJson() => _$TopikToJson(this);
}
