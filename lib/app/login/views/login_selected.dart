import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smk_4_yogyakrata/app/login/views/login.dart';

import '../../../app_theme.dart';
import '../../gurupage/webview.dart';

class LoginSelected extends StatefulWidget {
  const LoginSelected({Key? key}) : super(key: key);

  @override
  State<LoginSelected> createState() => _LoginSelectedState();
}

class _LoginSelectedState extends State<LoginSelected> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
          height: MediaQuery.of(context).size.height,
         
          decoration: const BoxDecoration(
              gradient: LinearGradient(
            colors: [Color(0xff512da8), Color(0xff20bfcc)],
            begin: Alignment.topCenter,
          )),
          child: SingleChildScrollView(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 40,
              ),
              Image.asset("assets/images/Notif.png", height: 250, width: 250),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 20),
                child: Row(
                  children: [
                    Expanded(
                        child: Text(
                      "Selamat Datang",
                      style: GoogleFonts.fredokaOne(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 20),
                child: Row(
                  children: [
                    Expanded(
                        child: Text(
                      "SMK N 4 Yogyakarta",
                      style: GoogleFonts.fredokaOne(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    )),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 20),
                child: Row(
                  children: [
                    Expanded(
                        child: Text(
                      "Aplikasi Pembelajaran Sekolah",
                      style: GoogleFonts.roboto(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      minimumSize: const Size(252, 51),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15))),
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const Login()));
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Image.asset(
                        "assets/images/graduation.png",
                        height: 25,
                        width: 25,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.67,
                        child: const Text(
                          "Login Siswa",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: AppTheme.blueligt,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      side: const BorderSide(
                        width: 2.0,
                        color: Colors.white,
                      ),
                      primary: const Color(0xff20bfcc),
                      minimumSize: const Size(252, 51),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15))),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const WebviewPage()));
                  },
                  child: const Text(
                    "Login sebagai Guru",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text("Belum punya akun ? ",
                    style: GoogleFonts.roboto(
                      color: Colors.grey[300],
                      fontSize: 12,
                    )),
                TextButton(
                    onPressed: () {},
                    child: const Text('help!',
                        style: TextStyle(fontSize: 12, color: Colors.white)))
              ])
            ],
          ))),
    ));
  }
}
