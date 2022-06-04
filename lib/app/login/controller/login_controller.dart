import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:sn_progress_dialog/progress_dialog.dart';

import '../../controller/baselink.dart';
import '../../controller/introduction_creen/controller_ooboarding.dart';
import '../../controller/introduction_creen/loading_ooboarding.dart';
import '../../home/controller/loading.dart';
import '../models/auth.dart';
import '../models/jurusan_models.dart';

class LoginController extends GetxController {
  final BaseLInkController baseLinkC = Get.put(BaseLInkController());
  final OoboardingController ooboardingC = Get.put(OoboardingController());
  
  TextEditingController usernameControler = TextEditingController(text: '');
  TextEditingController passwordControler = TextEditingController(text: '');
  
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  
  String? selectedName;
  bool isGuru = true;
  bool isRemember = false;
  List<DataJurusan> categoryList = [];
  
  void tokenCache(String token) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    await localStorage.setString("token", token);
  }

  Future getUserJurusan() async {
    try {
      final response =
          await http.get(Uri.parse(baseLinkC.baseUrlUrlLaucer3 + '/api/kelas'));
      if (response.statusCode == 200) {
       final data = jsonDecode(response.body)['data'];
        for (Map<String, dynamic> i in data) {
         categoryList.add(DataJurusan.fromJson(i));
        }
      } else {
        // ignore: avoid_print
        print(response.body.toString());
      }
      update();
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

    Future login(BuildContext context) async {
    if (usernameControler.text.isEmpty ||
        passwordControler.text.isEmpty ||
        selectedName == null) {
      Alert(
          context: context,
          title: "Data Tidak Benar",
          type: AlertType.error,
          buttons: [
            DialogButton(
              child: Text(
                "OK",
                style: GoogleFonts.roboto(color: Colors.white, fontSize: 20),
              ),
              onPressed: () => Navigator.pop(context),
              color: Colors.blue,
            ),
          ]).show();
      return;
    }
    ProgressDialog pd = ProgressDialog(context: context);
    pd.show(
      max: 100,
      msg: 'Loading...',
      progressType: ProgressType.valuable,
    );
    await Future.delayed(const Duration(seconds: 2));
    final response = await http
        .post(Uri.parse(baseLinkC.baseUrlUrlLaucer3 + '/api/login'), body: {
      "username": usernameControler.text,
      "password": passwordControler.text,
      "kelas": selectedName,
    });
    pd.close();
    final auth = authFromJson(response.body);
    if (auth.status == 'true') {
      tokenCache(auth.token);
      SharedPreferences getToken = await SharedPreferences.getInstance();
      String? authLog = getToken.getString("token");
      if (authLog != null) {
        Navigator.pushReplacement(
            context,
            PageRouteBuilder(
                pageBuilder: (context, animation, secondartyAnimation) => Obx(
                    () => ooboardingC.isSkipIntro.isTrue
                        ? const LoadingHome()
                        : const LoadingOboarding())));
      }
    } else {
      Alert(
          context: context,
          title: "Username dan Password salah",
          type: AlertType.error,
          buttons: [
            DialogButton(
              child: Text(
                "OK",
                style: GoogleFonts.roboto(color: Colors.white, fontSize: 20),
              ),
              onPressed: () => Navigator.pop(context),
              color: Colors.blue,
            ),
          ]).show();
      return;
    }
  }
   Future firebaseMessagingGetToken() async {
    try {
      SharedPreferences getToken = await SharedPreferences.getInstance();
      String? auth = getToken.getString("token");
      String? tokenD = await messaging.getToken() as String;
      final headers = {
        'Content-Type': 'multipart/form-data',
        'Accept': 'application/json',
        'Authorization': '$auth',
      };
      var request = http.MultipartRequest(
          'POST', Uri.parse(baseLinkC.baseUrlUrlLaucer3 + '/api/siswa/profil'));
      request.fields.addAll({'notiftoken': tokenD});
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        // ignore: avoid_print
        print(await response.stream.bytesToString());
      } else {
        // ignore: avoid_print
        print(response.reasonPhrase);
      }
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }
  }

  @override
  void onInit() {
    getUserJurusan();
    super.onInit();
  }
  @override
  void onClose() {
    usernameControler.clear();
    passwordControler.clear();
    categoryList.clear();
    firebaseMessagingGetToken();
    super.onClose();
  }
}
