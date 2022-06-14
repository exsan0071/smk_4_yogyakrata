import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import '../../controller/baselink.dart';
import '../../controller/conectyfity.dart';
import '../../materi/controller/materi.dart';
import '../../materi/models/materi.dart';
import '../../materi/models/topik.dart';
import '../../materi/provider/data_materi.dart';
import '../../materi/provider/mapel_provider.dart';
import 'detail/list_detail.dart';
import 'package:http/http.dart' as http;

class MateriViewsList extends StatefulWidget {
  const MateriViewsList({Key? key}) : super(key: key);

  @override
  _MateriViewsListState createState() => _MateriViewsListState();
}

class _MateriViewsListState extends State<MateriViewsList> {
  RefreshController onRefresC = RefreshController();
  final MateriController materiC = Get.put(MateriController());
  final GetDataMapel getDataMapel = GetDataMapel();
  final GetDataDetailMateri getDataDetailMateri = GetDataDetailMateri();
  final BaseLInkController baseLinkC = Get.put(BaseLInkController());
  var top = 0.0;
  bool isLoading = false;
  int _offset = 0;
  String topik = 'all';
  List<Materi> dataMateri = [];

  // ignore: prefer_typing_uninitialized_variables
  var selectedTopik;

  Future<void> getDataMateri(String idM, String offset, String idtopik) async {
    try {
      SharedPreferences getToken = await SharedPreferences.getInstance();
      String? auth = getToken.getString("token");
      final response = await http.get(
        Uri.parse(baseLinkC.baseUrlUrlLaucer3 +
            "/api/mapel/materi?idmapel=$idM&limit=5sortby=asc&offset=$offset&tipe=all&idtopik=$idtopik&tipe_materi=all"),
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
              dataMateri.add(Materi.fromJson(i));
            }
            isLoading = true;
          });
        }
      }
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }
  }

  Future<void> onTopik() async {
    await Future.delayed(const Duration(seconds: 2));
    dataMateri.clear();
    getDataMateri(materiC.id.toString(), 0.toString(), selectedTopik);
  }

  Future<void> onRefres() async {
    await Future.delayed(const Duration(seconds: 2));
    dataMateri.clear();
    if (mounted) {
      setState(() {
        if (selectedTopik != "all" && selectedTopik != null) {
          getDataMateri(materiC.id.toString(), 0.toString(), selectedTopik);
        } else {
          getDataMateri(materiC.id.toString(), 0.toString(), 'all');
        }
      });
    }
    onRefresC.refreshCompleted();
  }

  Future<void> onLoading() async {
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _offset = (_offset + 5);
    });
    if (selectedTopik != "all" && selectedTopik != null) {
      getDataMateri(materiC.id.toString(), _offset.toString(), selectedTopik);
    } else if (selectedTopik == "all") {
      getDataMateri(materiC.id.toString(), _offset.toString(), selectedTopik);
    } else {
      getDataMateri(materiC.id.toString(), _offset.toString(), 'all');
    }
    onRefresC.loadComplete();
  }

  @override
  void initState() {
    super.initState();
    getDataDetailMateri.getDataTopik(materiC.id.toString());
    Provider.of<ConnectivityProfider>(context, listen: false)
        .strartMonitiring();
    getDataMateri(materiC.id.toString(), 0.toString(), 'all');
    materiC.categoryListTopik = [
      Topik(id: 'all', nama: 'SEMUA MATERI'),
    ];
  }

  @override
  void dispose() {
    materiC.categoryListTopik.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    return Scaffold(
        body: SmartRefresher(
      controller: onRefresC,
      onRefresh: onRefres,
      enablePullUp: true,
      onLoading: onLoading,
      child: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            expandedHeight: 170.0,
            flexibleSpace: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                top = constraints.biggest.height;
                return FlexibleSpaceBar(
                  centerTitle: true,
                  title: AnimatedOpacity(
                    opacity: top <= 130 ? 1.0 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(
                          width: 40,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              materiC.nama.toString(),
                              style: GoogleFonts.roboto(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            ),
                            Text(
                              materiC.kelas.toString(),
                              style: GoogleFonts.roboto(
                                  color: Colors.white, fontSize: 13),
                            )
                          ],
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            margin: EdgeInsets.only(
                                top: MediaQuery.of(context).padding.top + 8,
                                right: 10),
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20)),
                            child: const Icon(Icons.search),
                          ),
                        )
                      ],
                    ),
                  ),
                  background: Stack(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('assets/icons/163.png'),
                                fit: BoxFit.cover)),
                      ),
                      Positioned(
                          top: MediaQuery.of(context).padding.top + 60,
                          left: 220,
                          right: 0,
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image:
                                        NetworkImage(materiC.img.toString()))),
                          )),
                      Positioned(
                        left: -80,
                        right: 0,
                        top: MediaQuery.of(context).padding.top + 90,
                        child: Column(
                          children: [
                            Text(
                              materiC.nama.toString(),
                              style: GoogleFonts.roboto(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            ),
                            Container(
                              width: 100,
                              height: 25,
                              margin: const EdgeInsets.only(top: 10),
                              decoration: BoxDecoration(
                                  color: Colors.amber,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Center(
                                child: Text(materiC.kelas.toString(),
                                    style: GoogleFonts.roboto(
                                        fontSize: 15,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 10),
                        margin: EdgeInsets.only(
                            left: 60,
                            right: 20,
                            top: MediaQuery.of(context).padding.top + 14),
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 7,
                                offset: const Offset(
                                    0, 3), // changes position of shadow
                              ),
                            ],
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: const [
                            Icon(
                              Icons.search,
                              color: Colors.amber,
                              size: 25,
                            ),
                            Text(
                              'Cari Judul Materi ...',
                              style:
                                  TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
          SliverToBoxAdapter(child:
              Consumer<ConnectivityProfider>(builder: (context, models, child) {
            // ceking here....
            if (models.isOnline != null) {
              return models.isOnline == true
                  ? Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.only(
                              left: 10, right: 10, top: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Topik Materi",
                                  style: GoogleFonts.roboto(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15)),
                              Container(
                                width: 150,
                                height: 35,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(20)),
                                child: DropdownButton(
                                  isExpanded: true,
                                  underline: Container(),
                                  elevation: 16,
                                  value: selectedTopik,
                                  hint: const Text(
                                    'Pilih topik',
                                    maxLines: 1,
                                  ),
                                  items: materiC.categoryListTopik
                                      .map(
                                        (list) => DropdownMenuItem(
                                          child: Text(list.nama,
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.roboto(
                                                fontSize: 10,
                                              )),
                                          value: list.id,
                                        ),
                                      )
                                      .toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      selectedTopik = value;
                                    });
                                    onTopik();
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (isLoading == false)
                          ListView.builder(
                              itemCount: 10,
                              primary: false,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return Container(
                                  padding: const EdgeInsets.all(5),
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  height: 100,
                                  width: _width,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Shimmer.fromColors(
                                          baseColor: Colors.grey[400]!,
                                          highlightColor: Colors.grey[300]!,
                                          enabled: true,
                                          child: const CircleAvatar(
                                            radius: 23,
                                            backgroundColor: Color(0xff20bfcc),
                                            child: CircleAvatar(
                                              radius: 20,
                                              backgroundColor: Colors.white,
                                              child: CircleAvatar(
                                                radius: 18,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Shimmer.fromColors(
                                        baseColor: Colors.grey[400]!,
                                        highlightColor: Colors.grey[200]!,
                                        enabled: true,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                                width: _width / 1.70,
                                                child: Container(
                                                  color: Colors.white,
                                                  width: 110,
                                                  height: 5,
                                                )),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              children: [
                                                Container(
                                                  color: Colors.white,
                                                  width: 110,
                                                  height: 5,
                                                ),
                                                const SizedBox(width: 2),
                                                Container(
                                                  color: Colors.white,
                                                  width: 110,
                                                  height: 5,
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              }),
                        if (dataMateri.isNotEmpty)
                          ListView.builder(
                            primary: false,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: const EdgeInsets.only(
                                    left: 10, right: 10, bottom: 20),
                                decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 2,
                                        blurRadius: 7,
                                        offset: const Offset(
                                            0, 3), // changes position of shadow
                                      ),
                                    ],
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10)),
                                width: _width,
                                height: 100,
                                child: Stack(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(top: 20),
                                      width: _width,
                                      height: 100,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 10),
                                            width: 50,
                                            height: 50,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                image: const DecorationImage(
                                                    image: AssetImage(
                                                        'assets/images/materi-kbm.png'))),
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                width: 200,
                                                child: Text(
                                                  dataMateri[index]
                                                      .namapelajaran,
                                                  style: GoogleFonts.roboto(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 15),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 200,
                                                child: Text(
                                                  dataMateri[index].judul,
                                                  style: GoogleFonts.roboto(
                                                      fontWeight:
                                                          FontWeight.w300,
                                                      fontSize: 12),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 200,
                                                child: Text(
                                                  DateFormat("d MMMM yyyy ",
                                                          "id_ID")
                                                      .format(DateTime.parse(
                                                          dataMateri[index]
                                                              .modified)),
                                                  style: GoogleFonts.roboto(
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.w100),
                                                ),
                                              )
                                            ],
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                materiC.judul =
                                                    dataMateri[index].judul;
                                                materiC.typeMateri =
                                                    dataMateri[index]
                                                        .materitype;
                                                materiC.guru =
                                                    dataMateri[index].namaguru;
                                                materiC.idD =
                                                    dataMateri[index].id;
                                              });
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const ListDetail()));
                                            },
                                            child: Container(
                                              margin: const EdgeInsets.only(
                                                  right: 10),
                                              padding: const EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                  color: Colors.blue,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text("Detail",
                                                      style: GoogleFonts.roboto(
                                                          color: Colors.white,
                                                          fontSize: 13)),
                                                  const Icon(
                                                    Icons.arrow_forward_ios,
                                                    size: 10,
                                                    color: Colors.white,
                                                  )
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Positioned(
                                        child: Row(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                              color: Colors.red[400],
                                              borderRadius:
                                                  const BorderRadius.only(
                                                      topRight:
                                                          Radius.circular(10),
                                                      topLeft:
                                                          Radius.circular(10),
                                                      bottomRight:
                                                          Radius.circular(10))),
                                          width: 100,
                                          height: 25,
                                          child: Center(
                                              child: dataMateri[index]
                                                          .materitype ==
                                                      ""
                                                  ? Text(
                                                      "Umum",
                                                      style: GoogleFonts.roboto(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )
                                                  : Text(
                                                      dataMateri[index]
                                                          .materitype
                                                          .replaceAll("_", " "),
                                                      style: GoogleFonts.roboto(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )),
                                        ),
                                        Container(
                                          margin:
                                              const EdgeInsets.only(left: 10),
                                          padding: const EdgeInsets.all(5),
                                          decoration: const BoxDecoration(
                                              color: Colors.amber,
                                              borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(10),
                                                  bottomRight:
                                                      Radius.circular(10))),
                                          height: 25,
                                          child: Center(
                                              child: Text(
                                            dataMateri[index].namaguru,
                                            style: GoogleFonts.roboto(
                                              color: Colors.black,
                                              fontSize: 12,
                                            ),
                                          )),
                                        ),
                                      ],
                                    ))
                                  ],
                                ),
                              );
                            },
                            itemCount: dataMateri.length,
                          )
                      ],
                    )
                  : Expanded(
                      child: Center(
                          child: Lottie.asset(
                        'assets/icons/-no-internet-connection.json',
                      )),
                    );
            }
            return ListView.builder(
                itemCount: 10,
                primary: false,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Container(
                    padding: const EdgeInsets.all(5),
                    margin: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    height: 100,
                    width: _width,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Shimmer.fromColors(
                            baseColor: Colors.grey[400]!,
                            highlightColor: Colors.grey[300]!,
                            enabled: true,
                            child: const CircleAvatar(
                              radius: 23,
                              backgroundColor: Color(0xff20bfcc),
                              child: CircleAvatar(
                                radius: 20,
                                backgroundColor: Colors.white,
                                child: CircleAvatar(
                                  radius: 18,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Shimmer.fromColors(
                          baseColor: Colors.grey[400]!,
                          highlightColor: Colors.grey[200]!,
                          enabled: true,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                  width: _width / 1.70,
                                  child: Container(
                                    color: Colors.white,
                                    width: 110,
                                    height: 5,
                                  )),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Container(
                                    color: Colors.white,
                                    width: 110,
                                    height: 5,
                                  ),
                                  const SizedBox(width: 2),
                                  Container(
                                    color: Colors.white,
                                    width: 110,
                                    height: 5,
                                  )
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                });
          }))
        ],
      ),
    ));
  }
}
