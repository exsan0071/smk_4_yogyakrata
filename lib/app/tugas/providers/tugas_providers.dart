import '../../tugas/models/soalessay.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../controller/baselink.dart';
import '../../tugas/models/tugas_models.dart';
import '../../tugas/models/tugas_selesai_models.dart';
import '../controller/tugas_controller.dart';
import '../models/detail_tugas.dart';
import '../models/soaloptions.dart';

class TugasProvider {
  final TugasController tugasC = Get.put(TugasController());
  final BaseLInkController baseLinkC = Get.put(BaseLInkController());
  //link data base api
  // ignore: body_might_complete_normally_nullable
  Future<TugasSiswa?> getTugas(String offset) async {
    final _baseUrl =
        baseLinkC.baseUrlUrlLaucer3 + '/api/tugas?offset=$offset&limit=5';
    // try {
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
      final data = tugasSiswaFromJson(response.body);
      return data;
    }
    // } catch (e) {
    //   // ignore: avoid_print
    //   print(e.toString());
    // }
  }

  // ignore: body_might_complete_normally_nullable
  Future<TugasSiswaSelesai?> getTugasSelesai(String offset) async {
    final _baseUrl = baseLinkC.baseUrlUrlLaucer3 +
        '/api/tugas/selesai?offset=$offset&limit=5';
    // try {
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
      final data = tugasSiswaSelesaiFromJson(response.body);

      return data;
    }
    // } catch (e) {
    //   // ignore: avoid_print
    //   print(e.toString());
    // }
  }

  // ignore: body_might_complete_normally_nullable
  Future<TugasDetail?> getDetailTugas(String id) async {
    final _baseUrl =
        baseLinkC.baseUrlUrlLaucer3 + '/api/tugas/detail?idtugas= $id';
    // try {
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
      final data = tugasDetailFromJson(response.body);

      return data;
    }
    // } catch (e) {
    //   // ignore: avoid_print
    //   print(e.toString());
    // }
  }

  // ignore: body_might_complete_normally_nullable
  Future<GetOptions?> soalOptions(String id) async {
    final _baseUrl =
        baseLinkC.baseUrlUrlLaucer3 + "/api/tugas/kerjakan?idtugas=$id";
    // try {
    SharedPreferences getToken = await SharedPreferences.getInstance();
    // ignore: unused_local_variable
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
      final data = getOptionsFromJson(response.body);

      return data;
    }
    // } catch (e) {
    //   print(e.toString());
    // }
  }

  // ignore: body_might_complete_normally_nullable
  Future<SoalEssay?> soalEssay(String id) async {
    final _baseUrl =
        baseLinkC.baseUrlUrlLaucer3 + "/api/tugas/kerjakan?idtugas=$id";
    // try {
    SharedPreferences getToken = await SharedPreferences.getInstance();
    // ignore: unused_local_variable
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
      final data = soalEssayFromJson(response.body);

      return data;
    }
    // } catch (e) {
    //   print(e.toString());
    // }
  }

  Future addJawaban(
    String id,
    String nomor,
    String jawab,
  ) async {
    // try {
    SharedPreferences getToken = await SharedPreferences.getInstance();
    // ignore: unused_local_variable
    String? auth = getToken.getString("token");
    final headers = {
      'Content-Type': 'multipart/form-data',
      'Accept': 'application/json',
      'Authorization': '$auth',
    };
    var request = http.MultipartRequest(
        'POST', Uri.parse(baseLinkC.baseUrlUrlLaucer3 + "/api/tugas/kerjakan"));
    request.fields.addAll({
      'idtugas': id,
      'nomor': nomor,
      'jawab': jawab,
    });
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      // ignore: avoid_print
      print(await response.stream.bytesToString());
    } else {
      // ignore: avoid_print
      print(response.reasonPhrase);
    }
    // } catch (e) {
    //   // ignore: avoid_print
    //   print(e.toString());
    // }
  }

  Future addJawabanFinis(
      String id, String nomor, String jawab, bool akhiri) async {
    // try {
    SharedPreferences getToken = await SharedPreferences.getInstance();
    // ignore: unused_local_variable
    String? auth = getToken.getString("token");
    final headers = {
      'Content-Type': 'multipart/form-data',
      'Accept': 'application/json',
      'Authorization': '$auth',
    };
    var request = http.MultipartRequest(
        'POST', Uri.parse(baseLinkC.baseUrlUrlLaucer3 + "/api/tugas/kerjakan"));
    request.fields.addAll({
      'idtugas': id,
      'nomor': nomor,
      'jawab': jawab,
      'simpan_akhir': akhiri.toString()
    });
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      // ignore: avoid_print
      print(await response.stream.bytesToString());
    } else {
      // ignore: avoid_print
      print(response.reasonPhrase);
    }
    // } catch (e) {
    //   // ignore: avoid_print
    //   print(e.toString());
    // }
  }
}
