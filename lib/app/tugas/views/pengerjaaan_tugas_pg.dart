import 'dart:async';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smk_4_yogyakrata/app/tugas/views/tugas_siswa.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import '../../controller/baselink.dart';
import '../models/soaloptions.dart';
import '../models/riwayat_pengerjaan.dart';
import '../models/send_all_jawaban.dart';
import '../providers/tugas_providers.dart';
import '../widget/costom_menu.dart';

class PengerjaanTugas extends StatefulWidget {
  const PengerjaanTugas({
    Key? key,
    required this.id,
  }) : super(key: key);
  final String id;
  @override
  State<PengerjaanTugas> createState() => _PengerjaanTugasState();
}

class _PengerjaanTugasState extends State<PengerjaanTugas>
    with SingleTickerProviderStateMixin<PengerjaanTugas> {
  late AnimationController _animationController;
  late StreamController<bool> isSidebarOpenedStreamController;
  late Stream<bool> isSidebarOpenedStream;
  late StreamSink<bool> isSidebarOpenedSink;
  DateTime timeBackPressed = DateTime.now();
  final BaseLInkController baseLinkC = Get.put(BaseLInkController());
  // ignore: prefer_typing_uninitialized_variables
  var indexToi;
  int indexNo = 0;
  List<ItemsJawabanAll> listItemsJawaban = [];
  // ignore: prefer_typing_uninitialized_variables
  var key;
  String? uRL;
  String? selectedOptions;
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
    riwayatTugas(indexNo + 1, widget.id);
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

  Future riwayatTugas(int nomor, String id) async {
    final _baseUrl = baseLinkC.baseUrlUrlLaucer3 +
        "/api/tugas/kerjakan?idtugas=$id&nomor=$nomor";
    try {
      SharedPreferences getToken = await SharedPreferences.getInstance();
      // ignore: unused_local_variable
      String? auth = getToken.getString("token");
      final response = await http.get(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': '$auth',
        },
      );
      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        final data = riwayatPengerjaanFromJson(response.body);
        if (mounted) {
          setState(() {
            if (data.data.opsijawaban.opsi.status == "selected") {
              if (data.data.opsijawaban.opsi.jawab == "A") {
                indexToi = 0;
                key = data.data.opsijawaban.opsi.jawab;
              } else if (data.data.opsijawaban.opsi.jawab == "B") {
                indexToi = 1;
                key = data.data.opsijawaban.opsi.jawab;
              } else if (data.data.opsijawaban.opsi.jawab == "C") {
                indexToi = 2;
                key = data.data.opsijawaban.opsi.jawab;
              } else if (data.data.opsijawaban.opsi.jawab == "D") {
                indexToi = 3;
                key = data.data.opsijawaban.opsi.jawab;
              } else if (data.data.opsijawaban.opsi.jawab == "E") {
                indexToi = 4;
                key = data.data.opsijawaban.opsi.jawab;
              } else {
                indexToi = '';
              }
            } else {
              indexToi = '';
            }
          });
        }
      }
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }
  }

  Future<bool> onWillPop() async {
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
                "Jangan lupa Simpan sementara untuk menyimpan jawaban sementara",
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
  }

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Pengerjaaan Tugas'),
        ),
        body: Stack(
          children: [
            FutureBuilder<GetOptions?>(
                future: tugasProvider.soalOptions(widget.id),
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
                                FutureBuilder<GetOptions?>(
                                    future:
                                        tugasProvider.soalOptions(widget.id),
                                    builder: (BuildContext context, snapshot) {
                                      if (snapshot.hasData) {
                                        return ListView.builder(
                                            shrinkWrap: true,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            itemCount: snapshot
                                                .data!.data.opsijawaban.length,
                                            itemBuilder: (context, index) {
                                              return Column(
                                                children: [
                                                  if (index == indexNo)
                                                    Text(
                                                        "${snapshot.data!.data.opsijawaban[index].nomor}.  Pilih jawaban Kamu Dengan benar",
                                                        style:
                                                            GoogleFonts.roboto(
                                                                color: Colors
                                                                    .white)),
                                                  if (index == indexNo)
                                                    ListView.builder(
                                                      shrinkWrap: true,
                                                      itemCount: snapshot
                                                          .data!
                                                          .data
                                                          .opsijawaban[index]
                                                          .opsi
                                                          .length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        return Row(
                                                          children: [
                                                            Radio(
                                                                activeColor:
                                                                    Colors
                                                                        .white,
                                                                value: index,
                                                                groupValue:
                                                                    indexToi,
                                                                onChanged:
                                                                    (value) {
                                                                  setState(() {
                                                                    indexToi =
                                                                        value
                                                                            as int;
                                                                    if (value ==
                                                                        index) {
                                                                      key = snapshot
                                                                          .data!
                                                                          .data
                                                                          .opsijawaban[
                                                                              index]
                                                                          .opsi[
                                                                              index]
                                                                          .jawab;
                                                                    }
                                                                  });
                                                                }),
                                                            const SizedBox(
                                                              width: 10,
                                                            ),
                                                            Text(
                                                                snapshot
                                                                    .data!
                                                                    .data
                                                                    .opsijawaban[
                                                                        index]
                                                                    .opsi[index]
                                                                    .jawab,
                                                                style: GoogleFonts.roboto(
                                                                    color: Colors
                                                                        .white)),
                                                            const SizedBox(
                                                              width: 10,
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    ),
                                                  if (index == indexNo)
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 80),
                                                      child: Row(
                                                        children: [
                                                          ElevatedButton(
                                                              style: ElevatedButton
                                                                  .styleFrom(
                                                                      primary:
                                                                          Colors
                                                                              .green),
                                                              onPressed:
                                                                  () async {
                                                                ProgressDialog //loading progres indikator
                                                                    pd =
                                                                    ProgressDialog(
                                                                        context:
                                                                            context);
                                                                pd.show(
                                                                  max: 100,
                                                                  msg:
                                                                      'Loading...',
                                                                  progressType:
                                                                      ProgressType
                                                                          .valuable,
                                                                );
                                                                await Future.delayed(
                                                                    const Duration(
                                                                        //durasi proses
                                                                        milliseconds:
                                                                            3000));
                                                                for (int i = 0;
                                                                    i <= 100;
                                                                    i++) {
                                                                  /// You can indicate here that the download has started.
                                                                  pd.update(
                                                                      value: i,
                                                                      msg:
                                                                          'Proses Menyimpan...');
                                                                  i++;
                                                                  await Future.delayed(
                                                                      const Duration(
                                                                          milliseconds:
                                                                              100));
                                                                }
                                                                Alert(
                                                                    context:
                                                                        context,
                                                                    title:
                                                                        "Simpan Tugas Berhasil",
                                                                    type: AlertType
                                                                        .success,
                                                                    buttons: [
                                                                      DialogButton(
                                                                        child:
                                                                            Text(
                                                                          "OK",
                                                                          style: GoogleFonts.roboto(
                                                                              color: Colors.white,
                                                                              fontSize: 20),
                                                                        ),
                                                                        onPressed:
                                                                            () =>
                                                                                Navigator.pop(context),
                                                                        color: Colors
                                                                            .blue,
                                                                      ),
                                                                    ]).show();
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                              child: Text(
                                                                "Simpan Sementara",
                                                                style: GoogleFonts
                                                                    .roboto(),
                                                              )),
                                                          const SizedBox(
                                                            width: 10,
                                                          ),
                                                          ElevatedButton(
                                                              onPressed: () {
                                                                tugasProvider
                                                                    .addJawaban(
                                                                  widget.id,
                                                                  snapshot
                                                                      .data!
                                                                      .data
                                                                      .opsijawaban[
                                                                          index]
                                                                      .nomor
                                                                      .toString(),
                                                                  key,
                                                                );
                                                                setState(() {
                                                                  indexNo++;
                                                                  indexToi = '';
                                                                  riwayatTugas(
                                                                      indexNo +
                                                                          1,
                                                                      widget
                                                                          .id);
                                                                  listItemsJawaban.add(
                                                                      ItemsJawabanAll(
                                                                          data: [
                                                                        Datum(
                                                                            key:
                                                                                snapshot.data!.data.opsijawaban[index].nomor.toString(),
                                                                            jawab: key)
                                                                      ]));
                                                                });
                                                              },
                                                              child: Text(
                                                                "Lanjutkan ->",
                                                                style: GoogleFonts
                                                                    .roboto(),
                                                              )),
                                                        ],
                                                      ),
                                                    )
                                                ],
                                              );
                                            });
                                      } else {
                                        return Center(
                                          child: Container(
                                              padding: const EdgeInsets.all(10),
                                              child:
                                                  const CircularProgressIndicator()),
                                        );
                                      }
                                    }),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          primary: Colors.red),
                                      onPressed: () async {
                                        tugasProvider.addJawabanFinis(
                                            widget.id, '', key, false);
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
                                height: 110,
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
}
