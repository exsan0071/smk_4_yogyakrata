//pkg import here...
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
//pkg import file here ....
import '../widget/body.dart';
import '../../controller/baselink.dart';
import '../../more/views/more.dart';
import '../widget/drawer.dart';
import '../controller/home_controller.dart';
import '../models/notifikasi/data.dart';
import '../../controller/conectyfity.dart';
import '../provider/home_provider.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final HomeController homeC = Get.put(HomeController());
  final GetDataHome getData = GetDataHome();
  final BaseLInkController baseLinkC = Get.put(BaseLInkController());
  Future getNotifikasi() async {
    if (mounted) {
      setState(() {
        homeC.isLoading = true;
      });
    }
    try {
      SharedPreferences getToken = await SharedPreferences.getInstance();
      String? auth = getToken.getString("token");
      final response = await http.get(
        Uri.parse(baseLinkC.baseUrlUrlLaucer3 + '/api/notifikasi'),
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
        List<Data> dataUserBlog =
            it.map((value) => Data.fromJson(value)).toList();

        if (mounted) {
          setState(() {
            homeC.isLoading = false;
          });
        }
        return dataUserBlog;
      }
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }
  }

  // refres notif account ....
  Future<void> onRefres() async {
    try {
      // ignore: unnecessary_null_comparison
      if (getNotifikasi() != null) {
        homeC.listNotifikasi = await getNotifikasi();
      }
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }
  }
// notiif aplikasi ....

  Future<void> _dialoStart() async {
    await Future.delayed(const Duration(seconds: 2));
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text(
                "Mobile Versi Beta 1.0.4 ⚠ !! ",
                style: GoogleFonts.roboto(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.red),
              ),
              content: Text(
                "Fitur versi mobile 1.0.4 masih dalam proses pengembangan, beberapa fitur belum dapat diakses melalui Aplikasi, versi full fitur dapat anda akses melalui Web Browser.",
                textAlign: TextAlign.justify,
                style: GoogleFonts.roboto(),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text("OKE"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text("BERALIH KE WEB"),
                  onPressed: () => _launchURL(),
                ),
              ]);
        });
  }

// notif url laucher .....
  _launchURL() async {
    final url = baseLinkC.baseUrlUrlLaucer2;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  initState() {
    getNotifikasi();
    onRefres();
    _dialoStart();
    Provider.of<ConnectivityProfider>(context, listen: false)
        .strartMonitiring();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DateTime timeBackPressed = DateTime.now();
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    return Scaffold(
      drawer: const DrawerUi(),
      key: homeC.scaffoldKey,
      body: WillPopScope(
        onWillPop: () async {
          final difference = DateTime.now().difference(timeBackPressed);
          final isExitWarning = difference >= const Duration(seconds: 2);
          timeBackPressed = DateTime.now();
          if (isExitWarning) {
            Fluttertoast.showToast(
              msg: "Tekan Kembali Untuk Keluar",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.SNACKBAR,
              backgroundColor: Colors.red,
              textColor: Colors.white,
            );
            return false;
          } else {
            Fluttertoast.cancel();
            return true;
          }
        },
        child: PageStorage(
          bucket: homeC.bucket,
          child: homeC.curenCreen,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          homeC.scaffoldKey.currentState?.openDrawer();
        },
        child: Image.asset(
          'assets/images/elearning.png',
          width: 35,
          height: 35,
        ),
        backgroundColor: Colors.white,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          child: SizedBox(
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
// **************************************************************************
//                       menu buttom  home code here.......
// **************************************************************************
                MaterialButton(
                  minWidth: 40,
                  onPressed: () {
                    setState(() {
                      homeC.curenCreen = const Body();
                      homeC.screenBar = 0;
                    });
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.grey[400]?.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Icon(Icons.home_sharp,
                            color: homeC.screenBar == 0
                                ? const Color.fromARGB(255, 24, 144, 155)
                                : Colors.grey[600]),
                      ),
                      Text(
                        'Home',
                        style: GoogleFonts.roboto(
                          fontSize: 13,
                          color: homeC.screenBar == 0
                              ? const Color.fromARGB(255, 24, 144, 155)
                              : Colors.grey[600],
                        ),
                      )
                    ],
                  ),
                ),
// **************************************************************************
//                     menu bottom notfications code here......
// **************************************************************************
                MaterialButton(
                  minWidth: 40,
                  onPressed: () {
                    showModalBottomSheet(
                        backgroundColor: Colors.transparent,
                        isScrollControlled: true,
                        context: context,
                        builder: (context) {
                          return notifications(_height, context, _width);
                        });
                    setState(() {
                      homeC.screenBar = 1;
                    });
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Stack(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.grey[400]?.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Icon(
                              Icons.notifications,
                              color: homeC.screenBar == 1
                                  ? const Color.fromARGB(255, 24, 144, 155)
                                  : Colors.grey[600],
                            ),
                          ),
                          if (homeC.listNotifikasi.isNotEmpty)
                            Positioned(
                                top: 0,
                                left: 20,
                                right: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(1),
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.white),
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Center(
                                    child: Text(
                                      homeC.listNotifikasi.length.toString(),
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 8),
                                    ),
                                  ),
                                ))
                        ],
                      ),
                      Text(
                        'Notification',
                        style: GoogleFonts.roboto(
                          fontSize: 13,
                          color: homeC.screenBar == 1
                              ? const Color.fromARGB(255, 24, 144, 155)
                              : Colors.grey[600],
                        ),
                      )
                    ],
                  ),
                ),
// **************************************************************************
//                      menu bottom mesages code here.......
// **************************************************************************
                MaterialButton(
                  minWidth: 40,
                  onPressed: () {
                    showModalBottomSheet(
                        backgroundColor: Colors.transparent,
                        isScrollControlled: true,
                        context: context,
                        builder: (context) {
                          return Container(
                            padding: const EdgeInsets.all(10),
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                )),
                            height: _height / 3,
                            child: Column(
                              children: [
                                Text("Messages",
                                    style: GoogleFonts.roboto(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    )),
                                const SizedBox(
                                  height: 50,
                                ),
                                const Text("Beleum ada pesan")
                              ],
                            ),
                          );
                        });
                    setState(() {
                      homeC.screenBar = 2;
                    });
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.grey[400]?.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Icon(
                          Icons.chat_rounded,
                          color: homeC.screenBar == 2
                              ? const Color.fromARGB(255, 24, 144, 155)
                              : Colors.grey[600],
                        ),
                      ),
                      Text(
                        'Messages',
                        style: GoogleFonts.roboto(
                          fontSize: 13,
                          color: homeC.screenBar == 2
                              ? const Color.fromARGB(255, 24, 144, 155)
                              : Colors.grey[600],
                        ),
                      )
                    ],
                  ),
                ),
                MaterialButton(
                  minWidth: 40,
                  onPressed: () {
                    setState(() {
                      homeC.curenCreen = const MorePage();
                      homeC.screenBar = 3;
                    });
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.more_horiz_outlined,
                        color: homeC.screenBar == 3
                            ? const Color.fromARGB(255, 24, 144, 155)
                            : Colors.grey[600],
                      ),
                      Text(
                        'Lainnya',
                        style: GoogleFonts.roboto(
                          fontSize: 13,
                          color: homeC.screenBar == 3
                              ? const Color.fromARGB(255, 24, 144, 155)
                              : Colors.grey[600],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }

  /// notifications code here ...
  Container notifications(double _height, BuildContext context, double _width) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          )),
      height: _height - 30,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Notifications",
                  style: GoogleFonts.roboto(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  )),
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.close),
                color: Colors.grey,
              ),
            ],
          ),
          Expanded(
            child: FutureBuilder<List<Data>?>(
                future: getData.getNotifikasi(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<Data>?> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Expanded(
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          return Container(
                            padding: const EdgeInsets.all(5),
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            height: 70,
                            width: _width,
                            decoration: BoxDecoration(
                                color: Colors.grey[50],
                                borderRadius: BorderRadius.circular(10)),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Shimmer.fromColors(
                                    baseColor: Colors.grey[400]!,
                                    highlightColor: Colors.grey[200]!,
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
                        },
                        itemCount: 10,
                      ),
                    );
                  } else {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          return Container(
                            padding: const EdgeInsets.all(5),
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            height: 70,
                            width: _width,
                            decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(10)),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: CircleAvatar(
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
                                Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: _width / 1.40,
                                          child: Text(
                                            "Memberikan Tugas Baru ${snapshot.data![index].detail}",
                                            style: GoogleFonts.roboto(
                                                fontWeight: FontWeight.bold),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: _width / 1.40,
                                          child: Text(
                                              DateFormat("d MMMM yyyy , H:mm ", "id_ID")
                                                      .format(DateTime.parse(snapshot
                                                              .data![index]
                                                              .waktu
                                                              .startdate +
                                                          ' ' +
                                                          snapshot
                                                              .data![index]
                                                              .waktu
                                                              .starttime)) +
                                                  'WIB' +
                                                  ' S.d. ' +
                                                  DateFormat("d MMMM yyyy , H:mm  ", "id_ID")
                                                      .format(DateTime.parse(snapshot
                                                              .data![index]
                                                              .waktu
                                                              .enddate +
                                                          ' ' +
                                                          snapshot.data![index].waktu.endtime)) +
                                                  "WIB",
                                              style: GoogleFonts.roboto(fontSize: 12, fontWeight: FontWeight.w500)),
                                        )
                                      ],
                                    )
                                  ],
                                )
                              ],
                            ),
                          );
                        },
                        itemCount: snapshot.data!.length,
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
                }),
          )
        ],
      ),
    );
  }
}
