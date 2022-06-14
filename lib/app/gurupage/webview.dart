// pkg import here ....
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';

class WebviewPage extends StatefulWidget {
  const WebviewPage({Key? key}) : super(key: key);

  @override
  _WebviewPageState createState() => _WebviewPageState();
}

final flutterWebViewPlugin = FlutterWebviewPlugin();

class _WebviewPageState extends State<WebviewPage> {
  void requestPermision() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
    var status2 = await Permission.locationAlways.status;
    if (!status2.isGranted) {
      await Permission.locationAlways.request();
    }
    var status3 = await Permission.locationWhenInUse.status;
    if (!status3.isGranted) {
      await Permission.locationWhenInUse.request();
    }
    var status4 = await Permission.camera.status;
    if (!status4.isGranted) {
      await Permission.camera.request();
    }
  }

  @override
  void initState() {
    super.initState();
    requestPermision();
    flutterWebViewPlugin.goBack();
    flutterWebViewPlugin.reload();
  }

  @override
  void dispose() {
    // Every listener should be canceled, the same should be done with this stream.
    flutterWebViewPlugin.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DateTime timeBackPressed = DateTime.now();
    return WillPopScope(
      onWillPop: () async {
        final difference = DateTime.now().difference(timeBackPressed);
        final isExitWarning = difference >= const Duration(seconds: 2);
        timeBackPressed = DateTime.now();
        if (isExitWarning) {
          Fluttertoast.showToast(
            msg: "Tekan Kembali Untuk Keluar",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.SNACKBAR,
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
          return false;
        } else {
          Fluttertoast.cancel();
          flutterWebViewPlugin.close();
          return true;
        }
      },
      child: WebviewScaffold(
        // basse link web here .....
        url: "https://smkn4jogja.sch.id//login?p=guru",
        withZoom: false,
        withLocalStorage: true,
        withLocalUrl: true,
        mediaPlaybackRequiresUserGesture: false,
        enableAppScheme: true,
        withJavascript: true,
        scrollBar: true,
        hidden: false,
        initialChild: Container(
          color: const Color(0xff20bfcc),
          child: Center(
            child: Text(
              'Mohon Tunggu Sebentar....',
              style: GoogleFonts.roboto(color: Colors.white, fontSize: 20),
            ),
          ),
        ),
        appBar: AppBar(
          backgroundColor: const Color(0xff20bfcc),
          title: Center(
            // image app bar here ....
            child: Image.asset(
              'assets/images/header3.png',
              width: 190,
              height: 41,
            ),
          ),
          leading: Stack(children: <Widget>[
            Positioned(
              top: 12,
              left: 12,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: SizedBox(
                  height: 30,
                  width: 30,
                  // ignore: deprecated_member_use
                  child: RaisedButton(
                    shape: const StadiumBorder(),
                    color: Colors.white,
                    onPressed: () {
                      flutterWebViewPlugin.goBack();
                    },
                  ),
                ),
              ),
            ),
            Positioned(
              top: 3.70,
              left: 3.70,
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back_sharp,
                  size: 20,
                  color: Colors.black,
                ),
                onPressed: () {
                  flutterWebViewPlugin.goBack();
                },
              ),
            ),
          ]),
          actions: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.autorenew,
                size: 25,
                color: Colors.white,
              ),
              // reload buttom here...
              onPressed: () {
                flutterWebViewPlugin.reload();
              },
            ),
          ],
        ),
      ),
    );
  }
}
