import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/detail_tugas.dart';
import '../views/pengerjaaan_tugas_pg.dart';
import '../views/pengerjaan_tugas_esay.dart';

class BodyTugasAktif extends StatelessWidget {
  const BodyTugasAktif({Key? key, required this.data1, required this.id1})
      : super(key: key);
  final String id1;
  final Data data1;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width / 2 - 30,
                height: 30,
                child: Text(
                  'JUDUL',
                  style: GoogleFonts.roboto(),
                ),
              ),
              SizedBox(
                  width: MediaQuery.of(context).size.width / 2 - 30,
                  height: 30,
                  child: Text(data1.judul, style: GoogleFonts.roboto()))
            ],
          ),
          const Divider(),
          Row(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width / 2 - 30,
                height: 30,
                child: Text('KELAS', style: GoogleFonts.roboto()),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 2 - 30,
                height: 30,
                child: Text(data1.kelas + " " + data1.jurusan,
                    style: GoogleFonts.roboto()),
              )
            ],
          ),
          const Divider(),
          Row(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width / 2 - 30,
                height: 30,
                child: Text('TIPE SOAL', style: GoogleFonts.roboto()),
              ),
              SizedBox(
                  width: MediaQuery.of(context).size.width / 2 - 30,
                  height: 30,
                  child: Text(data1.soal.soalTipe, style: GoogleFonts.roboto()))
            ],
          ),
          const Divider(),
          Row(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width / 2 - 30,
                height: 50,
                child: Text('JUMLAH SOAL', style: GoogleFonts.roboto()),
              ),
              SizedBox(
                  width: MediaQuery.of(context).size.width / 2 - 30,
                  height: 50,
                  child: Text(data1.soal.soalJumlah.toString(),
                      style: GoogleFonts.roboto()))
            ],
          ),
          const Divider(),
          Row(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width / 2 - 30,
                height: 50,
                child: Text('WAKTU PENGERJAAN', style: GoogleFonts.roboto()),
              ),
              SizedBox(
                  width: MediaQuery.of(context).size.width / 2 - 30,
                  height: 60,
                  child: data1.waktu.status == "none"
                      ? SizedBox(
                          width: MediaQuery.of(context).size.width / 2 - 30,
                          height: 50,
                          child: Text('Tidak ada batas waktu',
                              style: GoogleFonts.roboto()))
                      : Text(
                          "Tgl." +
                              data1.waktu.startTanggal +
                              " S.d. " +
                              data1.waktu.endTanggal +
                              " Pukul :" +
                              data1.waktu.startTime +
                              " S.d. " +
                              data1.waktu.endTime +
                              " WIB",
                          style: GoogleFonts.roboto())),
            ],
          ),
          const Divider(),
          Row(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width / 2 - 30,
                height: 50,
                child: Text('PROSES PENGERJAAN', style: GoogleFonts.roboto()),
              ),
              SizedBox(
                  width: MediaQuery.of(context).size.width / 2 - 30,
                  height: 50,
                  child: Text(data1.jawaban.persentase.toString() + "%",
                      style: GoogleFonts.roboto()))
            ],
          ),
          Stack(children: [
            Container(
              width: double.infinity,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
            ),
            LayoutBuilder(
              builder: (context, constraints) => Container(
                width: constraints.maxWidth * (data1.jawaban.persentase / 100),
                height: 5,
                decoration: const BoxDecoration(
                  color: Color(0xff3FB17A),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
            ),
          ]),
          Container(
            height: 60,
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.only(top: 20, left: 10, right: 10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color:
                    const Color.fromARGB(255, 24, 144, 155).withOpacity(0.3)),
            child: Text('Resume Guru :', style: GoogleFonts.roboto()),
          ),
          const SizedBox(
            height: 30,
          ),
          if (data1.tugasAvailable != false)
            ElevatedButton(
              style: ElevatedButton.styleFrom(primary: const Color(0xFF18909B)),
              onPressed: () {
                if (data1.soal.soalTipe == "essay") {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => PengerjaanTugasEsay(
                            id: id1,
                          )));
                } else {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => PengerjaanTugas(id: id1)));
                }
              },
              child: Text('Lanjutkan ->', style: GoogleFonts.roboto()),
            ),
        ],
      ),
    );
  }
}
