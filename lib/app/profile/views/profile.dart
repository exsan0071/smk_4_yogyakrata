import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import '../../home/controller/body_controller.dart';
import '../../more/views/settings_umum.dart';

import '../../profile/models/profile.dart';
import '../../profile/provider/profile.dart';
import '../../status/views/status.dart';
//pkg import here ...
import '../../../app_theme.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final GetDataProflie proflie = GetDataProflie();
  final BodyController bodyC = Get.put(BodyController());
  @override
  void initState() {
    super.initState();
    //  _checkVersion();
    _tabController = TabController(vsync: this, length: 3); //tab controller....
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  // void _checkVersion() async {
  //   final newVersion = NewVersion(
  //     androidId: "com.aricode.watulintang.sma1contoh",
  //   );
  //   final status = await newVersion.getVersionStatus();
  //   newVersion.showUpdateDialog(
  //     context: context,
  //     versionStatus: status!,
  //     dialogTitle: "Update Versi ${status.storeVersion} !!!",
  //     dismissButtonText: "Nanti",
  //     dialogText:
  //         "Download Aplikasi versi ${status.storeVersion} Sekarang, Aplikasi Udah tersedia di Play Store",
  //     dismissAction: () {
  //       Navigator.of(context).pop();
  //     },
  //     updateButtonText: "Update Sekarang",
  //   );

  //   // ignore: avoid_print
  //   print("DEVICE : " + status.localVersion);
  //   // ignore: avoid_print
  //   print("STORE : " + status.storeVersion);
  // }
  @override
  Widget build(BuildContext context) {
    // sisze display ...
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppTheme.blueligt,
          title: const Text('Profile'),
        ),
        backgroundColor: Colors.grey[200],
        body: FutureBuilder<Profile?>(
            future: proflie.getDataUserProfile(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
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
              } else {
                if (snapshot.hasData) {
                  final data = snapshot.data!;
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                            width: _width,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                            ),
                            child: Stack(children: [
                              Column(children: [
                                Container(
                                  width: _width,
                                  height: _height / 4.65,
                                  decoration: const BoxDecoration(
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(
                                              'https://sma1contoh.sekolahkita.net/views/themes/dashboard/assets/images/profile/dashboard.png'))),
                                ),
                                const SizedBox(
                                  height: 60,
                                ),
                                Text(
                                  snapshot.data!.namasiswa,
                                  style: GoogleFonts.roboto(
                                      fontSize: 22,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "NIS:",
                                        style: GoogleFonts.roboto(
                                            fontSize: 16,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w300),
                                      ),
                                      Text(
                                        snapshot.data!.nis,
                                        style: GoogleFonts.roboto(
                                            fontSize: 16,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        "Status:",
                                        style: GoogleFonts.roboto(
                                            fontSize: 16,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w300),
                                      ),
                                      Text(
                                        "Siawa Aktif",
                                        style: GoogleFonts.roboto(
                                            fontSize: 16,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Kelas",
                                        style: GoogleFonts.roboto(
                                            fontSize: 16,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w300),
                                      ),
                                      Text(
                                        "Nama Kelas,",
                                        style: GoogleFonts.roboto(
                                            fontSize: 16,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        "Tahun Ajar",
                                        style: GoogleFonts.roboto(
                                            fontSize: 16,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w300),
                                      ),
                                      Text(
                                        "2021/2022",
                                        style: GoogleFonts.roboto(
                                            fontSize: 16,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: ElevatedButton.icon(
                                      onPressed: () {},
                                      icon: const Icon(Icons.add_circle_sharp),
                                      label: const Text('Cetak Karu Pelajar')),
                                ),
                              ]),
                              Positioned(
                                top: 85,
                                left: MediaQuery.of(context).padding.left / 2,
                                right: MediaQuery.of(context).padding.left / 2,
                                child: CircleAvatar(
                                  radius: 57,
                                  backgroundColor: AppTheme.white,
                                  child: CircleAvatar(
                                    radius: 53,
                                    backgroundImage: NetworkImage(bodyC.foto),
                                  ),
                                ),
                              ),
                            ])),
                        Container(
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(20),
                                    bottomRight: Radius.circular(20))),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: TabBar(
                                  labelPadding: const EdgeInsets.only(
                                      left: 20, right: 20),
                                  controller: _tabController,
                                  labelColor: Colors.blue,
                                  unselectedLabelColor: Colors.grey,
                                  isScrollable: true,
                                  labelStyle: GoogleFonts.roboto(
                                      fontWeight: FontWeight.bold),
                                  indicatorSize: TabBarIndicatorSize.label,
                                  tabs: const [
                                    Tab(text: "Timeline"),
                                    Tab(text: "Teman"),
                                    Tab(text: "Katu Pelajar"),
                                  ]),
                            )),
                        SizedBox(
                          height: 500,
                          width: double.maxFinite,
                          child: TabBarView(
                            controller: _tabController,
                            children: [
                              Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const StatusPage()));
                                    },
                                    child: Container(
                                        margin: const EdgeInsets.all(20),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        width: _width,
                                        height: 100,
                                        child: Column(
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.only(
                                                  top: 10),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 10),
                                                    child: CircleAvatar(
                                                      radius: 20,
                                                      backgroundColor:
                                                          AppTheme.white,
                                                      child: CircleAvatar(
                                                        radius: 17,
                                                        backgroundImage:
                                                            NetworkImage(
                                                                bodyC.foto),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 37,
                                                        vertical: 10),
                                                    margin:
                                                        const EdgeInsets.only(
                                                      right: 10,
                                                    ),
                                                    decoration: BoxDecoration(
                                                        color: Colors.grey[200],
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(30)),
                                                    child: const Text(
                                                      'Apa yang anda Pikirkan ?',
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          color: Colors.grey),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 5),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context).push(
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  const StatusPage()));
                                                    },
                                                    child: Text("Foto/Vedeo",
                                                        style:
                                                            GoogleFonts.roboto(
                                                                color: Colors
                                                                    .grey[600],
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                  ),
                                                  TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context).push(
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        const StatusPage()));
                                                      },
                                                      child: Text("Tag Frieds",
                                                          style: GoogleFonts
                                                              .roboto(
                                                                  color: Colors
                                                                          .grey[
                                                                      600],
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold))),
                                                  TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context).push(
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        const StatusPage()));
                                                      },
                                                      child: Text(
                                                          "Perasaan/Aktivitas",
                                                          style: GoogleFonts
                                                              .roboto(
                                                                  color: Colors
                                                                          .grey[
                                                                      600],
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold))),
                                                ],
                                              ),
                                            )
                                          ],
                                        )),
                                  ),
                                  BiodataSiswa(width: _width, data: data)
                                ],
                              ),
                              Column(children: [
                                Container(
                                    margin: const EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    width: _width,
                                    height: 100,
                                    child: Column(children: [
                                      Container(
                                          margin:
                                              const EdgeInsets.only(top: 10),
                                          child: Text('Teman Sakelas',
                                              textAlign: TextAlign.start,
                                              style: GoogleFonts.roboto(
                                                  fontSize: 20,
                                                  color: Colors.black,
                                                  fontWeight:
                                                      FontWeight.bold))),
                                    ])),
                                BiodataSiswa(width: _width, data: data)
                              ]),
                              Column(children: [
                                Container(
                                    margin: const EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    width: _width,
                                    height: 100,
                                    child: Column(children: [
                                      Container(
                                          margin:
                                              const EdgeInsets.only(top: 10),
                                          child: Text('Cetak Kartu Pelajar',
                                              textAlign: TextAlign.start,
                                              style: GoogleFonts.roboto(
                                                  fontSize: 20,
                                                  color: Colors.black,
                                                  fontWeight:
                                                      FontWeight.bold))),
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        child: const Text(
                                          "Lengkapi biodatamu sebelum mencetak kartu pelajar mandiri.",
                                          maxLines: 3,
                                        ),
                                      )
                                    ])),
                                BiodataSiswa(width: _width, data: data)
                              ]),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    child: Center(
                        child: Lottie.asset(
                      'assets/icons/-no-internet-connection.json',
                    )),
                  );
                }
              }
            }));
  }
}

class BiodataSiswa extends StatelessWidget {
  const BiodataSiswa({
    Key? key,
    required double width,
    required this.data,
  })  : _width = width,
        super(key: key);

  final double _width;
  final Profile data;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(left: 20, right: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        width: _width,
        height: 220,
        child: Column(
          children: [
            Container(
                margin: const EdgeInsets.only(top: 10),
                child: Text('Biodataku',
                    textAlign: TextAlign.start,
                    style: GoogleFonts.roboto(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold))),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Image.asset(
                    'assets/icons/nama.png',
                    width: 18,
                    height: 18,
                  ),
                ),
                Text('Nama Lengkap : ',
                    style: GoogleFonts.roboto(
                      fontSize: 13,
                      color: Colors.black,
                    )),
                Flexible(
                  child: Text(data.namasiswa,
                      style: GoogleFonts.roboto(
                          fontSize: 13,
                          color: Colors.black,
                          fontWeight: FontWeight.bold)),
                )
              ],
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Image.asset(
                    'assets/icons/tanggal.png',
                    width: 18,
                    height: 18,
                  ),
                ),
                Text('Tanggal Lahir : ',
                    style: GoogleFonts.roboto(
                      fontSize: 13,
                      color: Colors.black,
                    )),
                Flexible(
                  child: Text(
                      '${data.tempatlahir}, ${DateFormat("d MMMM yyyy ", "id_ID").format(DateTime.parse(data.tgllahir))}',
                      style: GoogleFonts.roboto(
                          fontSize: 13,
                          color: Colors.black,
                          fontWeight: FontWeight.bold)),
                )
              ],
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Image.asset(
                    'assets/icons/locations.png',
                    width: 18,
                    height: 18,
                  ),
                ),
                Text('Alamat: ',
                    style: GoogleFonts.roboto(
                      fontSize: 13,
                      color: Colors.black,
                    )),
                Text(data.alamattinggal,
                    style: GoogleFonts.roboto(
                        fontSize: 13,
                        color: Colors.black,
                        fontWeight: FontWeight.bold))
              ],
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const SetingUmum()));
                },
                child: Text("Edit Biodata",
                    style: GoogleFonts.roboto(
                        color: Colors.white, fontWeight: FontWeight.bold)))
          ],
        ));
  }
}
