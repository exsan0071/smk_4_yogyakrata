import 'dart:async';
import 'package:flutter/material.dart';
import 'ooboarding.dart';

class LoadingOboarding extends StatefulWidget {
  const LoadingOboarding({Key? key}) : super(key: key);

  @override
  _LoadingOboardingState createState() => _LoadingOboardingState();
}

class _LoadingOboardingState extends State<LoadingOboarding> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 2000), () {
      Navigator.pushReplacement(
          context,
          PageRouteBuilder(
              pageBuilder: (context, animation, secondartyAnimation) =>
                  const OnboardingScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1.75,
                        blurRadius: 7,
                        offset:
                            const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white),
                child: const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator()))));
  }
}
