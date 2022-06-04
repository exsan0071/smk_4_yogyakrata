import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../controller/baselink.dart';
import 'dart:convert';

import '../../profile/models/profile.dart';

class GetDataProflie {
  final BaseLInkController baseLinkC = Get.put(BaseLInkController());
  //link data base api

  // ignore: body_might_complete_normally_nullable
  Future<Profile?> getDataUserProfile() async {
    SharedPreferences getToken = await SharedPreferences.getInstance();
    String? auth = getToken.getString("token");
    try {
      final response = await http.get(
        Uri.parse(baseLinkC.baseUrlUrlLaucer3 + '/api/siswa/profil'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': '$auth',
        },
      );
      if (response.statusCode != 200) {
        // ignore: avoid_print
        print("TIDAK DAPAT DATA DARI SERVER");

        return null;
      } else {
        Map<String, dynamic> data =
            (json.decode(response.body)["biodata"] as Map<String, dynamic>);

        // ignore: avoid_print
        print("DAPAT DATA DARI SERVER");
        return Profile.fromJson(data);
      }
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }
  }
}
