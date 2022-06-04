// To parse this JSON data, do
//
//     final infoSekolah = infoSekolahFromJson(jsonString);

import 'dart:convert';

InfoSekolah infoSekolahFromJson(String str) =>
    InfoSekolah.fromJson(json.decode(str));

String infoSekolahToJson(InfoSekolah data) => json.encode(data.toJson());

class InfoSekolah {
  InfoSekolah({
    required this.status,
    required this.pesan,
    required this.sistem,
    required this.website,
    required this.alamat,
    required this.email,
    required this.telpon,
    required this.descLogin,
    required this.descKontak,
    required this.descSingkat,
    required this.instagram,
    required this.facebook,
    required this.youtube,
    required this.logo,
    required this.logoHeader,
  });

  bool status;
  String pesan;
  String sistem;
  String website;
  String alamat;
  String email;
  String telpon;
  String descLogin;
  String descKontak;
  String descSingkat;
  String instagram;
  String facebook;
  String youtube;
  String logo;
  String logoHeader;

  factory InfoSekolah.fromJson(Map<String, dynamic> json) => InfoSekolah(
        status: json["status"],
        pesan: json["pesan"],
        sistem: json["sistem"],
        website: json["website"],
        alamat: json["alamat"],
        email: json["email"],
        telpon: json["telpon"],
        descLogin: json["desc_login"],
        descKontak: json["desc_kontak"],
        descSingkat: json["desc_singkat"],
        instagram: json["instagram"],
        facebook: json["facebook"],
        youtube: json["youtube"],
        logo: json["logo"],
        logoHeader: json["logo_header"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "pesan": pesan,
        "sistem": sistem,
        "website": website,
        "alamat": alamat,
        "email": email,
        "telpon": telpon,
        "desc_login": descLogin,
        "desc_kontak": descKontak,
        "desc_singkat": descSingkat,
        "instagram": instagram,
        "facebook": facebook,
        "youtube": youtube,
        "logo": logo,
        "logo_header": logoHeader,
      };
}
