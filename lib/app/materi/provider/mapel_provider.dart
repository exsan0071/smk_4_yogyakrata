import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../controller/baselink.dart';

import '../../materi/models/mapel/mapel.dart';

class GetDataMapel {
  //link data base api
  final BaseLInkController baseLinkC = Get.put(BaseLInkController());
  // ignore: body_might_complete_normally_nullable
  Future<List<Mapel>?> getDataMapel(String limit) async {
    SharedPreferences getToken = await SharedPreferences.getInstance();
    String? auth = getToken.getString("token");
    final urlMapel = baseLinkC.baseUrlUrlLaucer3 + "/api/mapel?limit=$limit";
    final response = await http.get(
      Uri.parse(urlMapel),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': '$auth',
      },
    );
    if (response.statusCode != 200) {
      return null;
    } else {
      Iterable it = jsonDecode(response.body)['data'];
      try {
        List<Mapel> dataMapel =
            it.map((value) => Mapel.fromJson(value)).toList();

        return dataMapel;
      } catch (e) {
        // ignore: avoid_print
        print(e.toString());
      }
    }
  }
}
