import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../controller/baselink.dart';
import '../../status/controller/controller.dart';
import '../../status/models/kometar_models.dart';
import '../../status/provider/post_status.dart';
import '../../status/provider/status_provider.dart';
import '../controller/body_controller.dart';
import '../models/komentar.dart';
import '../models/models_status.dart';
import '../provider/body_provider.dart';

class KomentarWidget extends StatefulWidget {
  const KomentarWidget({Key? key}) : super(key: key);

  @override
  State<KomentarWidget> createState() => _KomentarWidgetState();
}

class _KomentarWidgetState extends State<KomentarWidget> {
  final BodyProvider bodyProvider = BodyProvider();
  final BodyController bodyC = Get.put(BodyController());
  final GetCommment getCommment = GetCommment();
  final StatusController statusC = Get.put(StatusController());
  final BaseLInkController baseLinkC = Get.put(BaseLInkController());
  final PostStatus postStatus = PostStatus();
  bool _isExpanded = false;
  ScrollController controller = ScrollController();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Post"),
        ),
        bottomNavigationBar: _isExpanded == false
            ? GestureDetector(
                onTap: () {
                  setState(() {
                    _isExpanded = true;
                  });
                },
                child: Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: const Color(0xff20bfcc)),
                      borderRadius: BorderRadius.circular(50)),
                  width: MediaQuery.of(context).size.width - 28,
                  height: 50,
                  child: Row(
                    children: const [
                      Icon(Icons.emoji_emotions_outlined),
                      SizedBox(
                        width: 15,
                      ),
                      Text("Add your Comment...."),
                      SizedBox(
                        width: 100,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Icon(
                          Icons.send,
                          color: Color(0xff20bfcc),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: ElevatedButton(
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ))),
                  onPressed: () {
                    addKomen(bodyC.idPost.toString());
                    postStatus.sendNotifAddStatus(
                        " Ada Komnetar baru nih ${bodyC.namaUser}",
                        statusC.komen.text);
                    Future.delayed(const Duration(seconds: 1), () {
                      setState(() {
                        _isExpanded = false;
                        statusC.komen.clear();
                      });
                    });
                  },
                  child: const Text("Kirim"),
                ),
              ),
        body: SingleChildScrollView(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                FutureBuilder<StatusSiswa?>(
                    future: bodyProvider.getStatusBody(),
                    builder: (BuildContext context, snapshot) {
                      if (snapshot.hasData) {
                        return Container(
                            padding: const EdgeInsets.all(10),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 1,
                                  blurRadius: 7,
                                  offset: const Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ],
                              color: Colors.white,
                            ),
                            child: Column(children: [
                              Column(
                                children: [
                                  Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        CircleAvatar(
                                          radius: 23,
                                          backgroundColor: Colors.white,
                                          child: CircleAvatar(
                                            backgroundColor: Colors.grey[300],
                                            radius: 21,
                                            backgroundImage: NetworkImage(
                                                bodyC.avatar.toString()),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Column(
                                          children: [
                                            SizedBox(
                                              width: 200,
                                              child: Text(
                                                bodyC.namaUser.toString(),
                                                style: GoogleFonts.inter(
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 200,
                                              child: Text(
                                                DateFormat.yMMMMd()
                                                    .add_jm()
                                                    .format(DateTime.parse(bodyC
                                                        .tanggalPost
                                                        .toString()
                                                        .toString())),
                                                style: GoogleFonts.roboto(
                                                    fontSize: 10,
                                                    fontWeight:
                                                        FontWeight.w100),
                                              ),
                                            )
                                          ],
                                        ),
                                      ]),
                                  Container(
                                    padding: const EdgeInsets.only(top: 20),
                                    width: MediaQuery.of(context).size.width,
                                    child: Text(
                                      bodyC.judulPost.toString(),
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.start,
                                      maxLines: 5,
                                      style: GoogleFonts.inter(
                                          color: Colors.black87,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Container(
                                    height: 200,
                                    padding: const EdgeInsets.only(top: 20),
                                    width: MediaQuery.of(context).size.width,
                                    child: Text(
                                      bodyC.isiPost.toString(),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 12,
                                      textAlign: TextAlign.justify,
                                      style: GoogleFonts.inter(
                                          color: Colors.black87,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      TextButton.icon(
                                          onPressed: () {},
                                          icon: Image.asset(
                                              'assets/icons/likeapp.png',
                                              height: 14,
                                              width: 14),
                                          label: Text(" (0) ",
                                              style: GoogleFonts.roboto(
                                                  color: Colors.grey[500],
                                                  fontSize: 10,
                                                  fontWeight:
                                                      FontWeight.bold))),
                                      TextButton.icon(
                                          onPressed: () {},
                                          icon: Icon(Icons.chat_rounded,
                                              size: 13,
                                              color: Colors.grey[500]),
                                          label: FutureBuilder<KomentarModels?>(
                                              future: bodyProvider.komentarBody(
                                                  bodyC.idPost.toString()),
                                              builder: (BuildContext context,
                                                  snapshot) {
                                                if (snapshot.hasData) {
                                                  return Text(
                                                      "(" +
                                                          snapshot
                                                              .data!.countall
                                                              .toString() +
                                                          ")",
                                                      style: GoogleFonts.roboto(
                                                          color:
                                                              Colors.grey[500],
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.bold));
                                                } else {
                                                  return Text(" (0) ",
                                                      style: GoogleFonts.roboto(
                                                          color:
                                                              Colors.grey[500],
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.bold));
                                                }
                                              }))
                                    ],
                                  )
                                ],
                              ),
                            ]));
                      } else {
                        return SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          child: Center(
                              child: Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 1.75,
                                          blurRadius: 7,
                                          offset: const Offset(0,
                                              3), // changes position of shadow
                                        ),
                                      ],
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white),
                                  child: const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator()))),
                        );
                      }
                    }),
                if (_isExpanded == true)
                  Container(
                    color: Colors.white,
                    width: MediaQuery.of(context).size.width,
                    height: 200,
                    child: CupertinoTextField(
                      controller: statusC.komen,
                      placeholder: 'Add your Comment....',
                      maxLines: 12,
                      decoration: BoxDecoration(
                        border: null,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 7,
                            offset: const Offset(
                                0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                    ),
                  ),
                FutureBuilder<KomentModels?>(
                    future: getCommment.getKomentar(bodyC.idPost.toString()),
                    builder: (BuildContext context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            controller: controller,
                            itemCount: snapshot.data!.data.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        const CircleAvatar(
                                          radius: 20,
                                          backgroundColor: Colors.white,
                                          child: CircleAvatar(
                                            radius: 18,
                                            backgroundImage: NetworkImage(
                                                "https://sma1contoh.sekolahkita.net/assets/images/avatar-akun.png"),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              1.75,
                                          margin: const EdgeInsets.only(
                                              top: 10, right: 30),
                                          padding: const EdgeInsets.all(15),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.only(
                                              topLeft: Radius.circular(25),
                                              topRight: Radius.circular(15),
                                              bottomRight: Radius.circular(15),
                                            ),
                                            color: index.isEven
                                                ? Colors.blue.withOpacity(0.1)
                                                : Colors.amber.withOpacity(0.1),
                                          ),
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Flexible(
                                                    child: Text(
                                                      snapshot.data!.data[index]
                                                          .komentarNama,
                                                      style: GoogleFonts.roboto(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 14),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            2.10,
                                                    child: Text(
                                                      snapshot.data!.data[index]
                                                          .komentarIsi,
                                                      style: GoogleFonts.roboto(
                                                          fontSize: 14),
                                                      maxLines: 5,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 5),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        const SizedBox(
                                          width: 50,
                                        ),
                                        Text(snapshot
                                            .data!.data[index].komentarTanggal),
                                      ],
                                    )
                                  ],
                                ),
                              );
                            });
                      } else {
                        return Container(
                          height: 70,
                        );
                      }
                    }),
              ],
            ),
          ),
        ));
  }
}
