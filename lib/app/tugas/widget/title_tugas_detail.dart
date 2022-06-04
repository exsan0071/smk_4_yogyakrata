import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/detail_tugas.dart';

class TugasAktif extends StatelessWidget {
  const TugasAktif({
    Key? key,
    required this.data1,
  }) : super(key: key);

  final Data data1;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(15),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: data1.tugasAvailable != false
              ? const Color(0xff3FB17A)
              : Colors.red.withOpacity(0.8)),
      child: Text(
        data1.pesan,
        textAlign: TextAlign.center,
        style: GoogleFonts.roboto(color: Colors.white, fontSize: 14),
      ),
    );
  }
}
