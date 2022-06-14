import 'dart:async';
import 'dart:convert';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import '../../controller/baselink.dart';
import '../models/soalessay.dart';
import '../providers/tugas_providers.dart';
import '../widget/costom_menu.dart';
import 'tugas_siswa.dart';

class PengerjaanTugasEsay extends StatefulWidget {
  const PengerjaanTugasEsay({
    Key? key,
    required this.id,
  }) : super(key: key);
  final String id;
  @override
  State<PengerjaanTugasEsay> createState() => _PengerjaanTugasEsayState();
}

class _PengerjaanTugasEsayState extends State<PengerjaanTugasEsay>
    with SingleTickerProviderStateMixin<PengerjaanTugasEsay> {
  late AnimationController _animationController;
  late StreamController<bool> isSidebarOpenedStreamController;
  late Stream<bool> isSidebarOpenedStream;
  late StreamSink<bool> isSidebarOpenedSink;
  final TextEditingController jawaban = TextEditingController(text: '');
  final TextEditingController linkJawaban = TextEditingController(text: '');
  final BaseLInkController baseLinkC = Get.put(BaseLInkController());
  File? file;
  DateTime timeBackPressed = DateTime.now();
  String? uRL;

  Codec<String, String> stringToBase64Url = utf8.fuse(base64Url);

  final TugasProvider tugasProvider = TugasProvider();
  final _animatedDurations = const Duration(microseconds: 500);
  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: _animatedDurations);
    isSidebarOpenedStreamController = PublishSubject<bool>();
    isSidebarOpenedStream = isSidebarOpenedStreamController.stream;
    isSidebarOpenedSink = isSidebarOpenedStreamController.sink;
  }

  @override
  void dispose() {
    _animationController.dispose();
    isSidebarOpenedStreamController.close();
    isSidebarOpenedSink.close();
    super.dispose();
  }

  void onIconPressed() {
    final animationStatus = _animationController.status;
    final isAnimationCompleted = animationStatus == AnimationStatus.completed;

    if (isAnimationCompleted) {
      isSidebarOpenedSink.add(false);
      _animationController.reverse();
    } else {
      isSidebarOpenedSink.add(true);
      _animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final fileName = file != null ? basename(file!.path) : 'No File Chosen !';
    return WillPopScope(
      onWillPop: () async {
        final shouldPop = await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                  title: Text(
                    "Anda Yakin Ingin Keluar ?",
                    style: GoogleFonts.roboto(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.red),
                  ),
                  content: Text(
                    "Simpan sementara untuk menyimpan jawaban sementara",
                    style: GoogleFonts.roboto(),
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: const Text("OKE"),
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                    ),
                    TextButton(
                      child: const Text("Keluar"),
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                    ),
                  ]);
            });
        return shouldPop ?? false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Pengerjaaan Tugas'),
        ),
        body: Stack(
          children: [
            FutureBuilder<SoalEssay?>(
                future: tugasProvider.soalEssay(widget.id),
                builder: (BuildContext context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: Lottie.asset(
                        'assets/images/98586-loading-oneplace.json',
                        width: 200,
                        height: 200,
                        fit: BoxFit.fill,
                      ),
                    );
                  } else {
                    if (snapshot.hasData) {
                      return snapshot.data!.data.soal.ext != "pdf" &&
                              snapshot.data!.data.soal.type == "umum"
                          ? SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child:
                                  Image.network(snapshot.data!.data.soal.file),
                            )
                          : snapshot.data!.data.soal.ext == "pdf"
                              ? Container(
                                  child: const PDF().cachedFromUrl(
                                    snapshot.data!.data.soal.file,
                                    placeholder: (double progress) =>
                                        Center(child: Text('$progress %')),
                                    errorWidget: (dynamic error) =>
                                        Center(child: Text(error.toString())),
                                  ),
                                )
                              : Container(
                                  padding: const EdgeInsets.all(20),
                                  width: MediaQuery.of(context).size.width,
                                  height: MediaQuery.of(context).size.height,
                                  color: Colors.white,
                                  child: HtmlWidget(
                                    //to show HTML as widget.
                                    snapshot.data!.data.soal.text,
                                  ));
                    } else {
                      return Center(
                        child: Column(
                          children: [
                            const SizedBox(height: 100),
                            Lottie.asset(
                              'assets/images/8616-not-found.json',
                              width: 200,
                              height: 200,
                              fit: BoxFit.fill,
                            ),
                            Text(
                              "Tidak Anda Soal Tersedia Hubungi Guru Mata pelajan yang mengampu !",
                              style: GoogleFonts.roboto(
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            )
                          ],
                        ),
                      );
                    }
                  }
                }),
            StreamBuilder<bool>(
                initialData: false,
                stream: isSidebarOpenedStream,
                builder: (context, isSideBarOpenedAsync) {
                  return AnimatedPositioned(
                    duration: _animatedDurations,
                    top: 0,
                    bottom: 0,
                    left: isSideBarOpenedAsync.data! ? 0 : 0,
                    right: isSideBarOpenedAsync.data! ? 0 : _width - 35,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            color: const Color.fromARGB(255, 24, 144, 155),
                            child: ListView(
                              children: <Widget>[
                                const SizedBox(
                                  height: 20,
                                ),
                                const Text(
                                  "JAWABAN ANDA",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800),
                                ),
                                Divider(
                                  color: Colors.white.withOpacity(0.3),
                                ),
                                Container(
                                    width: MediaQuery.of(context).size.width /
                                        1.70,
                                    padding: const EdgeInsets.only(top: 20),
                                    child: Text(
                                      'Upload File',
                                      style: GoogleFonts.roboto(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: const Color.fromARGB(
                                              255, 93, 234, 247)),
                                    )),
                                Container(
                                    width: MediaQuery.of(context).size.width /
                                        1.70,
                                    padding: const EdgeInsets.all(10),
                                    child: Text(
                                      'Type file yang diizinkan: (doc, docx, xls, xlsx, ppt, pptx, jpg, jpeg, png, pdf) | Ukuran maksimal : 3 MB',
                                      style: GoogleFonts.roboto(
                                          color: Colors.white),
                                    )),
                                Row(
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                166,
                                            height: 60,
                                            margin: const EdgeInsets.only(
                                                top: 10, right: 5),
                                            padding: const EdgeInsets.all(10),
                                            alignment: Alignment.centerLeft,
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                boxShadow: const [
                                                  BoxShadow(
                                                    color: Colors.black26,
                                                    blurRadius: 6,
                                                    offset: Offset(0, 2),
                                                  )
                                                ]),
                                            child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: Text(fileName,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 10,
                                                        style:
                                                            GoogleFonts.roboto(
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
                                    Container(
                                      padding: const EdgeInsets.all(5),
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            primary: const Color.fromARGB(
                                                255, 16, 92, 99),
                                            side: const BorderSide(
                                                width: 1, color: Colors.black),
                                          ),
                                          child: Text(
                                            'Upload',
                                            style: GoogleFonts.roboto(
                                                fontSize: 12),
                                          ),
                                          onPressed: () async {}),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(
                                            width: 200,
                                            child: Text(
                                              'Keterangan Jawaban',
                                              style: GoogleFonts.roboto(
                                                  fontSize: 16,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            )),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: const Color.fromARGB(
                                                  255, 10, 221, 240)
                                              .withOpacity(0.5)),
                                      child: TextFormField(
                                        controller: jawaban,
                                        maxLines: 7,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintStyle: GoogleFonts.roboto(
                                              color: Colors.white),
                                          hintText:
                                              "Tulis jawaban simngkat di sisni ...",
                                          filled: true,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(
                                            width: 200,
                                            child: Text(
                                              'Link Tautan (Optional)',
                                              style: GoogleFonts.roboto(
                                                  fontSize: 16,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            )),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: const Color.fromARGB(
                                                  255, 10, 221, 240)
                                              .withOpacity(0.5)),
                                      child: TextFormField(
                                        controller: linkJawaban,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintStyle: GoogleFonts.roboto(
                                              color: Colors.white),
                                          hintText:
                                              "Masukan link Exsternal (Optional) ...",
                                          filled: true,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          primary: Colors.green),
                                      onPressed: () async {
                                        postJawabanSiswa(widget.id, false);
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
                                          pd.update(
                                              value: i, msg: 'Mengirim...');
                                          i++;
                                          await Future.delayed(const Duration(
                                              milliseconds: 100));
                                        }
                                        Navigator.of(context).pop();
                                      },
                                      child: Text(
                                        "Simpan Smentara",
                                        style: GoogleFonts.roboto(),
                                      )),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          primary: Colors.red),
                                      onPressed: () async {
                                        postJawabanSiswa(widget.id, true);
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
                                          pd.update(
                                              value: i, msg: 'Mengirim...');
                                          i++;
                                          await Future.delayed(const Duration(
                                              milliseconds: 100));
                                        }
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const TugsSiswaViews()));
                                      },
                                      child: Text(
                                        "Selesai",
                                        style: GoogleFonts.roboto(),
                                      )),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Align(
                          alignment: const Alignment(0, -0.9),
                          child: GestureDetector(
                            onTap: () {
                              onIconPressed();
                            },
                            child: ClipPath(
                              clipper: CustomMenuClipper(),
                              child: Container(
                                color: const Color.fromARGB(255, 24, 144, 155),
                                width: 35,
                                height: 90,
                                alignment: Alignment.centerLeft,
                                child: AnimatedIcon(
                                  progress: _animationController.view,
                                  icon: AnimatedIcons.menu_close,
                                  color:
                                      const Color.fromARGB(255, 76, 228, 241),
                                  size: 25,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                })
          ],
        ),
      ),
    );
  }

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);
    if (result == null) return;
    final path = result.files.single.path!;
    setState(() => file = File(path));
  }

  Future postJawabanSiswa(String id, bool simpan) async {
    if (file == null) return;

    SharedPreferences getToken = await SharedPreferences.getInstance();
    String? auth = getToken.getString("token");
    final headers = {
      'Content-Type': 'multipart/form-data',
      'Accept': 'application/json',
      'Authorization': '$auth',
    };
    var request = http.MultipartRequest('POST',
        Uri.parse(baseLinkC.baseUrlUrlLaucer3 + "/api/tugas/tugasjawab"));

    request.files.add(await http.MultipartFile.fromPath(
      'file',
      file!.path,
    ));
    request.fields.addAll({
      'idtugas': id,
      'jawaban': jawaban.text,
      'linkjawaban': linkJawaban.text,
      'simpan_akhir': simpan.toString()
    });
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      final data = await response.stream.bytesToString();
      var it = jsonDecode(data);

      if (it['status'] == true) {
        // ignore: avoid_print
        print("behasil");
      } else {
        // ignore: avoid_print
        print('gagal');
      }
    } else {
      // ignore: avoid_print
      print(response.reasonPhrase);
    }
  }
}
