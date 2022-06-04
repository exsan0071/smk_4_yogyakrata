import 'package:json_annotation/json_annotation.dart';

part 'profile.g.dart';

@JsonSerializable()
class Profile {
  final String nis;
  final String namasiswa;
  final String tempatlahir;
  final String tgllahir;
  final String jeniskelamin;
  final String agama;
  final String alamatasli;
  final String alamattinggal;
  final String phone;
  final String sekolahasal;
  final String tahunmasuk;
  final String namaibu;
  final String photo;

  Profile({
    required this.nis,
    required this.namasiswa,
    required this.tempatlahir,
    required this.tgllahir,
    required this.jeniskelamin,
    required this.agama,
    required this.alamatasli,
    required this.alamattinggal,
    required this.phone,
    required this.sekolahasal,
    required this.tahunmasuk,
    required this.namaibu,
    required this.photo,
  });
  factory Profile.fromJson(Map<String, dynamic> json) =>
      _$ProfileFromJson(json);
  Map<String, dynamic> toJson() => _$ProfileToJson(this);
}
