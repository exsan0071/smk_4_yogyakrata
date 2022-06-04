import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../controller/baselink.dart';

import '../../status/controller/controller.dart';
import '../../status/models/kometar_models.dart';

class GetCommment {
  final StatusController statusC = Get.put(StatusController());
  final BaseLInkController baseLinkC = Get.put(BaseLInkController());
  //link data base api
  // ignore: body_might_complete_normally_nullable
  Future<KomentModels?> getKomentar(String id) async {
    final _baseUrl = baseLinkC.baseUrlUrlLaucer3 +
        '/api/status/komen?id=$id&tipe=status&offset=0';

    try {
      SharedPreferences getToken = await SharedPreferences.getInstance();
      String? auth = getToken.getString("token");
      final response = await http.get(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': '$auth',
        },
      );
      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        final data = komentModelsFromJson(response.body);
        // ignore: avoid_print
        print(data.status);
        return data;
      }
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }
  }
}
