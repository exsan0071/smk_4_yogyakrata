import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData theme() {
  return ThemeData(
    colorScheme: const ColorScheme.light(
      primary: Color(0xff20bfcc),
    ),
    primaryColor: const Color(0xff20bfcc),
    primaryColorDark: const Color(0xffE5E5E5),
    primaryColorLight: const Color(0xff20bfcc),
    scaffoldBackgroundColor: Colors.grey[100],
    backgroundColor: Colors.grey[200],
    textTheme: TextTheme(
      bodyText1: GoogleFonts.roboto()
    )
  );
}
