//pkg import
import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smk_4_yogyakrata/app/login/views/login_selected.dart';
import 'package:url_launcher/url_launcher.dart';
import '../home/views/home.dart';
import '../../app_theme.dart';
import '../../main.dart';

class Auth extends StatefulWidget {
  const Auth({Key? key}) : super(key: key);
  @override
  State<Auth> createState() => _AuthState();
}

class _AuthState extends State<Auth> with SingleTickerProviderStateMixin {
  var _visible = true;
  late AnimationController animationController;
  late Animation<double> animation;
  void auth() async {
    SharedPreferences getToken = await SharedPreferences.getInstance();
    String? auth = getToken.getString("token");
    if (auth != null) {
      Timer(const Duration(seconds: 3), () {
        Navigator.pushReplacement(
            context,
            PageRouteBuilder(
                pageBuilder: (context, animation, secondartyAnimation) =>
                    const Home()));
      });
    } else {
      Timer(const Duration(seconds: 3), () {
        Navigator.pushReplacement(
            context,
            PageRouteBuilder(
                pageBuilder: (context, animation, secondartyAnimation) =>
                    const LoginSelected()));
      });
    }
  }

  @override
  void initState() {
    super.initState();
    final box = GetStorage();
    if (box.read('skipIntro') != null) {
      box.remove('skipIntro');
    }
    box.write('skipIntro', true);
    animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 3));
    animation =
        CurvedAnimation(parent: animationController, curve: Curves.easeOut);
    animation.addListener(() => setState(() {}));
    animationController.forward();
    setState(() {
      _visible = !_visible;
    });
    // FirebaseMessaging [FirebaseMessaging] chek notif here in background
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (kDebugMode) {
        print('A new onMessageOpenedApp event was published!');
      }
      if (message?.data['url'] != null) {
        _launchURLGoolePlay(
            message?.data['url'] + "com.aricode.watulintang.smk4yogyakata");
      }
    });
    var initialzationSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings =
        InitializationSettings(android: initialzationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channelDescription: channel.description,
                icon: android.smallIcon,
              ),
            ));
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage? message) {
      if (kDebugMode) {
        print('A new onMessageOpenedApp event was published!');
      }
      if (message?.data['url'] != null) {
        _launchURLGoolePlay(
            message?.data['url'] + "com.aricode.watulintang.smk4yogyakata");
      }
    });
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            MacOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
    auth();
  }

  _launchURLGoolePlay(String urlPlaystore) async {
    final url = urlPlaystore;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
          colors: AppTheme.blueGradient,
          begin: Alignment.topCenter,
        )),
        child: ListView(
          children: [
            // logo here
            Padding(
              padding:
                  EdgeInsets.only(top: MediaQuery.of(context).padding.top + 70),
              child: Image.asset(
                "assets/images/logo.png",
                width: 90,
                height: 90,
              ),
            ),
            const SizedBox(height: 30),
            Center(
              child: Text(
                'SEKOLAHKITA.Net',
                style: GoogleFonts.fredokaOne(color: AppTheme.white, fontSize: 20),
              ),
            ),
            const SizedBox(
              height: 240,
            ),
            const SpinKitFadingCircle(
              color: Colors.white,
            ),
            const SizedBox(
              height: 20,
            ),
            Text('Copyright © \n 2022 SMK N 4 Yogyakarta',
                textAlign: TextAlign.center,
                style: GoogleFonts.roboto(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold))
          ],
        ),
      ),
    );
  }
}
