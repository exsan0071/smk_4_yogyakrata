import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../gurupage/webview.dart';
import '../../home/views/home.dart';
import '../../../app_theme.dart';
import '../controller/login_controller.dart';
import '../widget/textfild_login.dart';
import '../../controller/introduction_creen/controller_ooboarding.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final LoginController loginC = Get.put(LoginController());
  final OoboardingController ooboardingC = Get.put(OoboardingController());

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
  }

  @override
  void dispose() {
    ooboardingC.firstInitialized();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top + 30, bottom: 20),
                child: Text(
                  'Masuk',
                  style: GoogleFonts.openSans(
                    color: Colors.white,
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          'Masuk sebagai Siswa yang sudah terdaftar di website resmi sekolah dengan akun anda',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.roboto(
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
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
                        Container(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            alignment: Alignment.centerLeft,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 6,
                                    offset: Offset(0, 2),
                                  )
                                ]),
                            height: 50,
                            child:
                                Row(mainAxisSize: MainAxisSize.max, children: [
                              Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: const Icon(
                                    Icons.class_,
                                    size: 20,
                                    color: AppTheme.blueligt,
                                  )),
                              const SizedBox(
                                width: 15,
                              ),
                              GetBuilder<LoginController>(builder: (snapshot) {
                                return DropdownButton(
                                  underline: Container(),
                                  elevation: 16,
                                  value: snapshot.selectedName,
                                  hint: SizedBox(
                                    width: MediaQuery.of(context).size.width - 130,
                                    child: const Text('PILIH KELAS ANDA'),
                                  ),
                                  style: GoogleFonts.roboto(
                                      color: Colors.black54, fontSize: 14),
                                  items: snapshot.categoryList
                                      .map(
                                        (list) => DropdownMenuItem(
                                          child: Text(
                                              list.status + " " + list.nama),
                                          value: list.id,
                                        ),
                                      )
                                      .toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      snapshot.selectedName = value.toString();
                                      snapshot.update();
                                    });
                                  },
                                );
                              }),
                            ])),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                                onPressed: () {},
                                child: const Text('Forget Passwword ?',
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.white))),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    width: double.infinity,
                    height: 70,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                          minimumSize: const Size(252, 51),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15))),
                      onPressed: () {
                        loginC.login(context);
                      },
                      child: const Text(
                        "Login",
                        style:
                            TextStyle(color: AppTheme.blueligt, fontSize: 16),
                      ),
                    ),
                  ),
                  const Divider(color: Color(0xFF7F7F7F)),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.red,
                          minimumSize: const Size(252, 51),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15))),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const WebviewPage()));
                      },
                      child: const Text(
                        "Login sebagai Guru -->",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
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
      ),
    );
  }
}
