import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../controller/baselink.dart';
import '../../status/controller/controller.dart';

class PostStatus {
  final StatusController statusC = Get.put(StatusController());
  final BaseLInkController baseLinkC = Get.put(BaseLInkController());

  ///add datata Status here
  Future addData() async {
    try {
      SharedPreferences getToken = await SharedPreferences.getInstance();
      String? auth = getToken.getString("token");
      final headers = {
        'Content-Type': 'multipart/form-data',
        'Accept': 'application/json',
        'Authorization': '$auth',
      };
      var request = http.MultipartRequest(
          'POST', Uri.parse(baseLinkC.baseUrlUrlLaucer3 + '/api/status/komen'));
      request.fields.addAll({
        'post-text': statusC.data.text,
        'post-privacy': '${statusC.selecItems}'
      });
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        if (kDebugMode) {
          print(await response.stream.bytesToString());
        }
      } else {
        if (kDebugMode) {
          print(response.reasonPhrase);
        }
      }
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }
  }

// notif by firebase here api autentication
  Future sendNotifAddStatus(String nama, String isi) async {
    try {
      final headers = {
        'Authorization':
            'key=AAAALiJ15I4:APA91bHlTlFCuW747uKxTOxklqm1CM7u_14X0Qnin1JBaFM91P0IpPJJj8sq4d00z8f2wBEe1NaDIRGhCerFXRGi4ypJR2H6C3Mts8UkeFdx3P22yO3myqnWAxyyptY8EKkygjpgHxK2 ',
        'Content-Type': 'application/json'
      };
      var request = http.Request(
          'POST', Uri.parse('https://fcm.googleapis.com/fcm/send'));
      request.body = json.encode({
        "to":
            "dEUutFRZQIuGjSljgzGHvb:APA91bGh7WE7hNn05npSPeAFEeCmiHNgFEYsuGCmg5p3Py5-I9WZoOggiSbEdTyU8KFmRv-scePDMDE6MoPobKVgylyLMNI3KcnV_ZmWsNAVy3jYFu9m6sryYB4Ava9j8B97yJ-GJzM3",
        "collapse_key": "type_a",
        // "notification": {
        //   "body": "$isi",
        //   "title": "$nama",
        //   "sound": "default",
        //   "click_action": "FCM_PLUGIN_ACTIVITY",
        //   "icon": "fcm_push_icon"
        // },
        "notification": {"title": nama, "body": isi, "mutable_content": true}
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
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }
  }
}
