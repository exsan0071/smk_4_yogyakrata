import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../tugas/controller/tugas_controller.dart';
import '../../tugas/views/detail_tugas.dart';
import 'custom_shape.dart';
import 'package:shimmer/shimmer.dart';
import '../../home/widget/komentar_wiget.dart';
import '../../pesan/views/pesan_views.dart';
import '../models/komentar.dart';
import '../../home/models/models_status.dart';
import '../../home/provider/body_provider.dart';
import '../../materi/controller/materi.dart';
import '../../materi/widget/materi.dart';
import '../../tugas/models/tugas_models.dart';
import '../../tugas/providers/tugas_providers.dart';
import '../../tugas/views/tugas_siswa.dart';
import '../../materi/views/materi_views.dart';
import '../../controller/conectyfity.dart';
import '../../home/controller/body_controller.dart';
import '../../profile/models/profile.dart';
import '../../profile/provider/profile.dart';
import '../../profile/views/profile.dart';
import '../../status/views/status.dart';
import '../../controller/baselink.dart';
import '../../materi/models/mapel/mapel.dart';
import '../../materi/provider/mapel_provider.dart';
import '../controller/home_controller.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final GetDataProflie proflie = GetDataProflie();
  final BodyController bodyC = Get.put(BodyController());
  final GetDataMapel getDataMapel = GetDataMapel();
  final MateriController materiC = Get.put(MateriController());
  final BaseLInkController baseLinkC = Get.put(BaseLInkController());
  final HomeController homeC = Get.put(HomeController());
  final TugasProvider tugasProvider = TugasProvider();
  final BodyProvider bodyProvider = BodyProvider();
  final TugasController tugasC = Get.put(TugasController());

  Future<void> onRefres() async {
    await Future.delayed(const Duration(seconds: 2));
    setState(() {});
  }

  void token() async {
    SharedPreferences getToken = await SharedPreferences.getInstance();
    setState(() {
      bodyC.token = getToken.getString("token");
    });
  }

  @override
  void initState() {
    super.initState();
    _firebaseMessaging();
    token();
    Provider.of<ConnectivityProfider>(context, listen: false)
        .strartMonitiring();
  }

  Future<void> _firebaseMessaging() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.data['judul'] != null) {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  actions: <Widget>[
                    TextButton(
                      child: const Text("OKE"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: const Text("Update"),
                      onPressed: () => _launchURLGoolePlay(message.data['url'] +
                          "com.aricode.watulintang.smk4yogyakata"),
                    ),
                  ],
                  content: ListTile(
                    leading: Image.asset(
                      "assets/images/google-play-update.png",
                      width: 40,
                      height: 40,
                    ),
                    title: Text(message.data['judul']),
                    subtitle: Text(
                      message.data['isi'],
                    ),
                  ),
                ));
      }
      return;
    });
  }

  _launchURLGoolePlay(String urlPlaystore) async {
    final url = urlPlaystore;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _launchURL() async {
    final url = baseLinkC.baseUrlUrlLaucer3;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  // _launchURL2(String id) async {
  //   final url = baseLinkC.baseUrlUrlLaucer1 + "?tugasmodal=$id";
  //   if (await canLaunch(url)) {
  //     await launch(url);
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    return SizedBox(
      height: _height,
      width: _width,
      child: RefreshIndicator(
        onRefresh: onRefres,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              clipShape(),
              // Container(
              //   margin: const EdgeInsets.only(
              //       left: 30, right: 30, top: 20, bottom: 10),
              //   child: Center(
              //     child: Text('Selamat Datang di SMAN 1 Contoh',
              //         maxLines: 3,
              //         style: GoogleFonts.inter(
              //             color: Colors.black,
              //             fontSize: 16,
              //             fontWeight: FontWeight.bold)),
              //   ),
              // ),
              // CarouselSlider.builder(
              //   itemCount: homeC.imgList.length,
              //   options: CarouselOptions(
              //     autoPlay: true,
              //     enlargeCenterPage: true,
              //   ),
              //   itemBuilder: (context, index, realIdx) {
              //     return Container(
              //       decoration: BoxDecoration(
              //           borderRadius: BorderRadius.circular(10),
              //           color: Colors.grey[200],
              //           image: DecorationImage(
              //               fit: BoxFit.cover,
              //               image: AssetImage(
              //                 homeC.imgList[index],
              //               ))),
              //     );
              //   },
              // ),
              // const SizedBox(
              //   height: 5,
              // ),

              Container(
                margin: const EdgeInsets.only(left: 30, right: 30, top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Materi by Pelajaran',
                        style: GoogleFonts.roboto(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const MateriViews()));
                        },
                        child: Text(
                          "Lihat Semua",
                          style: GoogleFonts.roboto(
                            color: const Color.fromARGB(255, 24, 144, 155),
                          ),
                        )),
                    //IconButton(icon: isExpanded? Icon(Icons.arrow_drop_up, color: Colors.orange[200],) : Icon(Icons.arrow_drop_down, color: Colors.orange[200],), onPressed: _expand)
                  ],
                ),
              ),
              materi(),
              const Divider(),
              Container(
                margin: const EdgeInsets.only(
                    left: 30, right: 30, top: 10, bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Tugas Terbaru",
                        style: GoogleFonts.roboto(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                    GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const TugsSiswaViews()));
                        },
                        child: Text(
                          'Lihat Semua',
                          style: GoogleFonts.roboto(
                            color: const Color.fromARGB(255, 24, 144, 155),
                          ),
                        ))
                  ],
                ),
              ),
              tugasViews(),
              const Divider(),
              Container(
                margin: const EdgeInsets.only(
                    left: 30, right: 30, top: 10, bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Status Terbaru",
                        style: GoogleFonts.inter(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.bold)),
                    GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const StatusPage()));
                        },
                        child: Text(
                          'Lihat Semua',
                          style: GoogleFonts.inter(
                            color: const Color.fromARGB(255, 24, 144, 155),
                          ),
                        ))
                  ],
                ),
              ),
              postToday(),
            ],
          ),
        ),
      ),
    );
  }

  Widget tugasViews() {
    return FutureBuilder<TugasSiswa?>(
        future: tugasProvider.getTugas('0'),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            return SizedBox(
              height: 170,
              child: ListView.separated(
                padding: const EdgeInsets.all(5),
                shrinkWrap: true,
                itemCount: snapshot.data!.data.length,
                scrollDirection: Axis.horizontal,
                separatorBuilder: (BuildContext context, index) {
                  return const SizedBox(
                    width: 2,
                  );
                },
                itemBuilder: (BuildContext context, index) {
                  return Container(
                      width: 290,
                      padding: const EdgeInsets.all(13),
                      margin: const EdgeInsets.only(top: 5, left: 10),
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 0.75,
                              blurRadius: 7,
                              offset: const Offset(
                                  0, 3), // changes position of shadow
                            ),
                          ],
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Flexible(
                                child: Text(
                                  snapshot.data!.data[index].judul,
                                  style: GoogleFonts.inter(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    color: snapshot.data!.data[index]
                                                .statusWaktuMengerjakan ==
                                            'active'
                                        ? Colors.green[400]
                                        : Colors.red.withOpacity(0.70),
                                    borderRadius: BorderRadius.circular(20)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    if (snapshot.data!.data[index]
                                            .statusWaktuMengerjakan ==
                                        'active')
                                      const Icon(
                                        Icons.notifications_active_outlined,
                                        color: Colors.white,
                                        size: 15,
                                      ),
                                    if (snapshot.data!.data[index]
                                            .statusWaktuMengerjakan ==
                                        'expired')
                                      const Icon(
                                        Icons.warning_amber_rounded,
                                        color: Colors.white,
                                        size: 15,
                                      ),
                                    if (snapshot.data!.data[index]
                                            .statusWaktuMengerjakan ==
                                        'active')
                                      Text(
                                        'Tugas Aktif',
                                        style: GoogleFonts.inter(
                                            color: Colors.white,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    if (snapshot.data!.data[index]
                                            .statusWaktuMengerjakan ==
                                        'expired')
                                      SizedBox(
                                        child: Text(
                                          'Kadalwarsa',
                                          style: GoogleFonts.inter(
                                              color: Colors.white,
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold),
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  const Icon(
                                    Icons.book_outlined,
                                    color: Colors.black54,
                                    size: 15,
                                  ),
                                  SizedBox(
                                    width: 94,
                                    child: Text(
                                      snapshot.data!.data[index].namaPelajaran,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.inter(
                                          color: Colors.black87,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  const Icon(
                                    Icons.person,
                                    color: Colors.black54,
                                    size: 15,
                                  ),
                                  SizedBox(
                                    width: 80,
                                    child: Text(
                                      snapshot.data!.data[index].namaGuru,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.inter(
                                          color: Colors.black87,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w500),
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  const Icon(
                                    Icons.timer,
                                    color: Colors.black54,
                                    size: 15,
                                  ),
                                  Text(
                                    snapshot.data!.data[index].waktuMengerjakan
                                        .replaceAll("<br>", '\n'),
                                    style: GoogleFonts.inter(
                                        color: Colors.black87,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500),
                                  )
                                ],
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Container(
                                width: 128,
                                margin: const EdgeInsets.only(top: 10),
                                padding: const EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: snapshot.data!.data[index]
                                                .statusMengerjakan ==
                                            'busy'
                                        ? Colors.amber[100]
                                        : Colors.red[100]),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    if (snapshot.data!.data[index]
                                            .statusMengerjakan ==
                                        'busy')
                                      Icon(
                                        Icons.timeline_outlined,
                                        color: Colors.amber[800],
                                        size: 15,
                                      ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    if (snapshot.data!.data[index]
                                            .statusMengerjakan ==
                                        'not_yet')
                                      Icon(
                                        Icons.warning_amber_rounded,
                                        color: Colors.red[800],
                                        size: 15,
                                      ),
                                    if (snapshot.data!.data[index]
                                            .statusMengerjakan ==
                                        'busy')
                                      Text('Sedang Mngerjakan',
                                          style: GoogleFonts.inter(
                                            color: Colors.amber[800],
                                            fontSize: 10,
                                          )),
                                    if (snapshot.data!.data[index]
                                            .statusMengerjakan ==
                                        'not_yet')
                                      Text('Belum Mngerjakan',
                                          style: GoogleFonts.inter(
                                            color: Colors.red[800],
                                            fontSize: 10,
                                          )),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    tugasC.id =
                                        snapshot.data!.data[index].idTugas;
                                  });
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          const DetailTugas()));
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(top: 10),
                                  padding:
                                      const EdgeInsets.fromLTRB(8, 6, 6, 6),
                                  decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                          255, 24, 144, 155),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("Detail",
                                          style: GoogleFonts.inter(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12)),
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
                      ));
                },
              ),
            );
          } else {
            return SizedBox(
              height: 170,
              child: ListView.separated(
                padding: const EdgeInsets.all(5),
                shrinkWrap: true,
                itemCount: 4,
                scrollDirection: Axis.horizontal,
                separatorBuilder: (BuildContext context, index) {
                  return const SizedBox(
                    width: 2,
                  );
                },
                itemBuilder: (BuildContext context, index) {
                  return Container(
                      width: 290,
                      padding: const EdgeInsets.all(13),
                      margin: const EdgeInsets.only(top: 5, left: 10),
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 0.75,
                              blurRadius: 7,
                              offset: const Offset(
                                  0, 3), // changes position of shadow
                            ),
                          ],
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Flexible(
                                  child: Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[200]!,
                                enabled: true,
                                child: Container(
                                  color: Colors.white,
                                  width: 100,
                                  height: 10,
                                ),
                              )),
                              Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Shimmer.fromColors(
                                      baseColor: Colors.grey[300]!,
                                      highlightColor: Colors.grey[200]!,
                                      enabled: true,
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        width: 80,
                                        height: 25,
                                      ),
                                    ),
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Shimmer.fromColors(
                                    baseColor: Colors.grey[300]!,
                                    highlightColor: Colors.grey[200]!,
                                    enabled: true,
                                    child: Container(
                                      color: Colors.white,
                                      width: 90,
                                      height: 5,
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Shimmer.fromColors(
                                    baseColor: Colors.grey[300]!,
                                    highlightColor: Colors.grey[200]!,
                                    enabled: true,
                                    child: Container(
                                      color: Colors.white,
                                      width: 90,
                                      height: 5,
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Shimmer.fromColors(
                                    baseColor: Colors.grey[300]!,
                                    highlightColor: Colors.grey[200]!,
                                    enabled: true,
                                    child: Container(
                                      color: Colors.white,
                                      width: 90,
                                      height: 5,
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Container(
                                width: 199,
                                margin: const EdgeInsets.only(top: 10),
                                padding: const EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.white),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Shimmer.fromColors(
                                      baseColor: Colors.grey[300]!,
                                      highlightColor: Colors.grey[200]!,
                                      enabled: true,
                                      child: Container(
                                        foregroundDecoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        width: 133,
                                        height: 20,
                                      ),
                                    ),
                                    Shimmer.fromColors(
                                      baseColor: Colors.grey[300]!,
                                      highlightColor: Colors.grey[200]!,
                                      enabled: true,
                                      child: Container(
                                        margin: const EdgeInsets.only(left: 10),
                                        foregroundDecoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        width: 50,
                                        height: 20,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          )
                        ],
                      ));
                },
              ),
            );
          }
        });
  }

  Widget postToday() {
    // ignore: unused_local_variable
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    return FutureBuilder<StatusSiswa?>(
        future: bodyProvider.getStatusBody(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            return SizedBox(
              height: 200,
              child: ListView.separated(
                padding: const EdgeInsets.all(5),
                shrinkWrap: true,
                itemCount: snapshot.data!.data.length,
                scrollDirection: Axis.horizontal,
                separatorBuilder: (BuildContext context, index) {
                  return const SizedBox(
                    width: 2,
                  );
                },
                itemBuilder: (BuildContext context, index) {
                  return GestureDetector(
                    onTap: () {
                      bodyC.namaUser = snapshot.data!.data[index].nama;
                      bodyC.tanggalPost =
                          snapshot.data!.data[index].tanggal.toString();
                      bodyC.idPost = snapshot.data!.data[index].id.toString();
                      bodyC.judulPost = snapshot.data!.data[index].judul;
                      bodyC.avatar = snapshot.data!.data[index].img;
                      bodyC.isiPost = snapshot.data!.data[index].detail;
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const KomentarWidget()));
                    },
                    child: Container(
                        width: 290,
                        margin: const EdgeInsets.only(top: 5, left: 10),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
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
                        child: Column(
                          children: [
                            Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Column(children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    CircleAvatar(
                                      radius: 17,
                                      backgroundColor: Colors.white,
                                      child: CircleAvatar(
                                        backgroundColor: Colors.grey[300],
                                        radius: 15,
                                        backgroundImage: NetworkImage(
                                            snapshot.data!.data[index].img),
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
                                            snapshot.data!.data[index].nama,
                                            style: GoogleFonts.inter(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 200,
                                          child: Text(
                                            DateFormat.yMMMMd().add_jm().format(
                                                DateTime.parse(snapshot
                                                    .data!.data[index].tanggal
                                                    .toString())),
                                            style: GoogleFonts.roboto(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w100),
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                SizedBox(
                                  width: _width / 1.50,
                                  height: 60,
                                  child: Text(
                                    snapshot.data!.data[index].judul
                                        .replaceAll("<p>", ""),
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.start,
                                    maxLines: 5,
                                    style: GoogleFonts.inter(
                                        color: Colors.black87,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                const Divider(
                                  height: 0,
                                ),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
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
                                          onPressed: () {
                                            bodyC.namaUser =
                                                snapshot.data!.data[index].nama;
                                            bodyC.tanggalPost = snapshot
                                                .data!.data[index].tanggal
                                                .toString();
                                            bodyC.idPost = snapshot
                                                .data!.data[index].id
                                                .toString();
                                            bodyC.judulPost = snapshot
                                                .data!.data[index].judul;
                                            bodyC.avatar =
                                                snapshot.data!.data[index].img;
                                            bodyC.isiPost = snapshot
                                                .data!.data[index].detail;
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const KomentarWidget()));
                                          },
                                          icon: Icon(Icons.chat_rounded,
                                              size: 13,
                                              color: Colors.grey[500]),
                                          label: FutureBuilder<KomentarModels?>(
                                              future: bodyProvider.komentarBody(
                                                  bodyC.idPost = snapshot
                                                      .data!.data[index].id
                                                      .toString()),
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
                                              })),
                                    ])
                              ]),
                            )
                          ],
                        )),
                  );
                },
              ),
            );
          } else {
            return SizedBox(
              height: 200,
              child: ListView.separated(
                padding: const EdgeInsets.all(5),
                shrinkWrap: true,
                itemCount: 3,
                scrollDirection: Axis.horizontal,
                separatorBuilder: (BuildContext context, index) {
                  return const SizedBox(
                    width: 10,
                  );
                },
                itemBuilder: (BuildContext context, index) {
                  return Container(
                      width: 290,
                      margin: const EdgeInsets.only(top: 5, left: 10),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
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
                      child: Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            child: Column(children: [
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Shimmer.fromColors(
                                    baseColor: Colors.grey[300]!,
                                    highlightColor: Colors.grey[200]!,
                                    enabled: true,
                                    child: CircleAvatar(
                                      radius: 17,
                                      backgroundColor: Colors.white,
                                      child: CircleAvatar(
                                        backgroundColor: Colors.grey[300],
                                        radius: 15,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Shimmer.fromColors(
                                    baseColor: Colors.grey[300]!,
                                    highlightColor: Colors.grey[200]!,
                                    enabled: true,
                                    child: Column(
                                      children: [
                                        Shimmer.fromColors(
                                          baseColor: Colors.grey[300]!,
                                          highlightColor: Colors.grey[200]!,
                                          enabled: true,
                                          child: Container(
                                            color: Colors.white,
                                            width: 200,
                                            height: 10,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Shimmer.fromColors(
                                          baseColor: Colors.grey[300]!,
                                          highlightColor: Colors.grey[200]!,
                                          enabled: true,
                                          child: Container(
                                            color: Colors.white,
                                            width: 200,
                                            height: 10,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Column(
                                children: [
                                  Shimmer.fromColors(
                                    baseColor: Colors.grey[300]!,
                                    highlightColor: Colors.grey[200]!,
                                    enabled: true,
                                    child: Container(
                                      color: Colors.white,
                                      width: 240,
                                      height: 10,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Shimmer.fromColors(
                                    baseColor: Colors.grey[300]!,
                                    highlightColor: Colors.grey[200]!,
                                    enabled: true,
                                    child: Container(
                                      color: Colors.white,
                                      width: 240,
                                      height: 10,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Shimmer.fromColors(
                                    baseColor: Colors.grey[300]!,
                                    highlightColor: Colors.grey[200]!,
                                    enabled: true,
                                    child: Container(
                                      color: Colors.white,
                                      width: 240,
                                      height: 10,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Shimmer.fromColors(
                                    baseColor: Colors.grey[300]!,
                                    highlightColor: Colors.grey[200]!,
                                    enabled: true,
                                    child: Container(
                                      color: Colors.white,
                                      width: 240,
                                      height: 10,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              const Divider(
                                height: 0,
                              ),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
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
                                                fontWeight: FontWeight.bold))),
                                    TextButton.icon(
                                        onPressed: () {},
                                        icon: Icon(Icons.chat_rounded,
                                            size: 13, color: Colors.grey[500]),
                                        label: Text(" (0) ",
                                            style: GoogleFonts.roboto(
                                                color: Colors.grey[500],
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold))),
                                  ])
                            ]),
                          )
                        ],
                      ));
                },
              ),
            );
          }
        });
  }

  Widget materi() {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    return FutureBuilder<List<Mapel>?>(
        future: getDataMapel.getDataMapel('8'),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data!;
            return Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(5, 10, 5, 0),
              child: GridView.builder(
                  padding: EdgeInsets.zero,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1,
                  ),
                  itemCount: data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: <Widget>[
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                materiC.id = data[index].id;
                                materiC.nama = data[index].nama;
                                materiC.img = data[index].img;
                                materiC.kelas = data[index].idkelas;
                              });
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      const MateriViewsList()));
                            },
                            child: CachedNetworkImage(
                              height: _height / 12,
                              width: _width / 12,
                              imageUrl: data[index].img,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          data[index].nama,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.roboto(fontSize: 12),
                        ),
                      ],
                    );
                  }),
            );
          } else {
            return Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(5, 10, 5, 0),
              child: GridView.builder(
                  padding: EdgeInsets.zero,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1,
                  ),
                  itemCount: 8,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                        onTap: () {},
                        child: Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[200]!,
                          enabled: true,
                          child: Container(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                5, 10, 5, 0),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)),
                          ),
                        ));
                  }),
            );
          }
        });
  }

  Widget clipShape() {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    return Stack(
      children: <Widget>[
        Opacity(
          opacity: 0.75,
          child: ClipPath(
            clipper: CustomShapeClipper(),
            child: Container(
              height: 240,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xff20bfcc), Color(0xff512da8)],
                ),
              ),
            ),
          ),
        ),
        Opacity(
          opacity: 0.5,
          child: ClipPath(
            clipper: CustomShapeClipper2(),
            child: Container(
              height: 203,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xff20bfcc), Color(0xff512da8)],
                ),
              ),
            ),
          ),
        ),
        Opacity(
          opacity: 0.25,
          child: ClipPath(
            clipper: CustomShapeClipper3(),
            child: Container(
              height: 240,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xff20bfcc), Color(0xff512da8)],
                ),
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const StatusPage()));
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
            margin: const EdgeInsets.only(left: 30, right: 30, top: 200),
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ], color: Colors.white, borderRadius: BorderRadius.circular(30)),
            child: Row(
              children: [
                const Icon(
                  Icons.send_rounded,
                  color: Color.fromARGB(255, 24, 144, 155),
                  size: 25,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  "Apa Yang Anda Pikirkan ?",
                  style: GoogleFonts.roboto(
                      fontSize: 13,
                      color: const Color.fromARGB(255, 4, 53, 58)),
                )
              ],
            ),
          ),
        ),
        Positioned(
          left: 190,
          right: 0,
          top: 120,
          child: GestureDetector(
            onTap: () {
              _launchURL();
            },
            child: Container(
              height: 37,
              decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 24, 144, 155),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      bottomLeft: Radius.circular(20))),
              child: Center(
                  child: Text(
                "SMK N 4 Yogyakarta",
                style: GoogleFonts.roboto(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              )),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: _height / 17),
          child: FutureBuilder<Profile?>(
              future: proflie.getDataUserProfile(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  bodyC.foto = snapshot.data!.photo;
                  bodyC.nama = snapshot.data!.namasiswa;
                  return Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const ProfilePage()));
                        },
                        child: Container(
                          margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: CircleAvatar(
                            radius: 26,
                            child: CircleAvatar(
                              radius: 24,
                              backgroundColor: Colors.white,
                              child: CircleAvatar(
                                radius: 22,
                                backgroundImage: snapshot.data!.photo != "NULL"
                                    ? NetworkImage(snapshot.data!.photo)
                                    : const NetworkImage(
                                        'https://sma1contoh.sekolahkita.net/assets/images/profile/thumb/1632116632-pria-min_thumb.png'),
                              ),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const ProfilePage()));
                        },
                        child: Column(
                          children: [
                            SizedBox(
                              width: _width - 140,
                              child: Text("Hi, " + snapshot.data!.namasiswa,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.roboto(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                            ),
                            SizedBox(
                              width: _width - 140,
                              child: Text(snapshot.data!.nis,
                                  style: GoogleFonts.roboto(
                                    color: Colors.white,
                                    fontSize: 15,
                                  )),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const PesanViews()));
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 10),
                          width: 35,
                          height: 35,
                          decoration: BoxDecoration(
                              color: const Color(0xFFACBDDF),
                              borderRadius: BorderRadius.circular(30)),
                          child: Stack(
                            children: [
                              const Center(
                                  child: Icon(Icons.notifications_outlined)),
                              if (homeC.listNotifikasi.isNotEmpty)
                                Positioned(
                                    top: 0,
                                    left: 20,
                                    right: 0,
                                    child: Container(
                                      padding: const EdgeInsets.all(1),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: const Color(0xFFACBDDF),
                                              width: 2),
                                          color: Colors.red,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Center(
                                        child: Text(
                                          homeC.listNotifikasi.length
                                              .toString(),
                                          style: const TextStyle(
                                              color: Colors.white, fontSize: 8),
                                        ),
                                      ),
                                    )),
                            ],
                          ),
                        ),
                      )
                    ],
                  );
                } else {
                  return Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const ProfilePage()));
                        },
                        child: Container(
                          margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: const CircleAvatar(
                            radius: 28,
                            backgroundColor: Colors.amber,
                            child: CircleAvatar(
                              radius: 26,
                              backgroundColor: Colors.white,
                              child: CircleAvatar(
                                radius: 26,
                                backgroundImage: NetworkImage(
                                    'https://sma1contoh.sekolahkita.net/assets/images/profile/thumb/1632116632-pria-min_thumb.png'),
                              ),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const ProfilePage()));
                        },
                        child: Column(
                          children: [
                            SizedBox(
                              width: _width - 126,
                              child: Text("Hi, siswa",
                                  style: GoogleFonts.roboto(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                            ),
                            SizedBox(
                              width: _width - 126,
                              child: Text('-',
                                  style: GoogleFonts.roboto(
                                    color: Colors.white,
                                    fontSize: 15,
                                  )),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const PesanViews()));
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 10),
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                              color: const Color(0xFFACBDDF),
                              borderRadius: BorderRadius.circular(30)),
                          child: Stack(
                            children: [
                              const Center(
                                  child: Icon(Icons.notifications_outlined)),
                              if (homeC.listNotifikasi.isNotEmpty)
                                Positioned(
                                    top: 0,
                                    left: 20,
                                    right: 0,
                                    child: Container(
                                      padding: const EdgeInsets.all(3),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: const Color(0xFFACBDDF),
                                              width: 2),
                                          color: Colors.red,
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: Center(
                                        child: Text(
                                          homeC.listNotifikasi.length
                                              .toString(),
                                          style: const TextStyle(
                                              color: Colors.white, fontSize: 8),
                                        ),
                                      ),
                                    )),
                            ],
                          ),
                        ),
                      )
                    ],
                  );
                }
              }),
        ),
      ],
    );
  }
}
