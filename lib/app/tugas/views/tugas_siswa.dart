import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../tugas/models/tugas_selesai_models.dart';
import '../../tugas/providers/tugas_providers.dart';
import '../../controller/baselink.dart';
import '../../tugas/models/tugas.dart';
import '../controller/tugas_controller.dart';
import 'detail_tugas.dart';

class TugsSiswaViews extends StatefulWidget {
  const TugsSiswaViews({Key? key}) : super(key: key);

  @override
  _TugsSiswaViewsState createState() => _TugsSiswaViewsState();
}

class _TugsSiswaViewsState extends State<TugsSiswaViews> {
  final BaseLInkController baseLinkC = Get.put(BaseLInkController());
  final TugasProvider tugasProvider = TugasProvider();
  final TugasController tugasC = Get.put(TugasController());
  bool isExpanded = true;
  bool isExpanded2 = false;
  bool isExpanded3 = false;
  final List<Tugas> _list = [];
  final List<Tugas> _search = [];
  var loading = false;

  Future<void> getListTugas(String offset) async {
    if (mounted) {
      setState(() {
        loading = false;
      });
    }
    final _baseUrl =
        baseLinkC.baseUrlUrlLaucer3 + '/api/tugas?offset=$offset&limit=20';
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
      if (response.statusCode != 200) {
      } else {
        Iterable it = jsonDecode(response.body)['data'];
        if (mounted) {
          setState(() {
            for (Map<String, dynamic> i in it) {
              _list.add(Tugas.fromJson(i));
            }
            loading = true;
          });
        }
      }
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }
  }

  TextEditingController controller = TextEditingController();
  onSearch(String text) async {
    _search.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }
    // ignore: avoid_function_literals_in_foreach_calls
    _list.forEach((f) {
      if (f.judul.contains(text) ||
          f.namaGuru.toString().contains(text) ||
          f.namaPelajaran.toString().contains(text) ||
          f.kategoriSoal.toString().contains(text)) {
        _search.add(f);
      }
    });
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getListTugas('0');
  }

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Tugas'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 50,
              margin: const EdgeInsets.only(left: 10, right: 10, top: 20),
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 0.1,
                      blurRadius: 7,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                  color: const Color.fromARGB(255, 24, 144, 155),
                  borderRadius: BorderRadius.circular(30)),
              child: ListTile(
                leading: const Icon(
                  Icons.search,
                  size: 20,
                  color: Colors.white,
                ),
                title: TextField(
                  controller: controller,
                  onChanged: onSearch,
                  style: GoogleFonts.roboto(color: Colors.white),
                  decoration: InputDecoration(
                      hintStyle: GoogleFonts.roboto(color: Colors.white),
                      hintText: "Cari Judul Tugas..",
                      border: InputBorder.none),
                ),
                trailing: IconButton(
                  onPressed: () {
                    controller.clear();
                    onSearch('');
                  },
                  icon: const Icon(
                    Icons.cancel,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
            ),
            loading == false
                ? Center(
                    child: Lottie.asset(
                      'assets/images/98586-loading-oneplace.json',
                      width: 200,
                      height: 200,
                      fit: BoxFit.fill,
                    ),
                  )
                : SizedBox(
                    child: _search.isNotEmpty || controller.text.isNotEmpty
                        ? Card(
                            margin: const EdgeInsets.all(10),
                            color: Colors.white,
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              child: ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return Container(
                                      padding: const EdgeInsets.all(13),
                                      margin: const EdgeInsets.only(
                                          top: 5, left: 5, right: 5),
                                      width: _width,
                                      height: 172,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.grey,
                                            width:
                                                0.75, //                   <--- border width here
                                          ),
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Flexible(
                                                child: Text(
                                                  _search[index].judul,
                                                  style: GoogleFonts.inter(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                              Container(
                                                padding:
                                                    const EdgeInsets.all(5),
                                                decoration: BoxDecoration(
                                                    color: _search[index]
                                                                .statusWaktuMengerjakan ==
                                                            'active'
                                                        ? Colors.green[400]
                                                        : Colors.red
                                                            .withOpacity(0.70),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20)),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    if (_search[index]
                                                            .statusWaktuMengerjakan ==
                                                        'active')
                                                      const Icon(
                                                        Icons
                                                            .notifications_active_outlined,
                                                        color: Colors.white,
                                                        size: 15,
                                                      ),
                                                    if (_search[index]
                                                            .statusWaktuMengerjakan ==
                                                        'expired')
                                                      const Icon(
                                                        Icons
                                                            .warning_amber_rounded,
                                                        color: Colors.white,
                                                        size: 15,
                                                      ),
                                                    if (_search[index]
                                                            .statusWaktuMengerjakan ==
                                                        'active')
                                                      Text(
                                                        'Tugas Aktif',
                                                        style:
                                                            GoogleFonts.inter(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 10,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                      ),
                                                    if (_search[index]
                                                            .statusWaktuMengerjakan ==
                                                        'expired')
                                                      SizedBox(
                                                        child: Text(
                                                          'Kadalwarsa',
                                                          style:
                                                              GoogleFonts.inter(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 10,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                        ),
                                                      )
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  const Icon(
                                                    Icons.book_outlined,
                                                    color: Colors.black54,
                                                    size: 15,
                                                  ),
                                                  SizedBox(
                                                    width: 140,
                                                    child: Text(
                                                      _search[index]
                                                          .namaPelajaran,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: GoogleFonts.inter(
                                                          color: Colors.black87,
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                  )
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  const Icon(
                                                    Icons.person,
                                                    color: Colors.black54,
                                                    size: 15,
                                                  ),
                                                  SizedBox(
                                                    width: 90,
                                                    child: Text(
                                                      _search[index].namaGuru,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: GoogleFonts.inter(
                                                          color: Colors.black87,
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  const Icon(
                                                    Icons.timer,
                                                    color: Colors.black54,
                                                    size: 15,
                                                  ),
                                                  Text(
                                                    _search[index]
                                                        .waktuMengerjakan
                                                        .replaceAll(
                                                            "<br>", '\n'),
                                                    style: GoogleFonts.inter(
                                                        color: Colors.black87,
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                          const Divider(color: Colors.grey),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Container(
                                                width: 128,
                                                margin: const EdgeInsets.only(
                                                    top: 10),
                                                padding:
                                                    const EdgeInsets.all(3),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    color: _search[index]
                                                                .statusMengerjakan ==
                                                            'busy'
                                                        ? Colors.amber[100]
                                                        : Colors.red[100]),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    if (_search[index]
                                                            .statusMengerjakan ==
                                                        'busy')
                                                      Icon(
                                                        Icons.timeline_outlined,
                                                        color:
                                                            Colors.amber[800],
                                                        size: 15,
                                                      ),
                                                    const SizedBox(
                                                      width: 5,
                                                    ),
                                                    if (_search[index]
                                                            .statusMengerjakan ==
                                                        'not_yet')
                                                      Icon(
                                                        Icons
                                                            .warning_amber_rounded,
                                                        color: Colors.red[800],
                                                        size: 15,
                                                      ),
                                                    if (_search[index]
                                                            .statusMengerjakan ==
                                                        'busy')
                                                      Text('Sedang Mngerjakan',
                                                          style:
                                                              GoogleFonts.inter(
                                                            color: Colors
                                                                .amber[800],
                                                            fontSize: 10,
                                                          )),
                                                    if (_search[index]
                                                            .statusMengerjakan ==
                                                        'not_yet')
                                                      Text('Belum Mngerjakan',
                                                          style:
                                                              GoogleFonts.inter(
                                                            color:
                                                                Colors.red[800],
                                                            fontSize: 10,
                                                          )),
                                                  ],
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    tugasC.id =
                                                        _search[index].idTugas;
                                                  });
                                                  Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              const DetailTugas()));
                                                  // _launchURL(_search[index].idTugas);
                                                },
                                                child: Container(
                                                  margin: const EdgeInsets.only(
                                                      top: 10),
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          8, 6, 6, 6),
                                                  decoration: BoxDecoration(
                                                      color: const Color(
                                                          0xFF18909B),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text("Detail",
                                                          style:
                                                              GoogleFonts.inter(
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      12)),
                                                      const Icon(
                                                        Icons.arrow_forward_ios,
                                                        size: 9,
                                                        color: Colors.white,
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                  separatorBuilder: (context, index) {
                                    return const SizedBox(
                                      height: 10,
                                    );
                                  },
                                  itemCount: _search.length),
                            ),
                          )
                        : Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.blue.withOpacity(0.2)),
                                margin: const EdgeInsets.only(
                                    left: 10, right: 10, top: 10),
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                        width: 200,
                                        child: Text(
                                          "Lihat resume/catatan guru pada list tugas yang sudah dikerjakan",
                                          style: GoogleFonts.roboto(
                                            fontSize: 12,
                                          ),
                                        )),
                                    Image.asset(
                                      'assets/icons/about_tugas.png',
                                      height: 30,
                                      width: 30,
                                    )
                                  ],
                                ),
                              ),
                              Card(
                                margin: const EdgeInsets.all(10),
                                color: Colors.white,
                                child: Column(
                                  children: [
                                    if (isExpanded != true)
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        width: _width,
                                        height: 40,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text('Tugas Aktif',
                                                style: GoogleFonts.roboto(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  isExpanded = true;
                                                });
                                              },
                                              child: const Icon(Icons
                                                  .keyboard_arrow_down_sharp),
                                            ),
                                          ],
                                        ),
                                      ),
                                    if (isExpanded != false)
                                      Column(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(10),
                                            width: _width,
                                            height: 40,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text('Tugas Aktif',
                                                    style: GoogleFonts.roboto(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      isExpanded = false;
                                                    });
                                                  },
                                                  child: const Icon(Icons
                                                      .keyboard_arrow_up_sharp),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.all(10),
                                            child: ListView.separated(
                                                shrinkWrap: true,
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                itemBuilder: (context, index) {
                                                  return Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            13),
                                                    margin:
                                                        const EdgeInsets.only(
                                                            top: 5,
                                                            left: 5,
                                                            right: 5),
                                                    width: _width,
                                                    height: 172,
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                          color: Colors.grey,
                                                          width:
                                                              0.75, //                   <--- border width here
                                                        ),
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10)),
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          children: [
                                                            Flexible(
                                                              child: Text(
                                                                _list[index]
                                                                    .judul,
                                                                style: GoogleFonts.inter(
                                                                    fontSize:
                                                                        12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600),
                                                              ),
                                                            ),
                                                            Container(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(5),
                                                              decoration: BoxDecoration(
                                                                  color: _list[index]
                                                                              .statusWaktuMengerjakan ==
                                                                          'active'
                                                                      ? Colors.green[
                                                                          400]
                                                                      : Colors
                                                                          .red
                                                                          .withOpacity(
                                                                              0.70),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              20)),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  if (_list[index]
                                                                          .statusWaktuMengerjakan ==
                                                                      'active')
                                                                    const Icon(
                                                                      Icons
                                                                          .notifications_active_outlined,
                                                                      color: Colors
                                                                          .white,
                                                                      size: 15,
                                                                    ),
                                                                  if (_list[index]
                                                                          .statusWaktuMengerjakan ==
                                                                      'expired')
                                                                    const Icon(
                                                                      Icons
                                                                          .warning_amber_rounded,
                                                                      color: Colors
                                                                          .white,
                                                                      size: 15,
                                                                    ),
                                                                  if (_list[index]
                                                                          .statusWaktuMengerjakan ==
                                                                      'active')
                                                                    Text(
                                                                      'Tugas Aktif',
                                                                      style: GoogleFonts.inter(
                                                                          color: Colors
                                                                              .white,
                                                                          fontSize:
                                                                              10,
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    ),
                                                                  if (_list[index]
                                                                          .statusWaktuMengerjakan ==
                                                                      'expired')
                                                                    SizedBox(
                                                                      child:
                                                                          Text(
                                                                        'Kadalwarsa',
                                                                        style: GoogleFonts.inter(
                                                                            color: Colors
                                                                                .white,
                                                                            fontSize:
                                                                                10,
                                                                            fontWeight:
                                                                                FontWeight.bold),
                                                                      ),
                                                                    )
                                                                ],
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
                                                        Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              children: [
                                                                const Icon(
                                                                  Icons
                                                                      .book_outlined,
                                                                  color: Colors
                                                                      .black54,
                                                                  size: 15,
                                                                ),
                                                                SizedBox(
                                                                  width: 140,
                                                                  child: Text(
                                                                    _list[index]
                                                                        .namaPelajaran,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    style: GoogleFonts.inter(
                                                                        color: Colors
                                                                            .black87,
                                                                        fontSize:
                                                                            10,
                                                                        fontWeight:
                                                                            FontWeight.w500),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              children: [
                                                                const Icon(
                                                                  Icons.person,
                                                                  color: Colors
                                                                      .black54,
                                                                  size: 15,
                                                                ),
                                                                SizedBox(
                                                                  width: 90,
                                                                  child: Text(
                                                                    _list[index]
                                                                        .namaGuru,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    style: GoogleFonts.inter(
                                                                        color: Colors
                                                                            .black87,
                                                                        fontSize:
                                                                            10,
                                                                        fontWeight:
                                                                            FontWeight.w500),
                                                                  ),
                                                                )
                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                          height: 5,
                                                        ),
                                                        Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              children: [
                                                                const Icon(
                                                                  Icons.timer,
                                                                  color: Colors
                                                                      .black54,
                                                                  size: 15,
                                                                ),
                                                                Text(
                                                                  _list[index]
                                                                      .waktuMengerjakan
                                                                      .replaceAll(
                                                                          "<br>",
                                                                          '\n'),
                                                                  style: GoogleFonts.inter(
                                                                      color: Colors
                                                                          .black87,
                                                                      fontSize:
                                                                          10,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500),
                                                                )
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                        const Divider(
                                                            color: Colors.grey),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          children: [
                                                            Container(
                                                              width: 128,
                                                              margin:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      top: 10),
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(3),
                                                              decoration: BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                          20),
                                                                  color: _list[index]
                                                                              .statusMengerjakan ==
                                                                          'busy'
                                                                      ? Colors.amber[
                                                                          100]
                                                                      : Colors.red[
                                                                          100]),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  if (_list[index]
                                                                          .statusMengerjakan ==
                                                                      'busy')
                                                                    Icon(
                                                                      Icons
                                                                          .timeline_outlined,
                                                                      color: Colors
                                                                              .amber[
                                                                          800],
                                                                      size: 15,
                                                                    ),
                                                                  const SizedBox(
                                                                    width: 5,
                                                                  ),
                                                                  if (_list[index]
                                                                          .statusMengerjakan ==
                                                                      'not_yet')
                                                                    Icon(
                                                                      Icons
                                                                          .warning_amber_rounded,
                                                                      color: Colors
                                                                              .red[
                                                                          800],
                                                                      size: 15,
                                                                    ),
                                                                  if (_list[index]
                                                                          .statusMengerjakan ==
                                                                      'busy')
                                                                    Text(
                                                                        'Sedang Mngerjakan',
                                                                        style: GoogleFonts
                                                                            .inter(
                                                                          color:
                                                                              Colors.amber[800],
                                                                          fontSize:
                                                                              10,
                                                                        )),
                                                                  if (_list[index]
                                                                          .statusMengerjakan ==
                                                                      'not_yet')
                                                                    Text(
                                                                        'Belum Mngerjakan',
                                                                        style: GoogleFonts
                                                                            .inter(
                                                                          color:
                                                                              Colors.red[800],
                                                                          fontSize:
                                                                              10,
                                                                        )),
                                                                ],
                                                              ),
                                                            ),
                                                            GestureDetector(
                                                              onTap: () {
                                                                setState(() {
                                                                  tugasC
                                                                      .id = _list[
                                                                          index]
                                                                      .idTugas;
                                                                });
                                                                Navigator.of(
                                                                        context)
                                                                    .push(MaterialPageRoute(
                                                                        builder:
                                                                            (context) =>
                                                                                const DetailTugas()));
                                                                // _launchURL(_list[
                                                                //         index]
                                                                //     .idTugas);
                                                              },
                                                              child: Container(
                                                                margin:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        top:
                                                                            10),
                                                                padding:
                                                                    const EdgeInsets
                                                                            .fromLTRB(
                                                                        8,
                                                                        6,
                                                                        6,
                                                                        6),
                                                                decoration: BoxDecoration(
                                                                    color: const Color(
                                                                        0xFF18909B),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10)),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Text(
                                                                        "Detail",
                                                                        style: GoogleFonts.inter(
                                                                            color:
                                                                                Colors.white,
                                                                            fontWeight: FontWeight.bold,
                                                                            fontSize: 12)),
                                                                    const Icon(
                                                                      Icons
                                                                          .arrow_forward_ios,
                                                                      size: 9,
                                                                      color: Colors
                                                                          .white,
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  );
                                                },
                                                separatorBuilder:
                                                    (context, index) {
                                                  return const SizedBox(
                                                    height: 10,
                                                  );
                                                },
                                                itemCount: _list.length),
                                          ),
                                        ],
                                      ),
                                  ],
                                ),
                              ),
                              Card(
                                margin: const EdgeInsets.all(10),
                                color: Colors.white,
                                child: Column(
                                  children: [
                                    if (isExpanded2 != true)
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        width: _width,
                                        height: 40,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text('Riwayat Tugas',
                                                style: GoogleFonts.roboto(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  isExpanded2 = true;
                                                });
                                              },
                                              child: const Icon(Icons
                                                  .keyboard_arrow_down_sharp),
                                            ),
                                          ],
                                        ),
                                      ),
                                    if (isExpanded2 != false)
                                      Column(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(10),
                                            width: _width,
                                            height: 40,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text('Riwayat Tugas',
                                                    style: GoogleFonts.roboto(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      isExpanded2 = false;
                                                    });
                                                  },
                                                  child: const Icon(Icons
                                                      .keyboard_arrow_up_sharp),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.all(10),
                                            child: ListView.separated(
                                                shrinkWrap: true,
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                itemBuilder: (context, index) {
                                                  return Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            13),
                                                    margin:
                                                        const EdgeInsets.only(
                                                            top: 5,
                                                            left: 5,
                                                            right: 5),
                                                    width: _width,
                                                    height: 172,
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                          color: Colors.grey,
                                                          width:
                                                              0.75, //                   <--- border width here
                                                        ),
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10)),
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          children: [
                                                            Flexible(
                                                              child: Text(
                                                                _list[index]
                                                                    .judul,
                                                                style: GoogleFonts.inter(
                                                                    fontSize:
                                                                        12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600),
                                                              ),
                                                            ),
                                                            Container(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(5),
                                                              decoration: BoxDecoration(
                                                                  color: _list[index]
                                                                              .statusWaktuMengerjakan ==
                                                                          'active'
                                                                      ? Colors.green[
                                                                          400]
                                                                      : Colors
                                                                          .red
                                                                          .withOpacity(
                                                                              0.70),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              20)),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  if (_list[index]
                                                                          .statusWaktuMengerjakan ==
                                                                      'active')
                                                                    const Icon(
                                                                      Icons
                                                                          .notifications_active_outlined,
                                                                      color: Colors
                                                                          .white,
                                                                      size: 15,
                                                                    ),
                                                                  if (_list[index]
                                                                          .statusWaktuMengerjakan ==
                                                                      'expired')
                                                                    const Icon(
                                                                      Icons
                                                                          .warning_amber_rounded,
                                                                      color: Colors
                                                                          .white,
                                                                      size: 15,
                                                                    ),
                                                                  if (_list[index]
                                                                          .statusWaktuMengerjakan ==
                                                                      'active')
                                                                    Text(
                                                                      'Tugas Aktif',
                                                                      style: GoogleFonts.inter(
                                                                          color: Colors
                                                                              .white,
                                                                          fontSize:
                                                                              10,
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    ),
                                                                  if (_list[index]
                                                                          .statusWaktuMengerjakan ==
                                                                      'expired')
                                                                    SizedBox(
                                                                      child:
                                                                          Text(
                                                                        'Kadalwarsa',
                                                                        style: GoogleFonts.inter(
                                                                            color: Colors
                                                                                .white,
                                                                            fontSize:
                                                                                10,
                                                                            fontWeight:
                                                                                FontWeight.bold),
                                                                      ),
                                                                    )
                                                                ],
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
                                                        Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              children: [
                                                                const Icon(
                                                                  Icons
                                                                      .book_outlined,
                                                                  color: Colors
                                                                      .black54,
                                                                  size: 15,
                                                                ),
                                                                SizedBox(
                                                                  width: 140,
                                                                  child: Text(
                                                                    _list[index]
                                                                        .namaPelajaran,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    style: GoogleFonts.inter(
                                                                        color: Colors
                                                                            .black87,
                                                                        fontSize:
                                                                            10,
                                                                        fontWeight:
                                                                            FontWeight.w500),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              children: [
                                                                const Icon(
                                                                  Icons.person,
                                                                  color: Colors
                                                                      .black54,
                                                                  size: 15,
                                                                ),
                                                                SizedBox(
                                                                  width: 90,
                                                                  child: Text(
                                                                    _list[index]
                                                                        .namaGuru,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    style: GoogleFonts.inter(
                                                                        color: Colors
                                                                            .black87,
                                                                        fontSize:
                                                                            10,
                                                                        fontWeight:
                                                                            FontWeight.w500),
                                                                  ),
                                                                )
                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                          height: 5,
                                                        ),
                                                        Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              children: [
                                                                const Icon(
                                                                  Icons.timer,
                                                                  color: Colors
                                                                      .black54,
                                                                  size: 15,
                                                                ),
                                                                Text(
                                                                  _list[index]
                                                                      .waktuMengerjakan
                                                                      .replaceAll(
                                                                          "<br>",
                                                                          '\n'),
                                                                  style: GoogleFonts.inter(
                                                                      color: Colors
                                                                          .black87,
                                                                      fontSize:
                                                                          10,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500),
                                                                )
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                        const Divider(
                                                            color: Colors.grey),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          children: [
                                                            Container(
                                                              width: 128,
                                                              margin:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      top: 10),
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(3),
                                                              decoration: BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                          20),
                                                                  color: _list[index]
                                                                              .statusMengerjakan ==
                                                                          'busy'
                                                                      ? Colors.amber[
                                                                          100]
                                                                      : Colors.red[
                                                                          100]),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  if (_list[index]
                                                                          .statusMengerjakan ==
                                                                      'busy')
                                                                    Icon(
                                                                      Icons
                                                                          .timeline_outlined,
                                                                      color: Colors
                                                                              .amber[
                                                                          800],
                                                                      size: 15,
                                                                    ),
                                                                  const SizedBox(
                                                                    width: 5,
                                                                  ),
                                                                  if (_list[index]
                                                                          .statusMengerjakan ==
                                                                      'not_yet')
                                                                    Icon(
                                                                      Icons
                                                                          .warning_amber_rounded,
                                                                      color: Colors
                                                                              .red[
                                                                          800],
                                                                      size: 15,
                                                                    ),
                                                                  if (_list[index]
                                                                          .statusMengerjakan ==
                                                                      'busy')
                                                                    Text(
                                                                        'Sedang Mngerjakan',
                                                                        style: GoogleFonts
                                                                            .inter(
                                                                          color:
                                                                              Colors.amber[800],
                                                                          fontSize:
                                                                              10,
                                                                        )),
                                                                  if (_list[index]
                                                                          .statusMengerjakan ==
                                                                      'not_yet')
                                                                    Text(
                                                                        'Belum Mngerjakan',
                                                                        style: GoogleFonts
                                                                            .inter(
                                                                          color:
                                                                              Colors.red[800],
                                                                          fontSize:
                                                                              10,
                                                                        )),
                                                                ],
                                                              ),
                                                            ),
                                                            GestureDetector(
                                                              onTap: () {
                                                                setState(() {
                                                                  tugasC
                                                                      .id = _list[
                                                                          index]
                                                                      .idTugas;
                                                                });
                                                                Navigator.of(
                                                                        context)
                                                                    .push(MaterialPageRoute(
                                                                        builder:
                                                                            (context) =>
                                                                                const DetailTugas()));
                                                              },
                                                              child: Container(
                                                                margin:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        top:
                                                                            10),
                                                                padding:
                                                                    const EdgeInsets
                                                                            .fromLTRB(
                                                                        8,
                                                                        6,
                                                                        6,
                                                                        6),
                                                                decoration: BoxDecoration(
                                                                    color: const Color(
                                                                        0xFF18909B),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10)),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Text(
                                                                        "Detail",
                                                                        style: GoogleFonts.inter(
                                                                            color:
                                                                                Colors.white,
                                                                            fontWeight: FontWeight.bold,
                                                                            fontSize: 12)),
                                                                    const Icon(
                                                                      Icons
                                                                          .arrow_forward_ios,
                                                                      size: 9,
                                                                      color: Colors
                                                                          .white,
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  );
                                                },
                                                separatorBuilder:
                                                    (context, index) {
                                                  return const SizedBox(
                                                    height: 10,
                                                  );
                                                },
                                                itemCount: _list.length),
                                          ),
                                        ],
                                      ),
                                  ],
                                ),
                              ),
                              Card(
                                margin: const EdgeInsets.all(10),
                                color: Colors.white,
                                child: Column(
                                  children: [
                                    if (isExpanded3 != true)
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        width: _width,
                                        height: 40,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text('Tugas Selesai',
                                                style: GoogleFonts.roboto(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  isExpanded3 = true;
                                                });
                                              },
                                              child: const Icon(Icons
                                                  .keyboard_arrow_down_sharp),
                                            ),
                                          ],
                                        ),
                                      ),
                                    if (isExpanded3 != false)
                                      Column(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(10),
                                            width: _width,
                                            height: 40,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text('Tugas Selesai',
                                                    style: GoogleFonts.roboto(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      isExpanded3 = false;
                                                    });
                                                  },
                                                  child: const Icon(Icons
                                                      .keyboard_arrow_up_sharp),
                                                ),
                                              ],
                                            ),
                                          ),
                                          FutureBuilder<TugasSiswaSelesai?>(
                                              future: tugasProvider
                                                  .getTugasSelesai("0"),
                                              builder: (BuildContext context,
                                                  snapshot) {
                                                if (snapshot.connectionState ==
                                                    ConnectionState.waiting) {
                                                  return Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10),
                                                      child:
                                                          const CircularProgressIndicator());
                                                } else {
                                                  if (snapshot.hasData) {
                                                    return Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10),
                                                      child: ListView.separated(
                                                          primary: false,
                                                          shrinkWrap: true,
                                                          itemBuilder:
                                                              (context, index) {
                                                            return Container(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(15),
                                                              margin:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      top: 5,
                                                                      left: 5,
                                                                      right: 5),
                                                              width: _width,
                                                              height: 172,
                                                              decoration:
                                                                  BoxDecoration(
                                                                      border:
                                                                          Border
                                                                              .all(
                                                                        color: Colors
                                                                            .grey,
                                                                        width:
                                                                            0.75, //                   <--- border width here
                                                                      ),
                                                                      color: Colors
                                                                          .white,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10)),
                                                              child: Column(
                                                                children: [
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .max,
                                                                    children: [
                                                                      CircleAvatar(
                                                                          radius:
                                                                              23,
                                                                          backgroundColor: Colors
                                                                              .white,
                                                                          child:
                                                                              CircleAvatar(
                                                                            radius:
                                                                                20,
                                                                            backgroundImage: snapshot.data!.data[index].avatarGuru.toString() == "null"
                                                                                ? const NetworkImage('https://sma1contoh.sekolahkita.net/assets/images/guru/thumb/1638259581-wanita-min_thumb.png')
                                                                                : NetworkImage(snapshot.data!.data[index].avatarGuru.toString()),
                                                                          )),
                                                                      const SizedBox(
                                                                        width:
                                                                            5,
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            200,
                                                                        child:
                                                                            Text(
                                                                          snapshot
                                                                              .data!
                                                                              .data[index]
                                                                              .judul
                                                                              .toUpperCase(),
                                                                          style: GoogleFonts.inter(
                                                                              fontSize: 12,
                                                                              fontWeight: FontWeight.w600),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  const SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                  Row(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .max,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.start,
                                                                        mainAxisSize:
                                                                            MainAxisSize.max,
                                                                        children: [
                                                                          const Icon(
                                                                            Icons.book_outlined,
                                                                            color:
                                                                                Colors.black54,
                                                                            size:
                                                                                15,
                                                                          ),
                                                                          SizedBox(
                                                                            width:
                                                                                150,
                                                                            child:
                                                                                Text(
                                                                              snapshot.data!.data[index].namaPelajaran,
                                                                              overflow: TextOverflow.ellipsis,
                                                                              style: GoogleFonts.inter(color: Colors.black87, fontSize: 10, fontWeight: FontWeight.w500),
                                                                            ),
                                                                          )
                                                                        ],
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.start,
                                                                        mainAxisSize:
                                                                            MainAxisSize.max,
                                                                        children: [
                                                                          const Icon(
                                                                            Icons.person,
                                                                            color:
                                                                                Colors.black54,
                                                                            size:
                                                                                15,
                                                                          ),
                                                                          SizedBox(
                                                                            width:
                                                                                90,
                                                                            child:
                                                                                Text(
                                                                              snapshot.data!.data[index].namaGuru,
                                                                              overflow: TextOverflow.ellipsis,
                                                                              style: GoogleFonts.inter(color: Colors.black87, fontSize: 10, fontWeight: FontWeight.w500),
                                                                            ),
                                                                          )
                                                                        ],
                                                                      )
                                                                    ],
                                                                  ),
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .max,
                                                                    children: [
                                                                      const Icon(
                                                                        Icons
                                                                            .cases_outlined,
                                                                        color: Colors
                                                                            .amber,
                                                                        size:
                                                                            15,
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            80,
                                                                        child:
                                                                            Text(
                                                                          "Tugas",
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                          style: GoogleFonts.inter(
                                                                              color: Colors.amber,
                                                                              fontSize: 10,
                                                                              fontWeight: FontWeight.w500),
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ),
                                                                  const Divider(
                                                                      color: Colors
                                                                          .grey),
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .max,
                                                                    children: [
                                                                      Container(
                                                                        width:
                                                                            128,
                                                                        margin: const EdgeInsets.only(
                                                                            top:
                                                                                10),
                                                                        padding:
                                                                            const EdgeInsets.all(3),
                                                                        decoration: BoxDecoration(
                                                                            borderRadius:
                                                                                BorderRadius.circular(20),
                                                                            color: Colors.green[100]),
                                                                        child: Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
                                                                            children: [
                                                                              Icon(
                                                                                Icons.check_circle_outline_outlined,
                                                                                color: Colors.green[800],
                                                                                size: 15,
                                                                              ),
                                                                              const SizedBox(
                                                                                width: 5,
                                                                              ),
                                                                              Text('Tugas Selesai',
                                                                                  style: GoogleFonts.inter(
                                                                                    color: Colors.green[800],
                                                                                    fontSize: 10,
                                                                                  )),
                                                                            ]),
                                                                      ),
                                                                      GestureDetector(
                                                                        onTap:
                                                                            () {},
                                                                        child:
                                                                            Container(
                                                                          margin:
                                                                              const EdgeInsets.only(top: 10),
                                                                          padding: const EdgeInsets.fromLTRB(
                                                                              8,
                                                                              6,
                                                                              6,
                                                                              6),
                                                                          decoration: BoxDecoration(
                                                                              color: Colors.blue,
                                                                              borderRadius: BorderRadius.circular(10)),
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
                                                                            children: [
                                                                              Text("Lihat", style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                                                                              const Icon(
                                                                                Icons.arrow_forward_ios,
                                                                                size: 9,
                                                                                color: Colors.white,
                                                                              )
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  )
                                                                ],
                                                              ),
                                                            );
                                                          },
                                                          separatorBuilder:
                                                              (context, index) {
                                                            return const SizedBox(
                                                              height: 10,
                                                            );
                                                          },
                                                          itemCount: snapshot
                                                              .data!
                                                              .data
                                                              .length),
                                                    );
                                                  } else {
                                                    return Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(10),
                                                        child: const Center(
                                                          child: Text(
                                                              "Belum Ada Tugas Yang Selesai"),
                                                        ));
                                                  }
                                                }
                                              }),
                                        ],
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ))
          ],
        ),
      ),
    );
  }
}


// import 'dart:convert';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:pull_to_refresh/pull_to_refresh.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:sma_2_contoh/app/controller/baselink.dart';
// import 'package:sma_2_contoh/app/tugas/models/tugas.dart';
// import 'package:sma_2_contoh/app/tugas/models/tugas_selesai_models.dart';
// import 'package:sma_2_contoh/app/tugas/providers/tugas_providers.dart';

// import 'package:http/http.dart' as http;

// class TugsSiswaViews extends StatefulWidget {
//   const TugsSiswaViews({Key? key}) : super(key: key);

//   @override
//   _TugsSiswaViewsState createState() => _TugsSiswaViewsState();
// }

// class _TugsSiswaViewsState extends State<TugsSiswaViews>
//     with TickerProviderStateMixin {
//   List<Tugas> dataListTugas = [];
//   bool isLoading = false;
//   late TabController _tabController;
//   late ScrollController _scrollController;
//   final TugasProvider tugasProvider = TugasProvider();
//   final BaseLInkController baseLinkC = Get.put(BaseLInkController());
//   RefreshController onRefresC = RefreshController();
//   var top = 0.0;
//   var _offset = 0;

//   Future<void> getListTugas(String offset) async {
//     if (mounted) {
//       setState(() {
//         isLoading = false;
//       });
//     }
//     final _baseUrl = baseLinkC.baseUrlTugas + '?offset=$offset&limit=4';
//     try {
//       SharedPreferences getToken = await SharedPreferences.getInstance();
//       String? auth = getToken.getString("token");
//       final response = await http.get(
//         Uri.parse(_baseUrl),
//         headers: {
//           'Content-Type': 'application/json',
//           'Accept': 'application/json',
//           'Authorization': '$auth',
//         },
//       );
//       if (response.statusCode != 200) {
//       } else {
//         Iterable it = jsonDecode(response.body)['data'];
//         if (mounted) {
//           setState(() {
//             for (Map<String, dynamic> i in it) {
//               dataListTugas.add(Tugas.fromJson(i));
//             }
//             isLoading = true;
//           });
//         }
//       }
//     } catch (e) {
//       print(e.toString());
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     getListTugas('0');
//     _tabController = TabController(vsync: this, length: 3);
//     _scrollController = ScrollController();
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }

//   Future<void> onRefres() async {
//     await Future.delayed(const Duration(seconds: 2));
//     dataListTugas.clear();
//     if (mounted) {
//       setState(() {
//         getListTugas('0');
//         _offset = 0;
//       });
//     }
//     onRefresC.refreshCompleted();
//   }

//   Future<void> onLoading() async {
//     await Future.delayed(const Duration(seconds: 2));
//     setState(() {
//       _offset = _offset + 5;
//     });
//     getListTugas(_offset.toString());
//     onRefresC.loadComplete();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final _height = MediaQuery.of(context).size.height;
//     final _width = MediaQuery.of(context).size.width;
//     return Scaffold(
//         body: Scrollbar(
//       child: SmartRefresher(
//         controller: onRefresC,
//         onRefresh: onRefres,
//         enablePullUp: true,
//         onLoading: onLoading,
//         child: CustomScrollView(slivers: <Widget>[
//           SliverAppBar(
//               leading: GestureDetector(
//                 onTap: () {
//                   Navigator.pop(context);
//                 },
//                 child: Container(
//                   margin: const EdgeInsets.all(11),
//                   decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(20)),
//                   child: const Icon(
//                     Icons.arrow_back,
//                     color: Colors.black,
//                   ),
//                 ),
//               ),
//               pinned: true,
//               expandedHeight: 200.0,
//               flexibleSpace: LayoutBuilder(
//                   builder: (BuildContext context, BoxConstraints constraints) {
//                 top = constraints.biggest.height;
//                 return FlexibleSpaceBar(
//                     centerTitle: true,
//                     title: AnimatedOpacity(
//                         opacity: top <= 130 ? 1.0 : 0,
//                         duration: const Duration(milliseconds: 200),
//                         child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               const SizedBox(
//                                 width: 40,
//                               ),
//                               Container(
//                                 padding: EdgeInsets.only(
//                                     top: MediaQuery.of(context).padding.top +
//                                         20),
//                                 child: Text(
//                                   "Tugas,PR,Remidial",
//                                   style: GoogleFonts.roboto(
//                                       fontSize: 16,
//                                       color: Colors.white,
//                                       fontWeight: FontWeight.bold),
//                                 ),
//                               ),
//                               GestureDetector(
//                                 onTap: () {},
//                                 child: Container(
//                                   margin: EdgeInsets.only(
//                                       top: MediaQuery.of(context).padding.top +
//                                           8,
//                                       right: 10),
//                                   padding: const EdgeInsets.all(5),
//                                   decoration: BoxDecoration(
//                                       color: Colors.white,
//                                       borderRadius: BorderRadius.circular(20)),
//                                   child: const Icon(Icons.search),
//                                 ),
//                               )
//                             ])),
//                     background: Stack(children: [
//                       Container(
//                         padding: const EdgeInsets.all(20),
//                         decoration: const BoxDecoration(
//                             image: DecorationImage(
//                                 fit: BoxFit.fill,
//                                 image: AssetImage(
//                                     'assets/images/elearning-online.png'))),
//                       ),
//                       Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.only(
//                                 left: 20, right: 30, top: 10),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               mainAxisSize: MainAxisSize.max,
//                               children: [
//                                 SizedBox(
//                                   width: 200,
//                                   child: Text(
//                                     "Dashboard Tugas",
//                                     style: GoogleFonts.roboto(
//                                       color: Colors.blue,
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 16,
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           Container(
//                             padding: const EdgeInsets.only(left: 20, right: 30),
//                             height: 50,
//                             child: TabBarView(
//                                 controller: _tabController,
//                                 children: [
//                                   Text(
//                                     "List tugas dan PR yang belum \nkamu kerjakan",
//                                     style: GoogleFonts.roboto(
//                                       color: Colors.amber,
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 12,
//                                     ),
//                                   ),
//                                   Text(
//                                     "List semua tugas dan PR Siswa",
//                                     style: GoogleFonts.roboto(
//                                       color: Colors.amber,
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 12,
//                                     ),
//                                   ),
//                                   Text(
//                                     "Pekerjaan yang sudah kamu selesaikan \nada disini !",
//                                     style: GoogleFonts.roboto(
//                                       color: Colors.amber,
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 12,
//                                     ),
//                                   )
//                                 ]),
//                           ),
//                           GestureDetector(
//                             onTap: () {
//                               // Navigator.of(context).push(
//                               //     MaterialPageRoute(builder: (context) => const StatusPage()));
//                             },
//                             child: Container(
//                               padding: const EdgeInsets.symmetric(
//                                   vertical: 7, horizontal: 15),
//                               margin: const EdgeInsets.only(
//                                 left: 10,
//                                 right: 10,
//                               ),
//                               decoration: BoxDecoration(
//                                   boxShadow: [
//                                     BoxShadow(
//                                       color: Colors.grey.withOpacity(0.5),
//                                       spreadRadius: 5,
//                                       blurRadius: 7,
//                                       offset: const Offset(
//                                           0, 3), // changes position of shadow
//                                     ),
//                                   ],
//                                   color: Colors.amber,
//                                   borderRadius: BorderRadius.circular(30)),
//                               child: Row(
//                                 children: [
//                                   const Icon(
//                                     Icons.search,
//                                     color: Colors.white,
//                                     size: 25,
//                                   ),
//                                   const SizedBox(
//                                     width: 10,
//                                   ),
//                                   Text(
//                                     'Cari Judul Tugas...',
//                                     style: GoogleFonts.roboto(
//                                         fontSize: 13, color: Colors.white),
//                                   )
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ]));
//               })),
//           SliverToBoxAdapter(
//               child: Column(
//             children: [
//               Container(
//                   decoration: const BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.only(
//                           bottomLeft: Radius.circular(20),
//                           bottomRight: Radius.circular(20))),
//                   child: Align(
//                     alignment: Alignment.centerLeft,
//                     child: TabBar(
//                         labelPadding:
//                             const EdgeInsets.only(left: 20, right: 20),
//                         controller: _tabController,
//                         labelColor: Colors.blue,
//                         unselectedLabelColor: Colors.grey,
//                         isScrollable: true,
//                         labelStyle:
//                             GoogleFonts.roboto(fontWeight: FontWeight.bold),
//                         indicatorSize: TabBarIndicatorSize.label,
//                         tabs: const [
//                           Tab(text: "Tugas Aktif"),
//                           Tab(text: "Riwayat Tugas"),
//                           Tab(text: "Tugas Selasai"),
//                         ]),
//                   )),
//               SizedBox(
//                   height: 750 + _offset.toDouble() * 168,
//                   width: double.maxFinite,
//                   child: TabBarView(
//                       dragStartBehavior: DragStartBehavior.down,
//                       controller: _tabController,
//                       children: [
//                         if (dataListTugas.isEmpty)
//                           Center(
//                               child: Container(
//                                   padding: const EdgeInsets.all(20),
//                                   child: Text(
//                                     "Belum Ada Tugas Hari ini",
//                                     style: GoogleFonts.roboto(),
//                                   ))),
//                         if (dataListTugas.isNotEmpty)
//                           Card(
//                             margin: const EdgeInsets.all(20),
//                             color: Colors.white,
//                             child: Container(
//                               padding: const EdgeInsets.all(10),
//                               child: ListView.separated(
//                                   physics: const NeverScrollableScrollPhysics(),
//                                   itemBuilder: (context, index) {
//                                     return Container(
//                                       padding: const EdgeInsets.all(13),
//                                       margin: const EdgeInsets.only(
//                                           top: 5, left: 5, right: 5),
//                                       width: _width,
//                                        height: 172,
//                                       decoration: BoxDecoration(
//                                          border: Border.all(
//                                             color: Colors.grey,
//                                             width:
//                                                 0.75, //                   <--- border width here
//                                           ),
//                                           color: Colors.white,
//                                           borderRadius:
//                                               BorderRadius.circular(10)),
//                                       child: Column(
//                                         children: [
//                                           Row(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.spaceBetween,
//                                             mainAxisSize: MainAxisSize.max,
//                                             children: [
//                                               Flexible(
//                                                 child: Text(
//                                                   dataListTugas[index].judul,
//                                                   style: GoogleFonts.inter(
//                                                       fontSize: 12,
//                                                       fontWeight:
//                                                           FontWeight.w600),
//                                                 ),
//                                               ),
//                                               Container(
//                                                 padding: const EdgeInsets.all(5),
//                                                 decoration: BoxDecoration(
//                                                     color: dataListTugas[index]
//                                                                 .statusWaktuMengerjakan ==
//                                                             'active'
//                                                         ? Colors.green[400]
//                                                         : Colors.red
//                                                             .withOpacity(0.70),
//                                                     borderRadius:
//                                                         BorderRadius.circular(
//                                                             20)),
//                                                 child: Row(
//                                                   mainAxisAlignment:
//                                                       MainAxisAlignment
//                                                           .spaceBetween,
//                                                   children: [
//                                                     if (dataListTugas[index]
//                                                             .statusWaktuMengerjakan ==
//                                                         'active')
//                                                       const Icon(
//                                                         Icons
//                                                             .notifications_active_outlined,
//                                                         color: Colors.white,
//                                                         size: 15,
//                                                       ),
//                                                     if (dataListTugas[index]
//                                                             .statusWaktuMengerjakan ==
//                                                         'expired')
//                                                       const Icon(
//                                                         Icons
//                                                             .warning_amber_rounded,
//                                                         color: Colors.white,
//                                                         size: 15,
//                                                       ),
//                                                     if (dataListTugas[index]
//                                                             .statusWaktuMengerjakan ==
//                                                         'active')
//                                                       Text(
//                                                         'Tugas Aktif',
//                                                         style: GoogleFonts.inter(
//                                                             color: Colors.white,
//                                                             fontSize: 10,
//                                                             fontWeight:
//                                                                 FontWeight.bold),
//                                                       ),
//                                                     if (dataListTugas[index]
//                                                             .statusWaktuMengerjakan ==
//                                                         'expired')
//                                                       SizedBox(
//                                                         child: Text(
//                                                           'Kadalwarsa',
//                                                           style:
//                                                               GoogleFonts.inter(
//                                                                   color: Colors
//                                                                       .white,
//                                                                   fontSize: 10,
//                                                                   fontWeight:
//                                                                       FontWeight
//                                                                           .bold),
//                                                         ),
//                                                       )
//                                                   ],
//                                                 ),
//                                               )
//                                             ],
//                                           ),
//                                           const SizedBox(
//                                             height: 10,
//                                           ),
//                                           Row(
//                                             mainAxisSize: MainAxisSize.max,
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.spaceBetween,
//                                             children: [
//                                               Row(
//                                                 mainAxisAlignment:
//                                                     MainAxisAlignment.start,
//                                                 mainAxisSize: MainAxisSize.max,
//                                                 children: [
//                                                   const Icon(
//                                                     Icons.book_outlined,
//                                                     color: Colors.black54,
//                                                     size: 15,
//                                                   ),
//                                                   Text(
//                                                     dataListTugas[index]
//                                                         .namaPelajaran,
//                                                     style: GoogleFonts.inter(
//                                                         color: Colors.black87,
//                                                         fontSize: 10,
//                                                         fontWeight:
//                                                             FontWeight.w500),
//                                                   )
//                                                 ],
//                                               ),
//                                               Row(
//                                                 mainAxisAlignment:
//                                                     MainAxisAlignment.start,
//                                                 mainAxisSize: MainAxisSize.max,
//                                                 children: [
//                                                   const Icon(
//                                                     Icons.person,
//                                                     color: Colors.black54,
//                                                     size: 15,
//                                                   ),
//                                                   SizedBox(
//                                                     width: 80,
//                                                     child: Text(
//                                                       dataListTugas[index]
//                                                           .namaGuru,
//                                                       overflow:
//                                                           TextOverflow.ellipsis,
//                                                       style: GoogleFonts.inter(
//                                                           color: Colors.black87,
//                                                           fontSize: 10,
//                                                           fontWeight:
//                                                               FontWeight.w500),
//                                                     ),
//                                                   )
//                                                 ],
//                                               )
//                                             ],
//                                           ),
//                                           const SizedBox(
//                                             height: 5,
//                                           ),
//                                           Row(
//                                             mainAxisSize: MainAxisSize.max,
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.spaceBetween,
//                                             children: [
//                                               Row(
//                                                 mainAxisAlignment:
//                                                     MainAxisAlignment.start,
//                                                 mainAxisSize: MainAxisSize.max,
//                                                 children: [
//                                                   const Icon(
//                                                     Icons.timer,
//                                                     color: Colors.black54,
//                                                     size: 15,
//                                                   ),
//                                                   Text(
//                                                     dataListTugas[index]
//                                                         .waktuMengerjakan
//                                                         .replaceAll("<br>", '\n'),
//                                                     style: GoogleFonts.inter(
//                                                         color: Colors.black87,
//                                                         fontSize: 10,
//                                                         fontWeight:
//                                                             FontWeight.w500),
//                                                   )
//                                                 ],
//                                               ),
//                                             ],
//                                           ),
//                                              const Divider(color: Colors.grey),
//                                           Row(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.spaceBetween,
//                                             mainAxisSize: MainAxisSize.max,
//                                             children: [
//                                               Container(
//                                                 width: 128,
//                                                 margin: const EdgeInsets.only(
//                                                     top: 10),
//                                                 padding: const EdgeInsets.all(3),
//                                                 decoration: BoxDecoration(
//                                                     borderRadius:
//                                                         BorderRadius.circular(20),
//                                                     color: dataListTugas[index]
//                                                                 .statusMengerjakan ==
//                                                             'busy'
//                                                         ? Colors.amber[100]
//                                                         : Colors.red[100]),
//                                                 child: Row(
//                                                   mainAxisAlignment:
//                                                       MainAxisAlignment.center,
//                                                   children: [
//                                                     if (dataListTugas[index]
//                                                             .statusMengerjakan ==
//                                                         'busy')
//                                                       Icon(
//                                                         Icons.timeline_outlined,
//                                                         color: Colors.amber[800],
//                                                         size: 15,
//                                                       ),
//                                                     const SizedBox(
//                                                       width: 5,
//                                                     ),
//                                                     if (dataListTugas[index]
//                                                             .statusMengerjakan ==
//                                                         'not_yet')
//                                                       Icon(
//                                                         Icons
//                                                             .warning_amber_rounded,
//                                                         color: Colors.red[800],
//                                                         size: 15,
//                                                       ),
//                                                     if (dataListTugas[index]
//                                                             .statusMengerjakan ==
//                                                         'busy')
//                                                       Text('Sedang Mngerjakan',
//                                                           style:
//                                                               GoogleFonts.inter(
//                                                             color:
//                                                                 Colors.amber[800],
//                                                             fontSize: 10,
//                                                           )),
//                                                     if (dataListTugas[index]
//                                                             .statusMengerjakan ==
//                                                         'not_yet')
//                                                       Text('Belum Mngerjakan',
//                                                           style:
//                                                               GoogleFonts.inter(
//                                                             color:
//                                                                 Colors.red[800],
//                                                             fontSize: 10,
//                                                           )),
//                                                   ],
//                                                 ),
//                                               ),
//                                               Container(
//                                                 margin: const EdgeInsets.only(
//                                                     top: 10),
//                                                 padding:
//                                                     const EdgeInsets.fromLTRB(
//                                                         8, 6, 6, 6),
//                                                 decoration: BoxDecoration(
//                                                     color: Colors.blue,
//                                                     borderRadius:
//                                                         BorderRadius.circular(
//                                                             10)),
//                                                 child: Row(
//                                                   mainAxisAlignment:
//                                                       MainAxisAlignment.center,
//                                                   children: [
//                                                     Text("Detail",
//                                                         style: GoogleFonts.inter(
//                                                             color: Colors.white,
//                                                             fontWeight:
//                                                                 FontWeight.bold,
//                                                             fontSize: 12)),
//                                                     const Icon(
//                                                       Icons.arrow_forward_ios,
//                                                       size: 9,
//                                                       color: Colors.white,
//                                                     )
//                                                   ],
//                                                 ),
//                                               ),
//                                             ],
//                                           )
//                                         ],
//                                       ),
//                                     );
//                                   },
//                                   separatorBuilder: (context, index) {
//                                     return const SizedBox(
//                                       height: 10,
//                                     );
//                                   },
//                                   itemCount: dataListTugas.length),
//                             ),
//                           ),
//                         if (dataListTugas.isEmpty)
//                           Center(
//                               child: Container(
//                                   padding: const EdgeInsets.all(20),
//                                   child: Text("Belum Ada Tugas Hari ini",
//                                       style: GoogleFonts.roboto()))),
//                         if (dataListTugas.isNotEmpty)
//                           Card(
//                             margin: const EdgeInsets.all(20),
//                             color: Colors.white,
//                             child: Container(
//                               padding: const EdgeInsets.all(10),
//                               child: ListView.separated(
//                                   physics: const NeverScrollableScrollPhysics(),
//                                   itemBuilder: (context, index) {
//                                     return Container(
//                                       padding: const EdgeInsets.all(13),
//                                       margin: const EdgeInsets.only(
//                                           top: 5, left: 5, right: 5),
//                                       width: _width,
//                                       height: 172,
//                                       decoration: BoxDecoration(
//                                             border: Border.all(
//                                             color: Colors.grey,
//                                             width:
//                                                 0.75, //                   <--- border width here
//                                           ),
//                                           color: Colors.white,
//                                           borderRadius:
//                                               BorderRadius.circular(10)),
//                                       child: Column(
//                                         children: [
//                                           Row(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.spaceBetween,
//                                             mainAxisSize: MainAxisSize.max,
//                                             children: [
//                                               Flexible(
//                                                 child: Text(
//                                                   dataListTugas[index].judul,
//                                                   style: GoogleFonts.inter(
//                                                       fontSize: 12,
//                                                       fontWeight:
//                                                           FontWeight.w600),
//                                                 ),
//                                               ),
//                                               Container(
//                                                 padding:
//                                                     const EdgeInsets.all(5),
//                                                 decoration: BoxDecoration(
//                                                     color: dataListTugas[index]
//                                                                 .statusWaktuMengerjakan ==
//                                                             'active'
//                                                         ? Colors.green[400]
//                                                         : Colors.red
//                                                             .withOpacity(0.70),
//                                                     borderRadius:
//                                                         BorderRadius.circular(
//                                                             20)),
//                                                 child: Row(
//                                                   mainAxisAlignment:
//                                                       MainAxisAlignment
//                                                           .spaceBetween,
//                                                   children: [
//                                                     if (dataListTugas[index]
//                                                             .statusWaktuMengerjakan ==
//                                                         'active')
//                                                       const Icon(
//                                                         Icons
//                                                             .notifications_active_outlined,
//                                                         color: Colors.white,
//                                                         size: 15,
//                                                       ),
//                                                     if (dataListTugas[index]
//                                                             .statusWaktuMengerjakan ==
//                                                         'expired')
//                                                       const Icon(
//                                                         Icons
//                                                             .warning_amber_rounded,
//                                                         color: Colors.white,
//                                                         size: 15,
//                                                       ),
//                                                     if (dataListTugas[index]
//                                                             .statusWaktuMengerjakan ==
//                                                         'active')
//                                                       Text(
//                                                         'Tugas Aktif',
//                                                         style:
//                                                             GoogleFonts.inter(
//                                                                 color: Colors
//                                                                     .white,
//                                                                 fontSize: 10,
//                                                                 fontWeight:
//                                                                     FontWeight
//                                                                         .bold),
//                                                       ),
//                                                     if (dataListTugas[index]
//                                                             .statusWaktuMengerjakan ==
//                                                         'expired')
//                                                       SizedBox(
//                                                         child: Text(
//                                                           'Kadalwarsa',
//                                                           style:
//                                                               GoogleFonts.inter(
//                                                                   color: Colors
//                                                                       .white,
//                                                                   fontSize: 10,
//                                                                   fontWeight:
//                                                                       FontWeight
//                                                                           .bold),
//                                                         ),
//                                                       )
//                                                   ],
//                                                 ),
//                                               )
//                                             ],
//                                           ),
//                                           const SizedBox(
//                                             height: 10,
//                                           ),
//                                           Row(
//                                             mainAxisSize: MainAxisSize.max,
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.spaceBetween,
//                                             children: [
//                                               Row(
//                                                 mainAxisAlignment:
//                                                     MainAxisAlignment.start,
//                                                 mainAxisSize: MainAxisSize.max,
//                                                 children: [
//                                                   const Icon(
//                                                     Icons.book_outlined,
//                                                     color: Colors.black54,
//                                                     size: 15,
//                                                   ),
//                                                   Text(
//                                                     dataListTugas[index]
//                                                         .namaPelajaran,
//                                                     style: GoogleFonts.inter(
//                                                         color: Colors.black87,
//                                                         fontSize: 10,
//                                                         fontWeight:
//                                                             FontWeight.w500),
//                                                   )
//                                                 ],
//                                               ),
//                                               Row(
//                                                 mainAxisAlignment:
//                                                     MainAxisAlignment.start,
//                                                 mainAxisSize: MainAxisSize.max,
//                                                 children: [
//                                                   const Icon(
//                                                     Icons.person,
//                                                     color: Colors.black54,
//                                                     size: 15,
//                                                   ),
//                                                   SizedBox(
//                                                     width: 80,
//                                                     child: Text(
//                                                       dataListTugas[index]
//                                                           .namaGuru,
//                                                       overflow:
//                                                           TextOverflow.ellipsis,
//                                                       style: GoogleFonts.inter(
//                                                           color: Colors.black87,
//                                                           fontSize: 10,
//                                                           fontWeight:
//                                                               FontWeight.w500),
//                                                     ),
//                                                   )
//                                                 ],
//                                               )
//                                             ],
//                                           ),
//                                           const SizedBox(
//                                             height: 5,
//                                           ),
//                                           Row(
//                                             mainAxisSize: MainAxisSize.max,
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.spaceBetween,
//                                             children: [
//                                               Row(
//                                                 mainAxisAlignment:
//                                                     MainAxisAlignment.start,
//                                                 mainAxisSize: MainAxisSize.max,
//                                                 children: [
//                                                   const Icon(
//                                                     Icons.timer,
//                                                     color: Colors.black54,
//                                                     size: 15,
//                                                   ),
//                                                   Text(
//                                                     dataListTugas[index]
//                                                         .waktuMengerjakan
//                                                         .replaceAll(
//                                                             "<br>", '\n'),
//                                                     style: GoogleFonts.inter(
//                                                         color: Colors.black87,
//                                                         fontSize: 10,
//                                                         fontWeight:
//                                                             FontWeight.w500),
//                                                   )
//                                                 ],
//                                               ),
//                                             ],
//                                           ),
//                                             const Divider(color: Colors.grey),
//                                           Row(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.spaceBetween,
//                                             mainAxisSize: MainAxisSize.max,
//                                             children: [
//                                               Container(
//                                                 width: 128,
//                                                 margin: const EdgeInsets.only(
//                                                     top: 10),
//                                                 padding:
//                                                     const EdgeInsets.all(3),
//                                                 decoration: BoxDecoration(
//                                                     borderRadius:
//                                                         BorderRadius.circular(
//                                                             20),
//                                                     color: dataListTugas[index]
//                                                                 .statusMengerjakan ==
//                                                             'busy'
//                                                         ? Colors.amber[100]
//                                                         : Colors.red[100]),
//                                                 child: Row(
//                                                   mainAxisAlignment:
//                                                       MainAxisAlignment.center,
//                                                   children: [
//                                                     if (dataListTugas[index]
//                                                             .statusMengerjakan ==
//                                                         'busy')
//                                                       Icon(
//                                                         Icons.timeline_outlined,
//                                                         color:
//                                                             Colors.amber[800],
//                                                         size: 15,
//                                                       ),
//                                                     const SizedBox(
//                                                       width: 5,
//                                                     ),
//                                                     if (dataListTugas[index]
//                                                             .statusMengerjakan ==
//                                                         'not_yet')
//                                                       Icon(
//                                                         Icons
//                                                             .warning_amber_rounded,
//                                                         color: Colors.red[800],
//                                                         size: 15,
//                                                       ),
//                                                     if (dataListTugas[index]
//                                                             .statusMengerjakan ==
//                                                         'busy')
//                                                       Text('Sedang Mngerjakan',
//                                                           style:
//                                                               GoogleFonts.inter(
//                                                             color: Colors
//                                                                 .amber[800],
//                                                             fontSize: 10,
//                                                           )),
//                                                     if (dataListTugas[index]
//                                                             .statusMengerjakan ==
//                                                         'not_yet')
//                                                       Text('Belum Mngerjakan',
//                                                           style:
//                                                               GoogleFonts.inter(
//                                                             color:
//                                                                 Colors.red[800],
//                                                             fontSize: 10,
//                                                           )),
//                                                   ],
//                                                 ),
//                                               ),
//                                               Container(
//                                                 margin: const EdgeInsets.only(
//                                                     top: 10),
//                                                 padding:
//                                                     const EdgeInsets.fromLTRB(
//                                                         8, 6, 6, 6),
//                                                 decoration: BoxDecoration(
//                                                     color: Colors.blue,
//                                                     borderRadius:
//                                                         BorderRadius.circular(
//                                                             10)),
//                                                 child: Row(
//                                                   mainAxisAlignment:
//                                                       MainAxisAlignment.center,
//                                                   children: [
//                                                     Text("Detail",
//                                                         style:
//                                                             GoogleFonts.inter(
//                                                                 color: Colors
//                                                                     .white,
//                                                                 fontWeight:
//                                                                     FontWeight
//                                                                         .bold,
//                                                                 fontSize: 12)),
//                                                     const Icon(
//                                                       Icons.arrow_forward_ios,
//                                                       size: 9,
//                                                       color: Colors.white,
//                                                     )
//                                                   ],
//                                                 ),
//                                               ),
//                                             ],
//                                           )
//                                         ],
//                                       ),
//                                     );
//                                   },
//                                   separatorBuilder: (context, index) {
//                                     return const SizedBox(
//                                       height: 10,
//                                     );
//                                   },
//                                   itemCount: dataListTugas.length),
//                             ),
//                           ),
//                         FutureBuilder<TugasSiswaSelesai?>(
//                             future: tugasProvider
//                                 .getTugasSelesai(_offset.toString()),
//                             builder: (BuildContext context, snapshot) {
//                               if (snapshot.connectionState ==
//                                   ConnectionState.waiting) {
//                                 return Container(
//                                   padding: const EdgeInsets.all(10),
//                                   child: ListView.separated(
//                                       primary: false,
//                                       shrinkWrap: true,
//                                       controller: _scrollController,
//                                       itemBuilder: (context, index) {
//                                         return Container(
//                                           width: _width,
//                                           height: 200,
//                                           color: Colors.white,
//                                         );
//                                       },
//                                       separatorBuilder: (context, index) {
//                                         return const SizedBox(
//                                           height: 10,
//                                         );
//                                       },
//                                       itemCount: 5),
//                                 );
//                               } else {
//                                 if (snapshot.hasData) {
//                                   return Card(
//                                     margin: const EdgeInsets.all(20),
//                                     color: Colors.white,
//                                     child: Container(
//                                       padding: const EdgeInsets.all(10),
//                                       child: ListView.separated(
//                                           primary: false,
//                                           shrinkWrap: true,
//                                           controller: _scrollController,
//                                           itemBuilder: (context, index) {
//                                             return Container(
//                                               padding: const EdgeInsets.all(15),
//                                               margin: const EdgeInsets.only(
//                                                   top: 5, left: 5, right: 5),
//                                               width: _width,
//                                               height: 172,
//                                               decoration: BoxDecoration(
//                                                   border: Border.all(
//                                                     color: Colors.grey,
//                                                     width:
//                                                         0.75, //                   <--- border width here
//                                                   ),
//                                                   color: Colors.white,
//                                                   borderRadius:
//                                                       BorderRadius.circular(
//                                                           10)),
//                                               child: Column(
//                                                 children: [
//                                                   Row(
//                                                     mainAxisAlignment:
//                                                         MainAxisAlignment.start,
//                                                     mainAxisSize:
//                                                         MainAxisSize.max,
//                                                     children: [
//                                                       const CircleAvatar(
//                                                           radius: 23,
//                                                           backgroundColor:
//                                                               Colors.white,
//                                                           child: CircleAvatar(
//                                                             radius: 20,
//                                                             backgroundImage:
//                                                                 NetworkImage(
//                                                                     'https://sma1contoh.sekolahkita.net/assets/images/guru/thumb/1638259581-wanita-min_thumb.png'),
//                                                           )),
//                                                       const SizedBox(
//                                                         width: 5,
//                                                       ),
//                                                       SizedBox(
//                                                         width: 200,
//                                                         child: Text(
//                                                           snapshot.data!
//                                                               .data[index].judul
//                                                               .toUpperCase(),
//                                                           style:
//                                                               GoogleFonts.inter(
//                                                                   fontSize: 12,
//                                                                   fontWeight:
//                                                                       FontWeight
//                                                                           .w600),
//                                                         ),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                   const SizedBox(
//                                                     height: 10,
//                                                   ),
//                                                   Row(
//                                                     mainAxisSize:
//                                                         MainAxisSize.max,
//                                                     mainAxisAlignment:
//                                                         MainAxisAlignment
//                                                             .spaceBetween,
//                                                     children: [
//                                                       Row(
//                                                         mainAxisAlignment:
//                                                             MainAxisAlignment
//                                                                 .start,
//                                                         mainAxisSize:
//                                                             MainAxisSize.max,
//                                                         children: [
//                                                           const Icon(
//                                                             Icons.book_outlined,
//                                                             color:
//                                                                 Colors.black54,
//                                                             size: 15,
//                                                           ),
//                                                           Text(
//                                                             snapshot
//                                                                 .data!
//                                                                 .data[index]
//                                                                 .namaPelajaran,
//                                                             style: GoogleFonts.inter(
//                                                                 color: Colors
//                                                                     .black87,
//                                                                 fontSize: 10,
//                                                                 fontWeight:
//                                                                     FontWeight
//                                                                         .w500),
//                                                           )
//                                                         ],
//                                                       ),
//                                                       Row(
//                                                         mainAxisAlignment:
//                                                             MainAxisAlignment
//                                                                 .start,
//                                                         mainAxisSize:
//                                                             MainAxisSize.max,
//                                                         children: [
//                                                           const Icon(
//                                                             Icons.person,
//                                                             color:
//                                                                 Colors.black54,
//                                                             size: 15,
//                                                           ),
//                                                           SizedBox(
//                                                             width: 80,
//                                                             child: Text(
//                                                               snapshot
//                                                                   .data!
//                                                                   .data[index]
//                                                                   .namaGuru,
//                                                               overflow:
//                                                                   TextOverflow
//                                                                       .ellipsis,
//                                                               style: GoogleFonts.inter(
//                                                                   color: Colors
//                                                                       .black87,
//                                                                   fontSize: 10,
//                                                                   fontWeight:
//                                                                       FontWeight
//                                                                           .w500),
//                                                             ),
//                                                           )
//                                                         ],
//                                                       )
//                                                     ],
//                                                   ),
//                                                   Row(
//                                                     mainAxisAlignment:
//                                                         MainAxisAlignment.start,
//                                                     mainAxisSize:
//                                                         MainAxisSize.max,
//                                                     children: [
//                                                       const Icon(
//                                                         Icons.cases_outlined,
//                                                         color: Colors.amber,
//                                                         size: 15,
//                                                       ),
//                                                       SizedBox(
//                                                         width: 80,
//                                                         child: Text(
//                                                           "Tugas",
//                                                           overflow: TextOverflow
//                                                               .ellipsis,
//                                                           style:
//                                                               GoogleFonts.inter(
//                                                                   color: Colors
//                                                                       .amber,
//                                                                   fontSize: 10,
//                                                                   fontWeight:
//                                                                       FontWeight
//                                                                           .w500),
//                                                         ),
//                                                       )
//                                                     ],
//                                                   ),
//                                                   const Divider(
//                                                       color: Colors.grey),
//                                                   Row(
//                                                     mainAxisAlignment:
//                                                         MainAxisAlignment
//                                                             .spaceBetween,
//                                                     mainAxisSize:
//                                                         MainAxisSize.max,
//                                                     children: [
//                                                       Container(
//                                                         width: 128,
//                                                         margin: const EdgeInsets
//                                                             .only(top: 10),
//                                                         padding:
//                                                             const EdgeInsets
//                                                                 .all(3),
//                                                         decoration: BoxDecoration(
//                                                             borderRadius:
//                                                                 BorderRadius
//                                                                     .circular(
//                                                                         20),
//                                                             color: Colors
//                                                                 .green[100]),
//                                                         child: Row(
//                                                             mainAxisAlignment:
//                                                                 MainAxisAlignment
//                                                                     .center,
//                                                             children: [
//                                                               Icon(
//                                                                 Icons
//                                                                     .check_circle_outline_outlined,
//                                                                 color: Colors
//                                                                     .green[800],
//                                                                 size: 15,
//                                                               ),
//                                                               const SizedBox(
//                                                                 width: 5,
//                                                               ),
//                                                               Text(
//                                                                   'Tugas Selesai',
//                                                                   style:
//                                                                       GoogleFonts
//                                                                           .inter(
//                                                                     color: Colors
//                                                                             .green[
//                                                                         800],
//                                                                     fontSize:
//                                                                         10,
//                                                                   )),
//                                                             ]),
//                                                       ),
//                                                       Container(
//                                                         margin: const EdgeInsets
//                                                             .only(top: 10),
//                                                         padding:
//                                                             const EdgeInsets
//                                                                     .fromLTRB(
//                                                                 8, 6, 6, 6),
//                                                         decoration: BoxDecoration(
//                                                             color: Colors.blue,
//                                                             borderRadius:
//                                                                 BorderRadius
//                                                                     .circular(
//                                                                         10)),
//                                                         child: Row(
//                                                           mainAxisAlignment:
//                                                               MainAxisAlignment
//                                                                   .center,
//                                                           children: [
//                                                             Text("Lihat",
//                                                                 style: GoogleFonts.inter(
//                                                                     color: Colors
//                                                                         .white,
//                                                                     fontWeight:
//                                                                         FontWeight
//                                                                             .bold,
//                                                                     fontSize:
//                                                                         12)),
//                                                             const Icon(
//                                                               Icons
//                                                                   .arrow_forward_ios,
//                                                               size: 9,
//                                                               color:
//                                                                   Colors.white,
//                                                             )
//                                                           ],
//                                                         ),
//                                                       ),
//                                                     ],
//                                                   )
//                                                 ],
//                                               ),
//                                             );
//                                           },
//                                           separatorBuilder: (context, index) {
//                                             return const SizedBox(
//                                               height: 10,
//                                             );
//                                           },
//                                           itemCount:
//                                               snapshot.data!.data.length),
//                                     ),
//                                   );
//                                 } else {
//                                   return Container(
//                                     padding: const EdgeInsets.all(10),
//                                     child: ListView.separated(
//                                         primary: false,
//                                         shrinkWrap: true,
//                                         controller: _scrollController,
//                                         itemBuilder: (context, index) {
//                                           return Container(
//                                             width: _width,
//                                             height: 200,
//                                             color: Colors.white,
//                                           );
//                                         },
//                                         separatorBuilder: (context, index) {
//                                           return const SizedBox(
//                                             height: 10,
//                                           );
//                                         },
//                                         itemCount: 5),
//                                   );
//                                 }
//                               }
//                             }),
//                       ]))
//             ],
//           )),
//         ]),
//       ),
//     ));
//   }
// }
