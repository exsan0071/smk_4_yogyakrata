import 'package:json_annotation/json_annotation.dart';

part 'detail.g.dart';

@JsonSerializable()
class DetailMateri {
  final String detail;

  DetailMateri({
    required this.detail,
  });
  factory DetailMateri.fromJson(Map<String, dynamic> json) =>
      _$DetailMateriFromJson(json);
  Map<String, dynamic> toJson() => _$DetailMateriToJson(this);
}
