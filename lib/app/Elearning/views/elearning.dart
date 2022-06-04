import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../home/controller/body_controller.dart';
import '../../jadwal/views/jadwal_viwes.dart';
import '../../materi/views/materi_views.dart';
import '../../nilai&progress/views/nilai_progress_views.dart';
import '../../tugas/views/tugas_siswa.dart';
import '../models/statik_models.dart';
import '../provider/profider_statik.dart';

class ElearningPage extends StatefulWidget {
  const ElearningPage({Key? key}) : super(key: key);

  @override
  _ElearningPageState createState() => _ElearningPageState();
}

class _ElearningPageState extends State<ElearningPage> {
  final BodyController bodyC = Get.put(BodyController());
  final StatikDataProvider statikDataProvider = StatikDataProvider();
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(children: [
      Stack(children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: 220,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/elearning_image.png"),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: 10,
          left: 10,
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_outlined,
                  size: 20, color: Colors.black),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ),
        Column(
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              const SizedBox(
                width: 20,
              ),
              Column(children: [
                const SizedBox(
                  height: 20,
                ),
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: const Color.fromARGB(255, 24, 144, 155),
                  ),
                  child: Text("STATISTIK ANDA",
                      style: GoogleFonts.roboto(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      )),
                ),
                const SizedBox(
                  height: 10,
                ),
                FutureBuilder<Statistik?>(
                    future: statikDataProvider.getStatik(),
                    builder: (BuildContext context, snapshot) {
                      if (snapshot.hasData) {
                        return Container(
                          width: 304,
                          height: 43,
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: const Color.fromARGB(255, 24, 144, 155),
                          ),
                          child: Text(
                              "STATISTIK ANDA Informasi Statistik Ketugasan Anda (${snapshot.data!.data.tahun}-${snapshot.data!.data.semester})",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.roboto(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              )),
                        );
                      } else {
                        return Container(
                          width: 304,
                          height: 43,
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: const Color.fromARGB(255, 24, 144, 155),
                          ),
                          child: Text(
                              "STATISTIK ANDA Informasi Statistik Ketugasan Anda",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.roboto(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              )),
                        );
                      }
                    }),
                const SizedBox(
                  height: 10,
                ),
              ]),
            ]),
            Column(children: [
              Container(
                padding: const EdgeInsets.all(15),
                margin: const EdgeInsets.all(27),
                width: MediaQuery.of(context).size.width,
                height: 180,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 0.75,
                      blurRadius: 7,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        if (bodyC.foto == null)
                          const Padding(
                            padding: EdgeInsets.only(right: 5),
                            child: CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.black,
                              child: CircleAvatar(
                                radius: 18,
                                backgroundColor: Color(0xff20bfcc),
                                backgroundImage:
                                    AssetImage("assets/images/avatar-akun.png"),
                              ),
                            ),
                          ),
                        if (bodyC.foto != null)
                          Padding(
                            padding: const EdgeInsets.only(right: 5),
                            child: CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.black,
                              child: CircleAvatar(
                                radius: 18,
                                backgroundColor: const Color(0xff20bfcc),
                                backgroundImage: NetworkImage(bodyC.foto),
                              ),
                            ),
                          ),
                        Column(
                          children: [
                            Container(
                              width: 210,
                              margin: const EdgeInsets.only(left: 20),
                              child: Text(bodyC.nama,
                                  style: GoogleFonts.roboto(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  )),
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 20),
                              width: 210,
                              child: Text("Siswa",
                                  style: GoogleFonts.roboto(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black,
                                  )),
                            )
                          ],
                        ),
                      ],
                    ),
                    const Divider(color: Colors.black),
                    FutureBuilder<Statistik?>(
                        future: statikDataProvider.getStatik(),
                        builder: (BuildContext context, snapshot) {
                          if (snapshot.hasData) {
                            return Container(
                              padding: const EdgeInsets.only(
                                  left: 20, right: 20, top: 10),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(6),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              color: const Color.fromARGB(
                                                  255, 18, 126, 136),
                                            ),
                                            child: Text(
                                                snapshot.data!.data.statistik
                                                    .semuaTugas
                                                    .toString(),
                                                style: GoogleFonts.roboto(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.white,
                                                )),
                                          ),
                                          Container(
                                            padding:
                                                const EdgeInsets.only(left: 5),
                                            width: 60,
                                            child: Text("SEMUA TUGAS",
                                                maxLines: 2,
                                                style: GoogleFonts.roboto(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.black,
                                                )),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(6),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              color: const Color.fromARGB(
                                                  255, 18, 126, 136),
                                            ),
                                            child: Text(
                                                snapshot.data!.data.statistik
                                                    .belumDikerjakan
                                                    .toString(),
                                                style: GoogleFonts.roboto(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.white,
                                                )),
                                          ),
                                          Container(
                                            padding:
                                                const EdgeInsets.only(left: 5),
                                            width: 60,
                                            child: Text("BELUM DIKERJAKAN",
                                                maxLines: 2,
                                                style: GoogleFonts.roboto(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.black,
                                                )),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(6),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              color: const Color.fromARGB(
                                                  255, 18, 126, 136),
                                            ),
                                            child: Text(
                                                snapshot.data!.data.statistik
                                                    .jumlahRemidi
                                                    .toString(),
                                                style: GoogleFonts.roboto(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.white,
                                                )),
                                          ),
                                          Container(
                                            padding:
                                                const EdgeInsets.only(left: 5),
                                            width: 60,
                                            child: Text("JUMLAH REMIDI",
                                                maxLines: 2,
                                                style: GoogleFonts.roboto(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.black,
                                                )),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(6),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              color: const Color.fromARGB(
                                                  255, 18, 126, 136),
                                            ),
                                            child: Text(
                                                snapshot.data!.data.statistik
                                                    .remidiSelesai
                                                    .toString(),
                                                style: GoogleFonts.roboto(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.white,
                                                )),
                                          ),
                                          Container(
                                            padding:
                                                const EdgeInsets.only(left: 5),
                                            width: 60,
                                            child: Text("REMIDI SELESAI",
                                                maxLines: 2,
                                                style: GoogleFonts.roboto(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.black,
                                                )),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            );
                          } else {
                            return Container(
                              padding: const EdgeInsets.only(
                                  left: 20, right: 20, top: 10),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(6),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              color: const Color.fromARGB(
                                                  255, 18, 126, 136),
                                            ),
                                            child: Text("0",
                                                style: GoogleFonts.roboto(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.white,
                                                )),
                                          ),
                                          Container(
                                            padding:
                                                const EdgeInsets.only(left: 5),
                                            width: 60,
                                            child: Text("SEMUA TUGAS",
                                                maxLines: 2,
                                                style: GoogleFonts.roboto(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.black,
                                                )),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(6),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              color: const Color.fromARGB(
                                                  255, 18, 126, 136),
                                            ),
                                            child: Text("0",
                                                style: GoogleFonts.roboto(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.white,
                                                )),
                                          ),
                                          Container(
                                            padding:
                                                const EdgeInsets.only(left: 5),
                                            width: 60,
                                            child: Text("BELUM DIKERJAKAN",
                                                maxLines: 2,
                                                style: GoogleFonts.roboto(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.black,
                                                )),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(6),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              color: const Color.fromARGB(
                                                  255, 18, 126, 136),
                                            ),
                                            child: Text("0",
                                                style: GoogleFonts.roboto(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.white,
                                                )),
                                          ),
                                          Container(
                                            padding:
                                                const EdgeInsets.only(left: 5),
                                            width: 60,
                                            child: Text("JUMLAH REMIDI",
                                                maxLines: 2,
                                                style: GoogleFonts.roboto(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.black,
                                                )),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(6),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              color: const Color.fromARGB(
                                                  255, 18, 126, 136),
                                            ),
                                            child: Text("0",
                                                style: GoogleFonts.roboto(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.white,
                                                )),
                                          ),
                                          Container(
                                            padding:
                                                const EdgeInsets.only(left: 5),
                                            width: 60,
                                            child: Text("REMIDI SELESAI",
                                                maxLines: 2,
                                                style: GoogleFonts.roboto(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.black,
                                                )),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            );
                          }
                        })
                  ],
                ),
              )
            ]),
            Container(
              padding: const EdgeInsets.only(left: 20, bottom: 5),
              width: MediaQuery.of(context).size.width,
              child: Text('Dashboard E-Learning',
                  style: GoogleFonts.roboto(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xff025258),
                  )),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              height: 180,
              width: MediaQuery.of(context).size.width,
              child: GridView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 2,
                  mainAxisSpacing: 2,
                  childAspectRatio: 1,
                ),
                scrollDirection: Axis.vertical,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const JadwalViews()));
                    },
                    child: Column(
                      children: [
                        Image.asset(
                          "assets/icons/jadwal_elearning2.png",
                          width: 43,
                          height: 43,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text("Jadwal Saya",
                            style: GoogleFonts.roboto(
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ))
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const MateriViews()));
                    },
                    child: Column(
                      children: [
                        Image.asset(
                          "assets/icons/materi_elearning2.png",
                          width: 43,
                          height: 43,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text("Materi",
                            style: GoogleFonts.roboto(
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ))
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const JadwalViews()));
                    },
                    child: Column(
                      children: [
                        Image.asset(
                          "assets/icons/kbmVirtualp.png",
                          width: 43,
                          height: 43,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text("KBM/PJJ Virtual",
                            style: GoogleFonts.roboto(
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ))
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const TugsSiswaViews()));
                    },
                    child: Column(
                      children: [
                        Image.asset(
                          "assets/icons/Tugas,PR,Remidial.png",
                          width: 43,
                          height: 43,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text("Tugas,PR,Remidial",
                            style: GoogleFonts.roboto(
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ))
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const NilaiProgressViews()));
                    },
                    child: Column(
                      children: [
                        Image.asset(
                          "assets/icons/Nilai & Progres.png",
                          width: 43,
                          height: 43,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text("Nilai & Progres",
                            style: GoogleFonts.roboto(
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ))
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.only(left: 20, bottom: 5),
              width: MediaQuery.of(context).size.width,
              child: Text('Petunjuk e-learning',
                  style: GoogleFonts.roboto(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xff025258),
                  )),
            ),
            Container(
              padding: const EdgeInsets.only(left: 30, bottom: 5, top: 10),
              width: MediaQuery.of(context).size.width,
              child: Text('Budayakan Membaca!',
                  style: GoogleFonts.roboto(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  )),
            ),
            Container(
              padding: const EdgeInsets.only(left: 30, bottom: 5, right: 30),
              width: MediaQuery.of(context).size.width,
              child: Text(
                  'Petunjuk yang harus di pahami siswa terkait menu elearning pada system',
                  style: GoogleFonts.roboto(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[600],
                  )),
            ),
            Container(
              padding: const EdgeInsets.only(
                  left: 30, bottom: 5, right: 30, top: 10),
              width: MediaQuery.of(context).size.width,
              child: Text(
                  'Job Description\n Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat. Ut wisi enim ad minim veniam, quis nostrud exerci tation ullamcorper suscipit lobortis nisl ut aliquip ex ea commodo consequat.Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat. Ut wisi enim ad minim veniam, quis nostrud exerci tation ullamcorper suscipit lobortis nisl ut aliquip ex ea commodo consequat.a commodo consequat.',
                  style: GoogleFonts.roboto(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 43, 43, 43),
                  )),
            ),
          ],
        )
      ])
    ]));
  }
}
