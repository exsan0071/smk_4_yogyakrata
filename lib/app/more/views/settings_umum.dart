import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';

import 'package:shared_preferences/shared_preferences.dart';
import '../../controller/baselink.dart';
import '../../profile/models/profile.dart';
import '../../profile/provider/profile.dart';

class SetingUmum extends StatefulWidget {
  const SetingUmum({Key? key}) : super(key: key);

  @override
  _SetingUmumState createState() => _SetingUmumState();
}

class _SetingUmumState extends State<SetingUmum> {
  DateTime? _datePicked;
  String? dataName;
  String? dataTempatLahir;
  String? dataTanggalLahir;
  String? name;
  String? tempatLahirC;
  String? tanggalLahir;
  final GetDataProflie proflie = GetDataProflie();
  TextEditingController nama = TextEditingController();
  TextEditingController tempatLahir = TextEditingController();
  final BaseLInkController baseLinkC = Get.put(BaseLInkController());

  Future postProfil() async {
    try {
      SharedPreferences getToken = await SharedPreferences.getInstance();
      String? auth = getToken.getString("token");
      final headers = {
        'Content-Type': 'multipart/form-data',
        'Accept': 'application/json',
        'Authorization': '$auth',
      };
      var request = http.MultipartRequest(
          'POST', Uri.parse(baseLinkC.baseUrlUrlLaucer3 + '/api/siswa/profil'));
      request.fields.addAll({
        'nama_siswa': name.toString(),
        'tempat_lahir': tempatLahirC.toString(),
        'tgl_lahir': tanggalLahir.toString(),
      });
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        // ignore: avoid_print
        print(await response.stream.bytesToString());
      } else {
        // ignore: avoid_print
        print(response.reasonPhrase);
      }
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }
  }

  void _showDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1999),
            lastDate: DateTime.now())
        .then((value) {
      if (value == null) {
        return;
      }
      setState(() {
        _datePicked = value;
        tanggalLahir = DateFormat("yyyy-M-d").format(_datePicked!);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Umum',
            style: GoogleFonts.roboto(),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            if (name == null) {
              setState(() {
                name = dataName;
              });
            } else {
              null;
            }

            if (tempatLahirC == null) {
              setState(() {
                tempatLahirC = dataTempatLahir;
              });
            } else {
              null;
            }
            if (tanggalLahir == null) {
              setState(() {
                tanggalLahir = dataTanggalLahir;
              });
            } else {
              null;
            }

            postProfil();
            setState(() {});
            Alert(
                context: context,
                title: "Data Berhasil di Ubah",
                type: AlertType.success,
                buttons: [
                  DialogButton(
                    child: Text(
                      "OK",
                      style:
                          GoogleFonts.roboto(color: Colors.white, fontSize: 20),
                    ),
                    onPressed: () => Navigator.pop(context),
                    color: Colors.blue,
                  ),
                ]).show();
          },
          label: Text(
            'Simpan',
            style: GoogleFonts.roboto(color: Colors.white),
          ),
          backgroundColor: Colors.blue,
        ),
        body: FutureBuilder<Profile?>(
            future: proflie.getDataUserProfile(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final data = snapshot.data!;
                dataName = snapshot.data!.namasiswa;
                dataTempatLahir = snapshot.data!.tempatlahir;
                dataTanggalLahir = snapshot.data!.tgllahir;
                return Column(
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        width: _width,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 0.75,
                              blurRadius: 7,
                              offset: const Offset(
                                  0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: ListTile(
                          subtitle: Text(data.nis, style: GoogleFonts.roboto()),
                          title: Text('Nis', style: GoogleFonts.roboto()),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    GestureDetector(
                      onTap: () {
                        _opendialogNama();
                      },
                      child: Container(
                        width: _width,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 0.75,
                              blurRadius: 7,
                              offset: const Offset(
                                  0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: ListTile(
                          subtitle: Text(name == null ? data.namasiswa : name!,
                              style: GoogleFonts.roboto()),
                          title:
                              Text('Nama Lengkap', style: GoogleFonts.roboto()),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    GestureDetector(
                      onTap: () {
                        _opendialogTempatLahir();
                      },
                      child: Container(
                        width: _width,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 0.75,
                              blurRadius: 7,
                              offset: const Offset(
                                  0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: ListTile(
                          subtitle: Text(
                              tempatLahirC == null
                                  ? data.tempatlahir
                                  : tempatLahirC!,
                              style: GoogleFonts.roboto()),
                          title: Text('Temapat Lahir',
                              style: GoogleFonts.roboto()),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    GestureDetector(
                      onTap: () {
                        _showDatePicker();
                      },
                      child: Container(
                        width: _width,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 0.75,
                              blurRadius: 7,
                              offset: const Offset(
                                  0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: ListTile(
                          subtitle: Text(
                            _datePicked == null
                                ? DateFormat("d MMMM yyyy ", "id_ID")
                                    .format(DateTime.parse(data.tgllahir))
                                : DateFormat("d MMMM yyyy ", "id_ID")
                                    .format(_datePicked!),
                            style: GoogleFonts.roboto(),
                          ),
                          title: Text('Tanggal Lahir',
                              style: GoogleFonts.roboto()),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        width: _width,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 0.75,
                              blurRadius: 7,
                              offset: const Offset(
                                  0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: ListTile(
                          subtitle: data.jeniskelamin == 'L'
                              ? Text("Laki-Laki", style: GoogleFonts.roboto())
                              : Text("Perempuan", style: GoogleFonts.roboto()),
                          title: Text('jenis Kelamin',
                              style: GoogleFonts.roboto()),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        width: _width,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 0.75,
                              blurRadius: 7,
                              offset: const Offset(
                                  0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: ListTile(
                          subtitle:
                              Text(data.agama, style: GoogleFonts.roboto()),
                          title: Text('Agama', style: GoogleFonts.roboto()),
                        ),
                      ),
                    ),
                  ],
                );
              } else {
                return Center(
                    child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 1.75,
                                blurRadius: 7,
                                offset: const Offset(
                                    0, 3), // changes position of shadow
                              ),
                            ],
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white),
                        child: const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator())));
              }
            }));
  }

  Future<void> _opendialogNama() async {
    await Future.delayed(const Duration(seconds: 2));
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text(
                "Nama Lengkap",
                style: GoogleFonts.roboto(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              content: TextField(
                controller: nama,
                decoration:
                    const InputDecoration(hintText: 'Masukkan Nama Lengkap'),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text("OKE"),
                  onPressed: () {
                    name = nama.text;
                    Navigator.of(context).pop();
                  },
                ),
              ]);
        });
  }

  Future<void> _opendialogTempatLahir() async {
    await Future.delayed(const Duration(seconds: 2));
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text(
                "Tempat Lahir",
                style: GoogleFonts.roboto(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              content: TextField(
                controller: tempatLahir,
                decoration:
                    const InputDecoration(hintText: 'Masukkan Temapat Lahir'),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text("OKE"),
                  onPressed: () {
                    tempatLahirC = tempatLahir.text;
                    Navigator.of(context).pop();
                  },
                ),
              ]);
        });
  }
}
