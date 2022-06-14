// To parse this JSON data, do
//
//     final auth = authFromJson(jsonString);

import 'dart:convert';

Auth authFromJson(String str) => Auth.fromJson(json.decode(str));

String authToJson(Auth data) => json.encode(data.toJson());

class Auth {
  Auth({
    required this.status,
    required this.token,
    required this.pesan,
  });

  String status;
  String token;
  String pesan;

  factory Auth.fromJson(Map<String, dynamic> json) => Auth(
        status: json["status"].toString(),
        token: json["token"].toString(),
        pesan: json["pesan"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "token": token,
        "pesan": pesan,
      };
}
