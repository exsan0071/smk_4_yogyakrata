import 'package:json_annotation/json_annotation.dart';

part 'file.g.dart';

@JsonSerializable()
class FileMateri {
  final String fileextension;
  late final String media;
  final String dataurl;

 FileMateri({
    required this.fileextension,
    required this.media,
    required this.dataurl,
  });
  factory FileMateri.fromJson(Map<String, dynamic> json) =>
      _$FileMateriFromJson(json);
  Map<String, dynamic> toJson() => _$FileMateriToJson(this);
}
