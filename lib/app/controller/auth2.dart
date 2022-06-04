import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import '../../app_theme.dart';
import 'auth.dart';

class Splasecren extends StatefulWidget {
  const Splasecren({Key? key}) : super(key: key);

  @override
  State<Splasecren> createState() => _SplasecrenState();
}

class _SplasecrenState extends State<Splasecren> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
                gradient: LinearGradient(
              colors: AppTheme.blueGradient,
              begin: Alignment.topCenter,
            )),
          ),
          AnimatedSplashScreen(
            backgroundColor: Colors.transparent,
            splash: "assets/images/1644648214-HEADER.png",
            nextScreen: const Auth(),
            duration: 3000,
            splashTransition: SplashTransition.scaleTransition,
            splashIconSize: 120,
          )
        ],
      ),
    );
  }
}
