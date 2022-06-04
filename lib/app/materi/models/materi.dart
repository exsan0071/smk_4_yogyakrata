import 'package:json_annotation/json_annotation.dart';

part 'materi.g.dart';

@JsonSerializable()
class Materi {
  final String id;
  final String judul;
  final String modified;
  final String namaguru;
  final String namapelajaran;
  late final String materitype;

  Materi({
    required this.id,
    required this.judul,
    required this.modified,
    required this.namaguru,
    required this.namapelajaran,
    required this.materitype,
  });
  factory Materi.fromJson(Map<String, dynamic> json) => _$MateriFromJson(json);
  Map<String, dynamic> toJson() => _$MateriToJson(this);
}
