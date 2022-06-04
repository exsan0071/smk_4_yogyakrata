// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../controller/baselink.dart';
import 'package:intl/intl.dart';
import '../../home/controller/body_controller.dart';
import '../../presensi/controller/presensi.dart';
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';

class PresensiPage extends StatefulWidget {
  const PresensiPage({Key? key}) : super(key: key);

  @override
  _PresensiPageState createState() => _PresensiPageState();
}

class _PresensiPageState extends State<PresensiPage> {
  final PresensiController presensiC = Get.put(PresensiController());
  final BaseLInkController baseLinkC = Get.put(BaseLInkController());
  final BodyController bodyC = Get.put(BodyController());
  DateTime _timeOfDay = DateTime.now();
  File? file;
  String? datang;
  String? pulang;
  bool? status;
  String? pesan;
  bool? statusIzin;
  String? pesanIzin;
  void requestPermision() async {
    var status = await Permission.locationAlways.status;
    if (!status.isGranted) {
      await Permission.locationAlways.request();
    }
    var status2 = await Permission.locationWhenInUse.status;
    if (!status2.isGranted) {
      await Permission.locationWhenInUse.request();
    }
  }

  Future gettPresensi() async {
// Link Post url database
    try {
      SharedPreferences getToken = await SharedPreferences.getInstance();
      String? auth = getToken.getString("token");
      final headers = {
        'Content-Type': 'multipart/form-data',
        'Accept': 'application/json',
        'Authorization': '$auth',
      };
      var request = http.MultipartRequest(
          'GET', Uri.parse(baseLinkC.baseUrlUrlLaucer3 + '/api/absensi'));

      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        final data = await response.stream.bytesToString();
        var it = jsonDecode(data);
        if (it['status'] == true) {
          datang = it['data']['waktu_datang'].toString();
          pulang = it['data']['waktu_pulang'].toString();

          print("Berhasil Mengambil Data");
        } else {
          print(it['pesan']);
        }
      } else {
        print(response.reasonPhrase);
      }
    } catch (e) {
      print('Terjadin Keslahan');

      print(e.toString());
    }
  }

  Future postPresensi(String typeAbsensi) async {
// Link Post url database
    try {
      SharedPreferences getToken = await SharedPreferences.getInstance();
      String? auth = getToken.getString("token");
      final headers = {
        'Content-Type': 'multipart/form-data',
        'Accept': 'application/json',
        'Authorization': '$auth',
      };
      var request = http.MultipartRequest(
          'POST', Uri.parse(baseLinkC.baseUrlUrlLaucer3 + '/api/absensi'));
      request.fields.addAll({
        'latitude': presensiC.lang.toString(),
        'longitude': presensiC.long.toString(),
        't': typeAbsensi
      });
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        final data = await response.stream.bytesToString();
        var it = jsonDecode(data);
        setState(() {
          status = it['status'];
          pesan = it['pesan'];
        });
        if (it['status'] == true) {
          print("behasil");
        } else {
          print(it['pesan']);
        }
        return it;
      } else {}
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  initState() {
    super.initState();
    gettPresensi();
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeOfDay.minute != DateTime.now().second) {
        if (mounted) {
          setState(() {
            _timeOfDay = DateTime.now();
          });
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fileName = file != null ? basename(file!.path) : 'No File Chosen !';
    return Scaffold(
        body: ListView(
      children: [
        Stack(
          children: [
            Positioned(
              left: 160,
              top: -5,
              right: -20,
              child: Image.asset('assets/images/absensi1.png',
                  width: 220, height: 220),
            ),
            Container(
              color: const Color(0xff20bfcc).withOpacity(0.93),
              width: MediaQuery.of(context).size.width,
              height: 220,
            ),
            Positioned(
              top: 10,
              left: 10,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_outlined,
                      size: 20, color: Colors.black),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  width: 20,
                ),
                Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Text("Presensi Harian",
                        style: GoogleFonts.roboto(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        )),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: const Color.fromARGB(255, 24, 144, 155),
                      ),
                      child: Text(
                          "Tanggal : " +
                              DateFormat("d MMMM yyyy", "id_ID").format(
                                  DateTime.parse(_timeOfDay.toString())),
                          style: GoogleFonts.roboto(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 16)),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: const Color.fromARGB(255, 24, 144, 155),
                      ),
                      child: Text(
                          "Pukul: ${_timeOfDay.hour} "
                          ": "
                          "${_timeOfDay.minute}"
                          ": "
                          "${_timeOfDay.second}"
                          " WIB",
                          style: GoogleFonts.roboto(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 16)),
                    ),
                  ],
                ),
              ],
            ),
            Column(
              children: [
                const SizedBox(
                  height: 120,
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    width: MediaQuery.of(context).size.width,
                    height: 180,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 0.75,
                          blurRadius: 7,
                          offset:
                              const Offset(0, 3), // changes position of shadow
                        ),
                      ],
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 5),
                              child: CircleAvatar(
                                radius: 25,
                                backgroundColor: Colors.black,
                                child: CircleAvatar(
                                  radius: 23,
                                  backgroundColor: const Color(0xff20bfcc),
                                  backgroundImage: NetworkImage(bodyC.foto),
                                ),
                              ),
                            ),
                            Column(
                              children: [
                                Container(
                                  width: 220,
                                  margin: const EdgeInsets.only(left: 20),
                                  child: Text(bodyC.nama,
                                      style: GoogleFonts.roboto(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      )),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(left: 20),
                                  width: 220,
                                  child: Text("Siswa",
                                      style: GoogleFonts.roboto(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black,
                                      )),
                                )
                              ],
                            ),
                          ],
                        ),
                        const Divider(color: Colors.black),
                        const SizedBox(
                          height: 7,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<
                                        Color>(
                                    const Color.fromARGB(255, 18, 126, 136)),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                )),
                              ),
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Image.asset(
                                    'assets/icons/vector.png',
                                    width: 16,
                                    height: 16,
                                  ),
                                  Text(
                                    'Absensi Datang',
                                    style: GoogleFonts.roboto(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                ],
                              ),
                              onPressed: () async {
                                requestPermision();
                                _getCurrentLocation();
                                ProgressDialog pd =
                                    ProgressDialog(context: context);

                                /// show the state of preparation first.
                                pd.show(
                                  max: 100,
                                  msg: 'Proses Pindai Lokasi...',
                                  progressType: ProgressType.valuable,
                                );

                                /// Added to test late loading starts
                                await Future.delayed(
                                    const Duration(milliseconds: 3000));
                                postPresensi('masuk');
                                for (int i = 0; i <= 100; i++) {
                                  /// You can indicate here that the download has started.
                                  pd.update(value: i, msg: 'loading...');
                                  i++;
                                  await Future.delayed(
                                      const Duration(milliseconds: 100));
                                }
                                setState(() {});
                                if (status == true) {
                                  Alert(
                                      context: context,
                                      title: "Presensi Berhasil",
                                      type: AlertType.success,
                                      buttons: [
                                        DialogButton(
                                          child: Text(
                                            "OK",
                                            style: GoogleFonts.roboto(
                                                color: Colors.white,
                                                fontSize: 20),
                                          ),
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          color: Colors.blue,
                                        ),
                                      ]).show();
                                  gettPresensi();
                                } else if (status == false) {
                                  Alert(
                                      context: context,
                                      title: pesan,
                                      type: AlertType.warning,
                                      buttons: [
                                        DialogButton(
                                          child: Text(
                                            "OK",
                                            style: GoogleFonts.roboto(
                                                color: Colors.white,
                                                fontSize: 20),
                                          ),
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          color: Colors.blue,
                                        ),
                                      ]).show();
                                } else {
                                  Alert(
                                      context: context,
                                      title: 'Terjadi Kesalahan',
                                      type: AlertType.error,
                                      buttons: [
                                        DialogButton(
                                          child: Text(
                                            "OK",
                                            style: GoogleFonts.roboto(
                                                color: Colors.white,
                                                fontSize: 20),
                                          ),
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          color: Colors.blue,
                                        ),
                                      ]).show();
                                }
                              },
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.green),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                )),
                              ),
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Image.asset(
                                    'assets/icons/vector2.png',
                                    width: 17,
                                    height: 17,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    'Absensi Pulang',
                                    style: GoogleFonts.roboto(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                ],
                              ),
                              onPressed: () async {
                                requestPermision();
                                _getCurrentLocation();
                                ProgressDialog pd =
                                    ProgressDialog(context: context);

                                /// show the state of preparation first.
                                pd.show(
                                  max: 100,
                                  msg: 'Proses Pindai Lokasi...',
                                  progressType: ProgressType.valuable,
                                );

                                /// Added to test late loading starts
                                await Future.delayed(
                                    const Duration(milliseconds: 3000));
                                postPresensi('pulang');
                                for (int i = 0; i <= 100; i++) {
                                  /// You can indicate here that the download has started.
                                  pd.update(value: i, msg: 'loading...');
                                  i++;
                                  await Future.delayed(
                                      const Duration(milliseconds: 100));
                                }

                                setState(() {});
                                if (status == true) {
                                  Alert(
                                      context: context,
                                      title: "Presensi Berhasil",
                                      type: AlertType.success,
                                      buttons: [
                                        DialogButton(
                                          child: Text(
                                            "OK",
                                            style: GoogleFonts.roboto(
                                                color: Colors.white,
                                                fontSize: 20),
                                          ),
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          color: Colors.blue,
                                        ),
                                      ]).show();
                                  gettPresensi();
                                } else if (status == false) {
                                  Alert(
                                      context: context,
                                      title: pesan,
                                      type: AlertType.warning,
                                      buttons: [
                                        DialogButton(
                                          child: Text(
                                            "OK",
                                            style: GoogleFonts.roboto(
                                                color: Colors.white,
                                                fontSize: 20),
                                          ),
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          color: Colors.blue,
                                        ),
                                      ]).show();
                                } else {
                                  Alert(
                                      context: context,
                                      title: 'Terjadi Kesalahan',
                                      type: AlertType.error,
                                      buttons: [
                                        DialogButton(
                                          child: Text(
                                            "OK",
                                            style: GoogleFonts.roboto(
                                                color: Colors.white,
                                                fontSize: 20),
                                          ),
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          color: Colors.blue,
                                        ),
                                      ]).show();
                                }
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
        Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 20),
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    "Riwayat Presensi Anda",
                    style: GoogleFonts.roboto(
                      fontSize: 18,
                      color: const Color.fromARGB(255, 16, 92, 99),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(endIndent: 20, indent: 20, color: Colors.grey),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Image.asset(
                    'assets/icons/time.png',
                    width: 50,
                    height: 50,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Column(
                    children: [
                      if (datang != null)
                        SizedBox(
                          width: 200,
                          child: Text(
                            'Jam Datang : ' + datang.toString() + ' WIB',
                            style: GoogleFonts.roboto(
                                color: const Color.fromARGB(255, 54, 54, 54),
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      if (datang == null)
                        SizedBox(
                          width: 200,
                          child: Text(
                            'Jam Datang : -',
                            style: GoogleFonts.roboto(
                                color: const Color.fromARGB(255, 54, 54, 54),
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      if (pulang != null)
                        SizedBox(
                          width: 200,
                          child: Text(
                            'Jam Pulang : ' + pulang.toString() + ' WIB',
                            style: GoogleFonts.roboto(
                                fontSize: 16,
                                color: const Color.fromARGB(255, 54, 54, 54),
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      if (pulang == null)
                        SizedBox(
                          width: 200,
                          child: Text(
                            'Jam Pulang : -',
                            style: GoogleFonts.roboto(
                                fontSize: 16,
                                color: const Color.fromARGB(255, 54, 54, 54),
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                    ],
                  ),
                )
              ],
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 215,
              margin: const EdgeInsets.only(
                  top: 20, right: 10, bottom: 10, left: 10),
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 6,
                  offset: Offset(0, 2),
                )
              ], color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: Column(
                children: [
                  Row(
                    children: [
                      Image.asset(
                        'assets/images/sakit.png',
                        width: 110,
                        height: 110,
                      ),
                      Column(
                        children: [
                          Container(
                              width: MediaQuery.of(context).size.width / 1.70,
                              padding: const EdgeInsets.only(top: 20),
                              child: Text(
                                'Hari Ini Berhalangan Hadir ?',
                                style: GoogleFonts.roboto(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        const Color.fromARGB(255, 16, 92, 99)),
                              )),
                          Container(
                              width: MediaQuery.of(context).size.width / 1.70,
                              padding: const EdgeInsets.all(10),
                              child: const Text('Upaloud Surat Izinmu disini')),
                          Row(
                            children: [
                              Container(
                                  width:
                                      MediaQuery.of(context).size.width - 150,
                                  height: 60,
                                  margin:
                                      const EdgeInsets.only(top: 10, right: 5),
                                  padding: const EdgeInsets.all(10),
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
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(fileName,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 10,
                                              style: GoogleFonts.roboto(
                                                  fontSize: 13)),
                                        ),
                                        IconButton(
                                            onPressed: () {
                                              selectFile();
                                            },
                                            icon: Image.asset(
                                              'assets/images/image1.png',
                                            )),
                                      ])),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(5),
                          child: Text(
                            'Type file yang diizinkan: (jpg, jpeg, png) | Ukuran maksimal : 3 MB',
                            style: GoogleFonts.roboto(fontSize: 9.25),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(5),
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: const Color.fromARGB(255, 16, 92, 99),
                                side: const BorderSide(
                                    width: 1, color: Colors.black),
                              ),
                              child: Text(
                                'Kirim',
                                style: GoogleFonts.roboto(fontSize: 12),
                              ),
                              onPressed: () async {
                                postIzinSiswa();
                                ProgressDialog pd =
                                    ProgressDialog(context: context);
                                pd.show(
                                  max: 100,
                                  msg: 'Loading...',
                                  progressType: ProgressType.valuable,
                                );
                                await Future.delayed(
                                    const Duration(milliseconds: 3000));
                                for (int i = 0; i <= 100; i++) {
                                  /// You can indicate here that the download has started.
                                  pd.update(value: i, msg: 'File Upload...');
                                  i++;
                                  await Future.delayed(
                                      const Duration(milliseconds: 100));
                                }
                                if (statusIzin == true) {
                                  Alert(
                                      context: context,
                                      title: "Upload Berhasil",
                                      type: AlertType.success,
                                      buttons: [
                                        DialogButton(
                                          child: Text(
                                            "OK",
                                            style: GoogleFonts.roboto(
                                                color: Colors.white,
                                                fontSize: 20),
                                          ),
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          color: Colors.blue,
                                        ),
                                      ]).show();
                                } else if (status == false) {
                                  Alert(
                                      context: context,
                                      title: pesanIzin,
                                      type: AlertType.warning,
                                      buttons: [
                                        DialogButton(
                                          child: Text(
                                            "OK",
                                            style: GoogleFonts.roboto(
                                                color: Colors.white,
                                                fontSize: 20),
                                          ),
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          color: Colors.blue,
                                        ),
                                      ]).show();
                                } else {
                                  Alert(
                                      context: context,
                                      title: 'Pilih File Anda Ungahan Anda !',
                                      type: AlertType.warning,
                                      buttons: [
                                        DialogButton(
                                          child: Text(
                                            "OK",
                                            style: GoogleFonts.roboto(
                                                color: Colors.white,
                                                fontSize: 20),
                                          ),
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          color: Colors.blue,
                                        ),
                                      ]).show();
                                }
                              }),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 260,
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    blurRadius: 7,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ],
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Text(
                    "Informasi System",
                    style: GoogleFonts.roboto(
                      fontSize: 18,
                      color: const Color.fromARGB(255, 16, 92, 99),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(children: [
                    Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(20)),
                        child: const Icon(
                          Icons.access_time_filled_outlined,
                          color: Colors.black45,
                          size: 20,
                        )),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      children: [
                        Text(
                          "Aturan waktu Presensi hadir",
                          style: GoogleFonts.roboto(
                            fontWeight: FontWeight.w300,
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          "06:00:00 s.d. 07:30:00 WIB",
                          style: GoogleFonts.roboto(
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    )
                  ]),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(children: [
                    Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(20)),
                        child: const Icon(
                          Icons.access_time_filled_outlined,
                          color: Colors.black45,
                          size: 20,
                        )),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      children: [
                        Text(
                          "Aturan waktu Presensi pulang",
                          style: GoogleFonts.roboto(
                            fontWeight: FontWeight.w300,
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          "12:00:00 s.d. 15:00:00 WIB",
                          style: GoogleFonts.roboto(
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    )
                  ]),
                  Container(
                    padding: const EdgeInsets.only(top: 10),
                    height: 106,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text("Catatan",
                                style: GoogleFonts.roboto(
                                  fontSize: 15,
                                )),
                            const SizedBox(
                              width: 30,
                            )
                          ],
                        ),
                        Text(
                            "Presensi diluar waktu diatas maka dianggap datang terlambat dan atau pulang lebih awal",
                            maxLines: 2,
                            style: GoogleFonts.roboto(
                              fontWeight: FontWeight.w300,
                              fontSize: 13,
                            )),
                        Row(
                          children: [
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.grey,
                                ),
                                onPressed: () {},
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(2),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(50)),
                                      child: Container(
                                        padding: const EdgeInsets.all(1),
                                        decoration: BoxDecoration(
                                            color: Colors.grey,
                                            borderRadius:
                                                BorderRadius.circular(50)),
                                        child: const Text(" ? ",
                                            style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.white,
                                            )),
                                      ),
                                    ),
                                    const Text("   Lihat Petunjuk Presensi",
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.white,
                                        )),
                                  ],
                                )),
                          ],
                        ),
                        const SizedBox(width: 20)
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ],
    ));
  }

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);
    if (result == null) return;
    final path = result.files.single.path!;
    setState(() => file = File(path));
  }

  Future postIzinSiswa() async {
    if (file == null) return;

    try {
      SharedPreferences getToken = await SharedPreferences.getInstance();
      String? auth = getToken.getString("token");
      final headers = {
        'Content-Type': 'multipart/form-data',
        'Accept': 'application/json',
        'Authorization': '$auth',
      };
      var request = http.MultipartRequest('POST',
          Uri.parse(baseLinkC.baseUrlUrlLaucer3 + '/api/absensi/suratizin'));
      request.files.add(await http.MultipartFile.fromPath(
        'file',
        file!.path,
      ));
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        final data = await response.stream.bytesToString();
        var it = jsonDecode(data);
        statusIzin = it['status'];
        pesanIzin = it['pesan'];
        if (it['status'] == true) {
          print("behasil");
        } else {
          print(it['pesan']);
        }
      } else {
        print(response.reasonPhrase);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  _getCurrentLocation() {
    Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best,
            forceAndroidLocationManager: true)
        .then((Position position) {
      setState(() {
        presensiC.lang = position.latitude.toString();
        presensiC.long = position.longitude.toString();
      });
    }).catchError((e) {
      print(e);
    });
  }
}
