import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';
import '../../../materi/controller/materi.dart';
import '../../../materi/models/detail/detail.dart';
import '../../../materi/models/detail/file.dart';
import '../../../materi/provider/data_materi.dart';
import '../../../materi/widget/detail/detail.dart';

import '../../../materi/widget/detail/pdf.dart';

import 'detail_pdf.dart';

class ListDetail extends StatefulWidget {
  const ListDetail({Key? key}) : super(key: key);

  @override
  _ListDetailState createState() => _ListDetailState();
}

class _ListDetailState extends State<ListDetail> {
  final MateriController materiC = Get.put(MateriController());
  final GetDataDetailMateri getDataDetailMateri = GetDataDetailMateri();
  var top = 0.0;
  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    return Scaffold(
        body: CustomScrollView(slivers: <Widget>[
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
                duration: const Duration(milliseconds: 10),
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
                          maxLines: 2,
                          style: GoogleFonts.roboto(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
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
                            top: MediaQuery.of(context).padding.top + 7,
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
                                image: NetworkImage(materiC.img.toString()))),
                      )),
                  Positioned(
                    left: 0,
                    right: 0,
                    top: MediaQuery.of(context).padding.top + 60,
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.all(10),
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
                          height: 90,
                          child: Stack(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(
                                    top: 20, left: 5, right: 5),
                                width: _width,
                                height: 90,
                                child: Row(
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
                                              image: NetworkImage(
                                                  'https://sma1contoh.sekolahkita.net/views/themes/dashboard/assets/images/elearning/materi-kbm.png'))),
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: 200,
                                          child: Text(
                                            materiC.nama.toString(),
                                            style: GoogleFonts.roboto(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 200,
                                          child: Text(
                                            materiC.judul.toString(),
                                            style: GoogleFonts.roboto(
                                                fontWeight: FontWeight.w300,
                                                fontSize: 12),
                                          ),
                                        ),
                                      ],
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        showModalBottomSheet(
                                            backgroundColor: Colors.transparent,
                                            isScrollControlled: true,
                                            context: context,
                                            builder: (context) {
                                              return Container(
                                                padding:
                                                    const EdgeInsets.all(10),
                                                decoration: const BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(20),
                                                      topRight:
                                                          Radius.circular(20),
                                                    )),
                                                height: _height / 2.25,
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text("Keterangan :",
                                                            style: GoogleFonts
                                                                .roboto(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            )),
                                                        IconButton(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          icon: const Icon(
                                                              Icons.close),
                                                          color: Colors.grey,
                                                        ),
                                                      ],
                                                    ),
                                                    Expanded(
                                                      child: FutureBuilder<
                                                              DetailMateri?>(
                                                          future: getDataDetailMateri
                                                              .getDataDetailMateri(
                                                                  materiC.idD
                                                                      .toString()),
                                                          builder: (context,
                                                              snapshot) {
                                                            if (snapshot
                                                                    .connectionState ==
                                                                ConnectionState
                                                                    .waiting) {
                                                              return const Center(
                                                                  child:
                                                                      CircularProgressIndicator());
                                                            } else {
                                                              if (snapshot
                                                                  .hasData) {
                                                                final data =
                                                                    snapshot
                                                                        .data!;
                                                                return SingleChildScrollView(
                                                                  child: Container(
                                                                    margin: const EdgeInsets.all(5),
                                                                    width: _width,
                                                                    child: Center(
                                                                      child: Text(data
                                                                          .detail),
                                                                    ),
                                                                  ),
                                                                );
                                                              } else {
                                                                return const Center(
                                                                    child: Text(
                                                                        "TIDAK ADA DATA",
                                                                        maxLines: 3,
                                                                        ));
                                                              }
                                                            }
                                                          }),
                                                    )
                                                  ],
                                                ),
                                              );
                                            });
                                      },
                                      child: Column(
                                        children: [
                                          Container(
                                            width: 30,
                                            height: 30,
                                            decoration: const BoxDecoration(
                                                image: DecorationImage(
                                                    image: AssetImage(
                                                        'assets/icons/aboutdetail.png'))),
                                          ),
                                          Text("Keterangan :",
                                              style: GoogleFonts.roboto(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 8,
                                              ))
                                        ],
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
                                        borderRadius: const BorderRadius.only(
                                            topRight: Radius.circular(10),
                                            topLeft: Radius.circular(10),
                                            bottomRight: Radius.circular(10))),
                                    width: 100,
                                    height: 25,
                                    child: Center(
                                        child:
                                            materiC.typeMateri != "file_upload"
                                                ? Text(
                                                    'Umum',
                                                    style: GoogleFonts.roboto(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )
                                                : Text(
                                                    materiC.typeMateri
                                                        .toString()
                                                        .replaceAll('_', ' '),
                                                    style: GoogleFonts.roboto(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(left: 10),
                                    padding: const EdgeInsets.all(5),
                                    decoration: const BoxDecoration(
                                        color: Colors.amber,
                                        borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(10),
                                            bottomRight: Radius.circular(10))),
                                    height: 25,
                                    child: Center(
                                        child: Text(
                                      materiC.guru.toString(),
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
                  Positioned(
                      left: 0,
                      right: 0,
                      top: MediaQuery.of(context).padding.top + 20,
                      child: Center(
                          child: Column(
                        children: [
                          Text(materiC.nama.toString(),
                              style: GoogleFonts.roboto(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                          Text("BAB I",
                              style: GoogleFonts.roboto(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                        ],
                      )))
                ],
              ),
            );
          })),
      SliverToBoxAdapter(
          child: FutureBuilder<List<FileMateri>?>(
              future: getDataDetailMateri.getDatadetail(materiC.idD.toString()),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return ListView.builder(
                      itemCount: 10,
                      primary: false,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Container(
                          padding: const EdgeInsets.all(5),
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          height: 100,
                          width: _width,
                          decoration: BoxDecoration(
                              color: Colors.grey[50],
                              borderRadius: BorderRadius.circular(10)),
                          child: Row(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
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
                      });
                } else {
                  if (snapshot.hasData) {
                    final data = snapshot.data!;
                    return ListView.builder(
                      itemCount: data.length,
                      primary: false,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.all(10),
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
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          image: DecorationImage(
                                              image: data[index].media ==
                                                      'youtube'
                                                  ? const AssetImage(
                                                      'assets/icons/youtube_detail.png')
                                                  : data[index].media ==
                                                          'google_drive'
                                                      ? const AssetImage(
                                                          'assets/icons/drive_pdf.png')
                                                      : const AssetImage(
                                                          'assets/icons/pdfdetail.png'))),
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: 200,
                                          child: Text(
                                            materiC.nama.toString(),
                                            style: GoogleFonts.roboto(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 200,
                                          child: Text(
                                            materiC.judul.toString(),
                                            style: GoogleFonts.roboto(
                                                fontWeight: FontWeight.w300,
                                                fontSize: 12),
                                          ),
                                        ),
                                      ],
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          materiC.dataUrl =
                                              data[index].dataurl;
                                        });
                                        if (data[index].media == "youtube") {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const Detail()));
                                        } else if (data[index].media ==
                                            "google_drive") {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const PdfViewerPage()));
                                        } else {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute<dynamic>(
                                              builder: (_) =>
                                                  PDFViewerCachedFromUrl(
                                                url: data[index].dataurl,
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                            color: Colors.blue,
                                            borderRadius:
                                                BorderRadius.circular(10)),
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
                                        color: Colors.red[700],
                                        borderRadius: const BorderRadius.only(
                                            topRight: Radius.circular(10),
                                            topLeft: Radius.circular(10),
                                            bottomRight: Radius.circular(10))),
                                    width: 100,
                                    height: 25,
                                    child: Center(
                                        child: Text(
                                      data[index].media.replaceAll('_', ' '),
                                      style: GoogleFonts.roboto(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    )),
                                  ),
                                ],
                              ))
                            ],
                          ),
                        );
                      },
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
              }))
    ]));
  }
}
