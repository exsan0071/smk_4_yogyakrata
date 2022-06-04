import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';

import '../../gurupage/webview.dart';
import '../../home/views/home.dart';
import '../models/jurusan_models.dart';
import '../provider/login_provider.dart';
import '../../../app/home/controller/loading.dart';
import '../../../app_theme.dart';
import '../controller/login_controller.dart';
import '../widget/textfild_login.dart';
import '../../../app/controller/introduction_creen/loading_ooboarding.dart';
import '../models/auth.dart';
import '../../controller/baselink.dart';
import '../../controller/introduction_creen/controller_ooboarding.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GetDataLogin getDataLogin = GetDataLogin();
  final LoginController loginC = Get.put(LoginController());
  final OoboardingController ooboardingC = Get.put(OoboardingController());
  final BaseLInkController baseLinkC = Get.put(BaseLInkController());
  String? selectedName;
  List categoryList = [];
  Future getUserJurusan() async {
    try {
      final response =
          await http.get(Uri.parse(baseLinkC.baseUrlUrlLaucer3 + '/api/kelas'));
      // ignore: avoid_print
      print(response.statusCode);
      if (response.statusCode != 200) {
        // ignore: avoid_print
        print("TIDAK DAPAT DATA KELAS DARI SERVER ");
        return null;
      } else {
        final data = jsonDecode(response.body)['data'];

        for (Map<String, dynamic> i in data) {
          categoryList.add(DataJurusan.fromJson(i));
        }
        // ignore: avoid_print
        print("DAPAT DATA KELAS DARI SERVER ");
      }
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }
  }

  Future _login() async {
    if (loginC.usernameControler.text.isEmpty ||
        loginC.passwordControler.text.isEmpty ||
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
    //base provider auth url here...
    final response = await http
        .post(Uri.parse(baseLinkC.baseUrlUrlLaucer3 + '/api/login'), body: {
      "username": loginC.usernameControler.text,
      "password": loginC.passwordControler.text,
      "kelas": selectedName,
    });
    pd.close();
    final auth = authFromJson(response.body);
    //authentications cheek here....
    if (auth.status == 'true') {
      // use the returned token to send messages to users from your custom server
      loginC.tokenCache(auth.token);

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

  void getToken() async {
    SharedPreferences getToken = await SharedPreferences.getInstance();
    String? auth = getToken.getString("token");
    if (auth != null) {
      Navigator.push(
        context,
        PageRouteBuilder(
            pageBuilder: (context, animation, secondartyAnimation) =>
                const Home()),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    getToken();
    getUserJurusan();
  }

  @override
  void dispose() {
    loginC.usernameControler.clear();
    loginC.passwordControler.clear();
    categoryList.clear();
    getDataLogin.firebaseMessagingGetToken();
    ooboardingC.firstInitialized();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          child: Stack(
            children: <Widget>[
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                  colors: [Color(0xff512da8), Color(0xff20bfcc)],
                  begin: Alignment.topCenter,
                )),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 25,
                    vertical: 20,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Image.asset(
                          "assets/images/logo.png",
                          width: 80,
                          height: 80,
                        ),
                      ),
                      Stack(
                        children: [
                          AnimatedPositioned(
                              duration: const Duration(milliseconds: 700),
                              child: AnimatedContainer(
                                duration: const Duration(microseconds: 700),
                                curve: Curves.bounceInOut,
                                height: 495,
                                padding: const EdgeInsets.all(20),
                                width: MediaQuery.of(context).size.width - 20,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.3),
                                        blurRadius: 15,
                                        spreadRadius: 5,
                                      )
                                    ]),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              loginC.isGuru = true;
                                            });
                                          },
                                          child: Column(
                                            children: [
                                              Text(
                                                'Login Siswa',
                                                style: GoogleFonts.roboto(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                    color: loginC.isGuru
                                                        ? Colors.blue[700]
                                                        : Colors.blue[300]),
                                              ),
                                              // if (loginC.isGuru)
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    top: 3),
                                                height: 2,
                                                width: 105,
                                                color: Colors.red,
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SingleChildScrollView(
                                      padding: const EdgeInsets.only(top: 20),
                                      child: Column(
                                        children: <Widget>[
                                          buildUsername(),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          password(),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {});
                                            },
                                            child: Container(
                                                padding: const EdgeInsets.only(
                                                    left: 10, right: 10),
                                                alignment: Alignment.centerLeft,
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    boxShadow: const [
                                                      BoxShadow(
                                                        color: Colors.black26,
                                                        blurRadius: 6,
                                                        offset: Offset(0, 2),
                                                      )
                                                    ]),
                                                height: 50,
                                                child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Container(
                                                          margin:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  vertical: 10),
                                                          child: const Icon(
                                                            Icons.class_,
                                                            size: 20,
                                                            color: AppTheme
                                                                .blueligt,
                                                          )),
                                                      const SizedBox(
                                                        width: 15,
                                                      ),
                                                      DropdownButton(
                                                        underline: Container(),
                                                        elevation: 16,
                                                        value: selectedName,
                                                        hint: const SizedBox(
                                                          width: 170,
                                                          child: Text(
                                                              'Pilih Kelas Anda'),
                                                        ),
                                                        style:
                                                            GoogleFonts.roboto(
                                                                color: Colors
                                                                    .black54,
                                                                fontSize: 14),
                                                        items: categoryList
                                                            .map(
                                                              (list) =>
                                                                  DropdownMenuItem(
                                                                child: Text(list
                                                                        .status +
                                                                    "-" +
                                                                    list.nama),
                                                                value: list.id,
                                                              ),
                                                            )
                                                            .toList(),
                                                        onChanged: (value) {
                                                          setState(() {
                                                            selectedName = value
                                                                .toString();
                                                          });
                                                        },
                                                      ),
                                                    ])),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            children: [
                                              Checkbox(
                                                value: loginC.isRemember,
                                                activeColor: Colors.blue,
                                                onChanged: (value) {
                                                  setState(() {
                                                    loginC.isRemember =
                                                        !loginC.isRemember;
                                                  });
                                                },
                                              ),
                                              Text('Remember Me',
                                                  style: TextStyle(
                                                      color: Colors.grey[500],
                                                      fontSize: 12)),
                                              TextButton(
                                                  onPressed: () {},
                                                  child: const Text(
                                                      'Forget Passwword ?',
                                                      style: TextStyle(
                                                          fontSize: 12))),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 15),
                                      width: double.infinity,
                                      height: 70,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            primary: AppTheme.blueligt,
                                            minimumSize: const Size(252, 51),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15))),
                                        onPressed: () {
                                          _login();
                                        },
                                        child: const Text(
                                          "Login",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16),
                                        ),
                                      ),
                                    ),
                                    const Divider(color: Color(0xFF7F7F7F)),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5),
                                      width: double.infinity,
                                      height: 50,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            primary: AppTheme.primariyLogin,
                                            minimumSize: const Size(252, 51),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15))),
                                        onPressed: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const WebviewPage()));
                                        },
                                        child: const Text(
                                          "Login sebagai Guru",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ))
                        ],
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
