import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app_theme.dart';
import '../controller/login_controller.dart';

final LoginController textC = Get.put(LoginController());
Widget buildUsername() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      const SizedBox(
        height: 10,
      ),
      Container(
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
          child: TextField(
              controller: textC.usernameControler,
              keyboardType: TextInputType.name,
              style: const TextStyle(color: Colors.black87),
              decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.only(top: 14),
                  prefixIcon: const Icon(Icons.person, color: AppTheme.blueligt,
                  size: 20,
                  ),
                  hintText: 'Username',
                   helperStyle:
                      GoogleFonts.roboto(color: Colors.black38, fontSize: 12
                  ))))
    ],
  );
}

Widget password() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      const SizedBox(
        height: 10,
      ),
      Container(
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
          child: TextField(
              controller: textC.passwordControler,
              obscureText: true,
              style: const TextStyle(color: Colors.black87),
              decoration:InputDecoration(
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.only(top: 14),
                  prefixIcon: const Icon(Icons.lock, color: AppTheme.blueligt,
                    size: 20,
                  ),
                  hintText: 'Password',
                  helperStyle: GoogleFonts.roboto(color: Colors.black38,
                   fontSize: 12
                  ))))
    ],
  );
}
