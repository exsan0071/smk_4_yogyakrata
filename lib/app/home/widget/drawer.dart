import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../jadwal/views/jadwal_viwes.dart';
import '../../materi/views/materi_views.dart';
import '../../more/models/more_models.dart';
import '../../more/providers/more_providers.dart';
import '../../nilai&progress/views/nilai_progress_views.dart';
import '../../presensi/views/presensi.dart';
import '../../Elearning/views/elearning.dart';
import '../controller/home_controller.dart';

class DrawerUi extends StatefulWidget {
  const DrawerUi({Key? key}) : super(key: key);
  @override
  State<DrawerUi> createState() => _DrawerUiState();
}

class _DrawerUiState extends State<DrawerUi> {
  bool isExpanded = false;
  final GetInfoSekolah getInfoSekolah = GetInfoSekolah();
  final HomeController homeC = Get.put(HomeController());
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Material(
        color: Colors.white,
        child: ListView(
          children: [
            Container(
                decoration: const BoxDecoration(
                  color: Color(0xff20bfcc),
                  border: Border(
                    bottom: BorderSide(width: 0.75, color: Color(0xFFD9D9D9)),
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                height: 70,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FutureBuilder<InfoSekolah?>(
                        future: getInfoSekolah.getInfo(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return CachedNetworkImage(
                              imageUrl: snapshot.data!.logoHeader,
                              width: 150,
                              height: 75,
                            );
                          } else {
                            return Container();
                          }
                        }),
                    IconButton(
                        onPressed: () {
                          homeC.scaffoldKey.currentState?.openEndDrawer();
                        },
                        icon: const Icon(
                          Icons.close,
                          color: Colors.white,
                        ))
                  ],
                )),
            const SizedBox(
              height: 10,
            ),
            bulderItems(
                image: const AssetImage('assets/images/home.png'),
                text: 'Home',
                onCliked: () {
                  homeC.scaffoldKey.currentState?.openEndDrawer();
                }),
            bulderItems(
                image: const AssetImage('assets/images/jobs_icons.png'),
                text: 'Presensi',
                onCliked: () => selectedItems(context, 1)),
            bulderItems(
              image: const AssetImage('assets/images/elearning.png'),
              text: 'E-learning',
              onCliked: () => selectedItems(context, 2),
            ),
            bulderItems(
                image: const AssetImage('assets/images/perpustakaan.png'),
                text: 'Perpustakaan',
                onCliked: () => selectedItems(context, 3)),
            const SizedBox(
              height: 10,
            ),
            const Divider(endIndent: 20, indent: 20, color: Color(0xFF7F7F7F)),
            Padding(
              padding: const EdgeInsets.only(
                  top: 10, bottom: 10, right: 20, left: 20),
              child: Text('e-Learning',
                  style: GoogleFonts.roboto(
                      fontSize: 20,
                      color: Colors.green,
                      fontWeight: FontWeight.bold)),
            ),
            bulderItems(
                image:
                    const AssetImage('assets/icons/home_drawer_elearing.png'),
                text: 'Home E-learning',
                onCliked: () => selectedItems(context, 4)),
            bulderItems(
                image: const AssetImage('assets/icons/Jadwal_drawer.png'),
                text: 'Jadwal Saya',
                onCliked: () => selectedItems(context, 5)),
            bulderItems(
                image: const AssetImage('assets/icons/materi_drawer.png'),
                text: 'Materi',
                onCliked: () => selectedItems(context, 6)),
            bulderItems(
                image: const AssetImage('assets/icons/progres&nilai.png'),
                text: 'Nilai & Prograss',
                onCliked: () => selectedItems(context, 7)),
          ],
        ),
      ),
    );
  }
}

void selectedItems(BuildContext context, int index) {
  switch (index) {
    case 0:
      break;
    case 1:
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const PresensiPage()));
      break;
    case 2:
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const ElearningPage()));
      break;
    case 3:
      // Navigator.of(context)
      //     .push(MaterialPageRoute(builder: (context) => const ElearningPage()));
      break;
    case 4:
      Fluttertoast.showToast(
        msg: "button not function",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      break;
    case 5:
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const JadwalViews()));
      break;
    case 6:
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const MateriViews()));
      break;
    case 7:
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const NilaiProgressViews()));
  }
}

Widget bulderItems({
  required AssetImage image,
  required String text,
  VoidCallback? onCliked,
}) {
  const color = Colors.black;
  return SizedBox(
    height: 48,
    child: ListTile(
      leading: Image(
        image: image,
        width: 23,
        height: 23,
      ),
      title: Text(
        text,
        style: GoogleFonts.roboto(
          fontSize: 14,
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
      onTap: onCliked,
    ),
  );
}
