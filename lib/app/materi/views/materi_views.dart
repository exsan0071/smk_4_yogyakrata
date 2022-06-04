import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import '../../materi/controller/materi.dart';
import '../../materi/models/mapel/mapel.dart';
import '../../materi/provider/mapel_provider.dart';
import '../../materi/widget/materi.dart';

class MateriViews extends StatefulWidget {
  const MateriViews({Key? key}) : super(key: key);

  @override
  _MateriViewsState createState() => _MateriViewsState();
}

class _MateriViewsState extends State<MateriViews> {
  final MateriController materiC = Get.put(MateriController());
  final GetDataMapel getDataMapel = GetDataMapel();
  @override
  void initState() {
    // _checkVersion();
    super.initState();
  }
// void _checkVersion() async {
//     final newVersion = NewVersion(
//       androidId: "com.aricode.watulintang.sma1contoh",
//     );
//     final status = await newVersion.getVersionStatus();
//     newVersion.showUpdateDialog(
//       context: context,
//       versionStatus: status!,
//       dialogTitle: "Update Versi ${status.storeVersion} !!!",
//       dismissButtonText: "Nanti",
//       dialogText:
//           "Download Aplikasi versi ${status.storeVersion} Sekarang, Aplikasi Udah tersedia di Play Store",
//       dismissAction: () {
//         Navigator.of(context).pop();
//       },
//       updateButtonText: "Update Sekarang",
//     );

//     // ignore: avoid_print
//     print("DEVICE : " + status.localVersion);
//     // ignore: avoid_print
//     print("STORE : " + status.storeVersion);
//   }
  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Materi Belajar'),
        ),
        body: FutureBuilder<List<Mapel>?>(
            future: getDataMapel.getDataMapel('100'),
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
                  return SafeArea(
                    child: Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 0),
                        child: GridView.builder(
                            padding: EdgeInsets.zero,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 50,
                              childAspectRatio: 1,
                            ),
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: data.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          materiC.id = data[index].id;
                                          materiC.nama = data[index].nama;
                                          materiC.img = data[index].img;
                                          materiC.kelas = data[index].idkelas;
                                        });
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const MateriViewsList()));
                                      },
                                      child: Container(
                                        width: double.infinity,
                                        height: 80,
                                        decoration: BoxDecoration(
                                          color: const Color(0x00EEEEEE),
                                          image: DecorationImage(
                                            image: Image.network(
                                              data[index].img,
                                            ).image,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(0),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      margin: const EdgeInsets.only(top: 5),
                                      width: _width / 2.0,
                                      child: Center(
                                        child: Text(
                                          data[index].nama,
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.roboto(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              );
                            })),
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
