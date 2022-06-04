import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../controller/baselink.dart';
import '../../controller/conectyfity.dart';
import '../../home/controller/body_controller.dart';
import '../../home/models/komentar.dart';
import '../../home/provider/body_provider.dart';
import '../../home/widget/komentar_wiget.dart';
import '../../status/models/komentar.dart';
import '../../status/provider/status_provider.dart';
import '../../status/provider/post_status.dart';
import '../../status/models/privasi_status.dart';
import '../../../app_theme.dart';
import '../models/models.dart';
import '../controller/controller.dart';

class StatusPage extends StatefulWidget {
  const StatusPage({Key? key}) : super(key: key);

  @override
  _StatusPageState createState() => _StatusPageState();
}

class _StatusPageState extends State<StatusPage> {
  final BodyProvider bodyProvider = BodyProvider();
  RefreshController onRefresC = RefreshController();
  final StatusController statusC = Get.put(StatusController());
  final PostStatus postStatus = PostStatus();
  final GetCommment getCommment = GetCommment();
  final BaseLInkController baseLinkC = Get.put(BaseLInkController());
  final BodyController bodyC = Get.put(BodyController());

  String? pesan;
  var _offset = 0;
  var isLoading = false;

  ///ini dalah parameter mengirim komentar komentar
  Future addKomen(String id) async {
    try {
      SharedPreferences getToken = await SharedPreferences.getInstance();
      String? auth = getToken.getString("token");
      final headers = {
        'Content-Type': 'multipart/form-data',
        'Accept': 'application/json',
        'Authorization': '$auth',
      };
      var request = http.MultipartRequest(
          'POST', Uri.parse(baseLinkC.baseUrlUrlLaucer3 + '/api/status/komen'));
      request.fields
          .addAll({'id': id, 'tipe': 'status', 'text': statusC.komen.text});
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
      } else {
        // ignore: avoid_print
        print(response.reasonPhrase);
      }
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }
  }

  /// ini ini dalah parameter get komentar
  Future getKomentar(String id) async {
    final _baseUrl = baseLinkC.baseUrlUrlLaucer3 +
        '/api/status/komen?id=$id&tipe=status&offset=0';

    try {
      SharedPreferences getToken = await SharedPreferences.getInstance();
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
        Iterable it = jsonDecode(response.body)['data'];
        List<DataKomen> dataUserBlog =
            it.map((value) => DataKomen.fromJson(value)).toList();

        return dataUserBlog;
      }
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }
  }

  /// ini ini dalah parameter get status
  Future getStatus(int offset) async {
    if (mounted) {}
    final _baseUrl = baseLinkC.baseUrlUrlLaucer3 +
        '/api/status?limit=5&offset=$offset&tipe=status';

    try {
      SharedPreferences getToken = await SharedPreferences.getInstance();
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
        final data = jsonDecode(response.body)['data'];

        if (mounted) {
          setState(() {
            for (Map<String, dynamic> i in data) {
              statusC.listStatus.add(DataStatus.fromJson(i));
            }
          });
        }
      }
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }
  }

  Future<void> onSubcrabe() async {
    await FirebaseMessaging.instance.subscribeToTopic('status');
  }

  /// ini ini dalah parameter kirim status

  Future<void> onRefres() async {
    await Future.delayed(const Duration(seconds: 2));
    statusC.listStatus.clear();
    if (mounted) {
      setState(() {
        getStatus(0);
      });
    }

    onRefresC.refreshCompleted();
  }

  Future<void> onLoading() async {
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _offset = _offset + 5;
    });
    getStatus(_offset);
    onRefresC.loadComplete();
  }

  @override
  void initState() {
    super.initState();
    Provider.of<ConnectivityProfider>(context, listen: false)
        .strartMonitiring();
    getStatus(0);
    statusC.listItems = [
      ItemsPrivasi('public', 'Semua Member'),
      ItemsPrivasi('siswa', 'Hanya Siswa'),
    ];
    onSubcrabe();
  }

  // clear data
  @override
  void dispose() {
    statusC.listStatus.clear();
    statusC.listItems.clear();
    statusC.listItems.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Status"),
      ),
      body: Stack(
        children: [
          if (statusC.listStatus.isEmpty)
            Center(
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
                        child: CircularProgressIndicator()))),
          if (statusC.listStatus.isNotEmpty)
            Column(
              children: [
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                        backgroundColor: Colors.transparent,
                        isScrollControlled: true,
                        context: context,
                        builder: (context) {
                          return addStatus(_width, _height, context);
                        });
                  },
                  child: viewsAddStatus(_width),
                ),
                // cek konectifitas internet
                Consumer<ConnectivityProfider>(
                    builder: (context, models, child) {
                  // ceking here....
                  if (models.isOnline != null) {
                    return models.isOnline == true
                        ? Expanded(
                            child: SmartRefresher(
                            controller: onRefresC,
                            onRefresh: onRefres,
                            enablePullUp: true,
                            onLoading: onLoading,
                            child: ListView.separated(
                                scrollDirection: Axis.vertical,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      bodyC.namaUser =
                                          statusC.listStatus[index].nama;
                                      bodyC.tanggalPost =
                                          statusC.listStatus[index].tanggal;
                                      bodyC.idPost =
                                          statusC.listStatus[index].id;
                                      bodyC.judulPost = statusC
                                          .listStatus[index].judul
                                          .replaceAll("null", "");
                                      bodyC.avatar =
                                          statusC.listStatus[index].img;
                                      bodyC.isiPost = statusC
                                          .listStatus[index].detail
                                          .replaceAll("[", "")
                                          .replaceAll("]", "");
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const KomentarWidget()));
                                    },
                                    child: Container(
                                        width: _width,
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 20),
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.5),
                                              spreadRadius: 2,
                                              blurRadius: 7,
                                              offset: const Offset(0,
                                                  3), // changes position of shadow
                                            ),
                                          ],
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: Colors.white,
                                        ),
                                        child: Column(
                                          children: [
                                            Container(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 5),
                                              child: Column(children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 10),
                                                      child: CircleAvatar(
                                                        radius: 23,
                                                        backgroundColor:
                                                            Colors.white,
                                                        child: CircleAvatar(
                                                          radius: 20,
                                                          backgroundImage:
                                                              NetworkImage(
                                                            statusC
                                                                .listStatus[
                                                                    index]
                                                                .img,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        SizedBox(
                                                          width: 234,
                                                          child: Text(
                                                            statusC
                                                                .listStatus[
                                                                    index]
                                                                .nama,
                                                            style: GoogleFonts
                                                                .roboto(
                                                                    fontSize:
                                                                        15,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 234,
                                                          child: Text(
                                                            DateFormat(
                                                                    "d MMMM yyyy ,H:M ",
                                                                    "id_ID")
                                                                .format(DateTime
                                                                    .parse(statusC
                                                                        .listStatus[
                                                                            index]
                                                                        .tanggal)),
                                                            style: GoogleFonts
                                                                .roboto(
                                                                    fontSize:
                                                                        10,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w100),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Container(
                                                  margin: const EdgeInsets.only(
                                                      bottom: 10),
                                                  width: _width,
                                                  child: Text(
                                                    statusC.listStatus[index]
                                                        .detail
                                                        .replaceAll('[', '')
                                                        .replaceAll(']', ''),
                                                    maxLines: 5,
                                                    style: GoogleFonts.roboto(
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                ),
                                                const Divider(
                                                  height: 0,
                                                ),
                                                Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      TextButton.icon(
                                                          onPressed: () {},
                                                          icon: Image.asset(
                                                              'assets/icons/likeapp.png',
                                                              height: 16,
                                                              width: 16),
                                                          label: Text("like",
                                                              style: GoogleFonts.roboto(
                                                                  color: Colors
                                                                          .grey[
                                                                      500],
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold))),
                                                      TextButton.icon(
                                                          onPressed: () {
                                                            bodyC.namaUser =
                                                                statusC
                                                                    .listStatus[
                                                                        index]
                                                                    .nama;
                                                            bodyC.tanggalPost =
                                                                statusC
                                                                    .listStatus[
                                                                        index]
                                                                    .tanggal;
                                                            bodyC.idPost =
                                                                statusC
                                                                    .listStatus[
                                                                        index]
                                                                    .id;
                                                            bodyC.judulPost =
                                                                statusC
                                                                    .listStatus[
                                                                        index]
                                                                    .judul
                                                                    .replaceAll(
                                                                        "null",
                                                                        "");
                                                            bodyC.avatar =
                                                                statusC
                                                                    .listStatus[
                                                                        index]
                                                                    .img;
                                                            bodyC.isiPost =
                                                                statusC
                                                                    .listStatus[
                                                                        index]
                                                                    .detail
                                                                    .replaceAll(
                                                                        "[", "")
                                                                    .replaceAll(
                                                                        "]",
                                                                        "");
                                                            Navigator.of(
                                                                    context)
                                                                .push(MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            const KomentarWidget()));
                                                          },
                                                          icon: Icon(
                                                            Icons.chat_rounded,
                                                            size: 16,
                                                            color: Colors
                                                                .grey[600],
                                                          ),
                                                          label: FutureBuilder<
                                                                  KomentarModels?>(
                                                              future: bodyProvider
                                                                  .komentarBody(statusC
                                                                      .listStatus[
                                                                          index]
                                                                      .id),
                                                              builder:
                                                                  (BuildContext
                                                                          context,
                                                                      snapshot) {
                                                                if (snapshot
                                                                    .hasData) {
                                                                  return Text(
                                                                      "Komentar (" +
                                                                          snapshot
                                                                              .data!
                                                                              .countall
                                                                              .toString() +
                                                                          ")",
                                                                      style: GoogleFonts.roboto(
                                                                          color: Colors.grey[
                                                                              500],
                                                                          fontSize:
                                                                              10,
                                                                          fontWeight:
                                                                              FontWeight.bold));
                                                                } else {
                                                                  return Text(
                                                                      "Komentar (0)",
                                                                      style: GoogleFonts.roboto(
                                                                          color: Colors.grey[
                                                                              500],
                                                                          fontSize:
                                                                              10,
                                                                          fontWeight:
                                                                              FontWeight.bold));
                                                                }
                                                              })),
                                                    ])
                                              ]),
                                            ),
                                            // if (index == statusC.expended)
                                            //   SizedBox(
                                            //     width: _width,
                                            //     height:
                                            //         statusC.listKomen.isNotEmpty
                                            //             ? 300
                                            //             : 93,
                                            //     child: Column(
                                            //       children: [
                                            //         const Divider(
                                            //           height: 0,
                                            //         ),
                                            //         if (statusC
                                            //             .listKomen.isNotEmpty)
                                            //           FutureBuilder<
                                            //                   KomentModels?>(
                                            //               future: getCommment
                                            //                   .getKomentar(statusC
                                            //                       .idK
                                            //                       .toString()),
                                            //               builder: (BuildContext
                                            //                       context,
                                            //                   snapshot) {
                                            //                 if (snapshot
                                            //                     .hasData) {
                                            //                   return Expanded(
                                            //                     child: ListView
                                            //                         .builder(
                                            //                             itemCount: snapshot
                                            //                                 .data!
                                            //                                 .data
                                            //                                 .length,
                                            //                             itemBuilder:
                                            //                                 (context,
                                            //                                     index) {
                                            //                               return Column(
                                            //                                 children: [
                                            //                                   Row(
                                            //                                     children: [
                                            //                                       const CircleAvatar(
                                            //                                         radius: 20,
                                            //                                         backgroundColor: Colors.white,
                                            //                                         child: CircleAvatar(
                                            //                                           radius: 18,
                                            //                                           backgroundImage: NetworkImage("https://sma1contoh.sekolahkita.net/assets/images/avatar-akun.png"),
                                            //                                         ),
                                            //                                       ),
                                            //                                       const SizedBox(
                                            //                                         width: 10,
                                            //                                       ),
                                            //                                       Container(
                                            //                                         width: _width / 1.75,
                                            //                                         margin: const EdgeInsets.only(top: 10, right: 30),
                                            //                                         padding: const EdgeInsets.all(15),
                                            //                                         decoration: BoxDecoration(
                                            //                                           borderRadius: const BorderRadius.only(
                                            //                                             topLeft: Radius.circular(25),
                                            //                                             topRight: Radius.circular(15),
                                            //                                             bottomRight: Radius.circular(15),
                                            //                                           ),
                                            //                                           color: index.isEven ? Colors.blue.withOpacity(0.1) : Colors.amber.withOpacity(0.1),
                                            //                                         ),
                                            //                                         child: Column(
                                            //                                           children: [
                                            //                                             Row(
                                            //                                               mainAxisAlignment: MainAxisAlignment.start,
                                            //                                               mainAxisSize: MainAxisSize.max,
                                            //                                               children: [
                                            //                                                 Flexible(
                                            //                                                   child: Text(
                                            //                                                     snapshot.data!.data[index].komentarNama,
                                            //                                                     style: GoogleFonts.roboto(fontWeight: FontWeight.bold, fontSize: 14),
                                            //                                                   ),
                                            //                                                 ),
                                            //                                               ],
                                            //                                             ),
                                            //                                             Row(
                                            //                                               mainAxisAlignment: MainAxisAlignment.start,
                                            //                                               children: [
                                            //                                                 SizedBox(
                                            //                                                   width: _width / 2.10,
                                            //                                                   child: Text(
                                            //                                                     snapshot.data!.data[index].komentarIsi,
                                            //                                                     style: GoogleFonts.roboto(fontSize: 14),
                                            //                                                     maxLines: 5,
                                            //                                                   ),
                                            //                                                 ),
                                            //                                               ],
                                            //                                             ),
                                            //                                           ],
                                            //                                         ),
                                            //                                       ),
                                            //                                     ],
                                            //                                   ),
                                            //                                   const SizedBox(height: 5),
                                            //                                   Row(
                                            //                                     mainAxisAlignment: MainAxisAlignment.start,
                                            //                                     children: [
                                            //                                       const SizedBox(
                                            //                                         width: 50,
                                            //                                       ),
                                            //                                       Text(snapshot.data!.data[index].komentarTanggal),
                                            //                                     ],
                                            //                                   )
                                            //                                 ],
                                            //                               );
                                            //                             }),
                                            //                   );
                                            //                 } else {
                                            //                   return Container(
                                            //                     height: 70,
                                            //                   );
                                            //                 }
                                            //               }),
                                            //         Container(
                                            //             margin: EdgeInsets.only(
                                            //                 bottom: MediaQuery.of(
                                            //                         context)
                                            //                     .padding
                                            //                     .bottom),
                                            //             padding: const EdgeInsets
                                            //                     .symmetric(
                                            //                 vertical: 10),
                                            //             width: _width,
                                            //             height: 75,
                                            //             child: Row(
                                            //                 mainAxisAlignment:
                                            //                     MainAxisAlignment
                                            //                         .spaceBetween,
                                            //                 children: [
                                            //                   Expanded(
                                            //                       child:
                                            //                           TextField(
                                            //                     controller:
                                            //                         statusC.komen,
                                            //                     decoration:
                                            //                         InputDecoration(
                                            //                       hintText:
                                            //                           "Add your Comment....",
                                            //                       prefixIcon:
                                            //                           IconButton(
                                            //                         onPressed:
                                            //                             () {},
                                            //                         icon: const Icon(
                                            //                             Icons
                                            //                                 .emoji_emotions_outlined),
                                            //                       ),
                                            //                       border:
                                            //                           OutlineInputBorder(
                                            //                         borderRadius:
                                            //                             BorderRadius
                                            //                                 .circular(
                                            //                                     100),
                                            //                       ),
                                            //                     ),
                                            //                   )),
                                            //                   const SizedBox(
                                            //                       width: 10),
                                            //                   Material(
                                            //                     borderRadius:
                                            //                         BorderRadius
                                            //                             .circular(
                                            //                                 100),
                                            //                     color: const Color(
                                            //                         0xff20bfcc),
                                            //                     child: InkWell(
                                            //                       borderRadius:
                                            //                           BorderRadius
                                            //                               .circular(
                                            //                                   100),
                                            //                       onTap: () {
                                            //                         setState(() {
                                            //                           getKomentar(statusC
                                            //                               .listStatus[
                                            //                                   index]
                                            //                               .id);
                                            //                           addKomen(statusC
                                            //                               .listStatus[
                                            //                                   index]
                                            //                               .id);
                                            //                         });
                                            //                         Future.delayed(
                                            //                             const Duration(
                                            //                                 seconds:
                                            //                                     2),
                                            //                             () {
                                            //                           setState(
                                            //                               () {
                                            //                             statusC
                                            //                                 .komen
                                            //                                 .clear();
                                            //                           });
                                            //                         });
                                            //                       },
                                            //                       child:
                                            //                           const Padding(
                                            //                         padding:
                                            //                             EdgeInsets
                                            //                                 .all(
                                            //                                     10),
                                            //                         child: Icon(
                                            //                           Icons.send,
                                            //                           color: Colors
                                            //                               .white,
                                            //                         ),
                                            //                       ),
                                            //                     ),
                                            //                   ),
                                            //                 ]))
                                            //       ],
                                            //     ),
                                            //   )
                                          ],
                                        )),
                                  );
                                },
                                separatorBuilder: (context, index) {
                                  return const SizedBox(
                                    height: 10,
                                  );
                                },
                                itemCount: statusC.listStatus.length),
                          ))
                        //no internet
                        : Expanded(
                            child: Center(
                                child: Lottie.asset(
                              'assets/icons/-no-internet-connection.json',
                            )),
                          );
                  }
                  return const CircularProgressIndicator();
                }),
              ],
            ),
        ],
      ),
    );
  }

  Container viewsAddStatus(double _width) {
    return Container(
        margin: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        width: _width,
        height: 100,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: AppTheme.white,
                      child: CircleAvatar(
                        radius: 17,
                        backgroundImage: NetworkImage(bodyC.foto),
                      ),
                    ),
                  ),
                  Container(
                    width: _width - 110,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 37, vertical: 10),
                    margin: const EdgeInsets.only(
                      right: 10,
                    ),
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(30)),
                    child: const Text(
                      'Apa yang anda Pikirkan ?',
                      style: TextStyle(fontSize: 15, color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                    onPressed: () {},
                    child: Text("Foto/Vedeo",
                        style: GoogleFonts.roboto(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.bold)),
                  ),
                  TextButton(
                      onPressed: () {},
                      child: Text("Tag Frieds",
                          style: GoogleFonts.roboto(
                              color: Colors.grey[600],
                              fontWeight: FontWeight.bold))),
                  TextButton(
                      onPressed: () {},
                      child: Text("Perasaan/Aktivitas",
                          style: GoogleFonts.roboto(
                              color: Colors.grey[600],
                              fontWeight: FontWeight.bold))),
                ],
              ),
            )
          ],
        ));
  }

  SingleChildScrollView addStatus(
      double _width, double _height, BuildContext context) {
    return SingleChildScrollView(
      child: Container(
          margin:
              const EdgeInsets.only(top: 100, bottom: 160, left: 10, right: 10),
          width: _width,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Text("Buat Postingan",
                  style: GoogleFonts.roboto(
                      color: Colors.grey[800],
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),
              const SizedBox(
                height: 20,
              ),
              const Divider(),
              Row(children: [
                Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      child: const CircleAvatar(
                        radius: 23,
                        backgroundColor: Color(0xff20bfcc),
                        child: CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                            radius: 18,
                            backgroundImage: NetworkImage(
                                'https://i0.wp.com/itpoin.com/wp-content/uploads/2014/06/guest.png'),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: _height / 3,
                    )
                  ],
                ),
                SizedBox(
                    width: _width - 86,
                    child: CupertinoTextField(
                      controller: statusC.data,
                      placeholder: 'Apa yang Anda Pikirkan Sekarang? ',
                      maxLines: 12,
                      decoration: BoxDecoration(
                        border: null,
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ))
              ]),
              const Divider(),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text('Privasi',
                          style: GoogleFonts.roboto(
                              color: Colors.grey[500],
                              fontSize: 15,
                              fontWeight: FontWeight.bold)),
                    ),
                    Container(
                      height: 40,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                      ),
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(5)),
                      child: DropdownButton(
                        underline: Container(),
                        elevation: 16,
                        value: statusC.selecItems,
                        hint: const Text('Pilih Privasi'),
                        items: statusC.listItems
                            .map(
                              (list) => DropdownMenuItem(
                                child: Text(list.items),
                                value: list.id,
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            statusC.selecItems = value as String?;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        onRefres();
                        postStatus.addData();
                      },
                      child: const Text("kirim")),
                )
              ])
            ],
          )),
    );
  }
}
