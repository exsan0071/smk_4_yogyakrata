import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../controller/baselink.dart';
import '../../materi/controller/materi.dart';
import 'dart:convert';

import '../../materi/models/detail/detail.dart';
import '../../materi/models/detail/file.dart';
import '../../materi/models/topik.dart';

class GetDataDetailMateri {
  final MateriController materiC = Get.put(MateriController());
  final BaseLInkController baseLinkC = Get.put(BaseLInkController());
  Future<DetailMateri?> getDataDetailMateri(String id) async {
    SharedPreferences getToken = await SharedPreferences.getInstance();
    String? auth = getToken.getString("token");
    final response = await http.get(
      Uri.parse(baseLinkC.baseUrlUrlLaucer3 + '/api/mapel/materidetail?id=$id'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': '$auth',
      },
    );
    // ignore: avoid_print
    print(response.statusCode);
    if (response.statusCode != 200) {
      return null;
    } else {
      Map<String, dynamic> data =
          (json.decode(response.body)['data'] as Map<String, dynamic>);

      return DetailMateri.fromJson(data);
    }
  }

  Future<List<FileMateri>?> getDatadetail(String id) async {
    SharedPreferences getToken = await SharedPreferences.getInstance();
    String? auth = getToken.getString("token");
    final response = await http.get(
      Uri.parse(baseLinkC.baseUrlUrlLaucer3 + '/api/mapel/materidetail?id=$id'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': '$auth',
      },
    );
    Iterable it = jsonDecode(response.body)['data']['file'];
    if (response.statusCode != 200) {
      return null;
    } else {
      List<FileMateri> dataDetailFile =
          it.map((value) => FileMateri.fromJson(value)).toList();

      return dataDetailFile;
    }
  }

  Future<void> getDataTopik(String idtopik) async {
    try {
      SharedPreferences getToken = await SharedPreferences.getInstance();
      String? auth = getToken.getString("token");
      final response = await http.get(
        Uri.parse(
            baseLinkC.baseUrlUrlLaucer3 + "/api/mapel/topik?idmapel=$idtopik"),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': '$auth',
        },
      );
      if (response.statusCode != 200) {
      } else {
        Iterable it = jsonDecode(response.body)['data'];

        for (Map<String, dynamic> i in it) {
          materiC.categoryListTopik.add(Topik.fromJson(i));
        }
      }
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }
  }
}
