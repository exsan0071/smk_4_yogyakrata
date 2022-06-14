import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../controller/baselink.dart';
import '../../home/controller/body_controller.dart';

class NilaiProgressViews extends StatefulWidget {
  const NilaiProgressViews({Key? key}) : super(key: key);

  @override
  _NilaiProgressViewsState createState() => _NilaiProgressViewsState();
}

class _NilaiProgressViewsState extends State<NilaiProgressViews> {
  final BodyController bodyC = Get.put(BodyController());
  final BaseLInkController baseLinkC = Get.put(BaseLInkController());
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  void initState() {
    super.initState();

    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nilai & Progress'),
      ),
      //Kebijakan Privasi
      body: WebView(
        initialUrl: baseLinkC.baseUrlUrlLaucer3 +
            "/app/student/statistikview/laporan?token=${bodyC.token}",
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          _controller.complete(webViewController);
        },
        onProgress: (int progress) {
          // ignore: avoid_print
          print('WebView is loading (progress : $progress%)');
        },
      ),
    );
  }
}
