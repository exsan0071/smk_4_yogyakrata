import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../controller/baselink.dart';

import '../models/notifikasi/data.dart';
import '../controller/home_controller.dart';

class GetDataHome {
  //link data base api
  final HomeController homeC = Get.put(HomeController());
  final BaseLInkController baseLinkC = Get.put(BaseLInkController());

  // ignore: body_might_complete_normally_nullable
  Future<List<Data>?> getNotifikasi() async {
    SharedPreferences getToken = await SharedPreferences.getInstance();
    String? auth = getToken.getString("token");
    final response = await http.get(
      Uri.parse(baseLinkC.baseUrlUrlLaucer3 + '/api/notifikasi'),
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
        List<Data> dataUserBlog =
            it.map((value) => Data.fromJson(value)).toList();
        return dataUserBlog;
      } catch (e) {
        // ignore: avoid_print
        print(e.toString());
      }
    }
  }
}
