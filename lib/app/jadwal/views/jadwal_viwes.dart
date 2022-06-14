import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Elearning/models/statik_models.dart';
import '../../Elearning/provider/profider_statik.dart';
import '../../controller/baselink.dart';
import '../../jadwal/models/jadwal_models2.dart';
import '../../jadwal/providers/jadwal_provider.dart';
import 'package:timeline_tile/timeline_tile.dart';

class JadwalViews extends StatefulWidget {
  const JadwalViews({Key? key}) : super(key: key);
  @override
  _JadwalViewsState createState() => _JadwalViewsState();
}

class _JadwalViewsState extends State<JadwalViews> {
  final GetJadwal getJadwal = GetJadwal();
  final BaseLInkController baseLinkC = Get.put(BaseLInkController());
  final StatikDataProvider statikDataProvider = StatikDataProvider();
  var selected = 0;
  bool isloading = false;
  List<DataJadwal> datajadwal = [];
  List hari = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'];
  Future getDataJadwal(String hari) async {
    final _baseUrl = baseLinkC.baseUrlUrlLaucer3 + '/api/jadwal?hari=$hari';
    if (mounted) {
      setState(() {
        isloading = true;
      });
    }
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
      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        final data = jsonDecode(response.body)['data'];

        if (mounted) {
          setState(() {
            for (Map<String, dynamic> i in data) {
              datajadwal.add(DataJadwal.fromJson(i));
              isloading = false;
            }
          });
        }
      }
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    getDataJadwal('Senin');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xff20bfcc),
        body: CustomScrollView(slivers: <Widget>[
          _buildAppbar(context),
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 100,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    )),
                    child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () => setState(() {
                              selected = index;
                              datajadwal.clear();
                              getDataJadwal(hari[index]);
                            }),
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: selected == index
                                    ? const Color.fromARGB(255, 24, 144, 155)
                                        .withOpacity(0.1)
                                    : null,
                              ),
                              child: Text(
                                hari[index],
                                style: GoogleFonts.roboto(
                                    color: selected == index
                                        ? Colors.black
                                        : Colors.grey[700]),
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (_, index) => const SizedBox(
                              width: 5,
                            ),
                        itemCount: hari.length),
                  )
                ],
              ),
            ),
          ),
          datajadwal.isEmpty
              ? SliverFillRemaining(
                  child: Container(
                      color: Colors.white,
                      child: Center(
                        child: Text(
                          "Tidak Ada Jadwal",
                          style: GoogleFonts.roboto(
                              color: Colors.grey, fontSize: 18),
                        ),
                      )),
                )
              : SliverList(
                  delegate: SliverChildBuilderDelegate(
                      (_, index) => Container(
                            color: Colors.white,
                            child: Row(
                              children: [
                                const SizedBox(
                                  width: 10,
                                ),
                                SizedBox(
                                  height: datajadwal.length == 2
                                      ? MediaQuery.of(context).size.height /
                                          2.20
                                      : MediaQuery.of(context).size.height / 4,
                                  width: 20,
                                  child: TimelineTile(
                                    alignment: TimelineAlign.manual,
                                    lineXY: 0,
                                    isFirst: true,
                                    indicatorStyle: IndicatorStyle(
                                        indicatorXY: 0,
                                        width: 15,
                                        indicator: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                  width: 5,
                                                  color: index.isEven
                                                      ? Colors.green
                                                      : Colors.red)),
                                        )),
                                    afterLineStyle: const LineStyle(
                                        thickness: 2, color: Colors.grey),
                                  ),
                                ),
                                Expanded(
                                    child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      children: [
                                        Text(datajadwal[index].jmMulai),
                                        const SizedBox(
                                          height: 80,
                                        ),
                                        Text(datajadwal[index].jmSelesai)
                                      ],
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(15),
                                      margin: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                          color: index.isEven
                                              ? Colors.green.withOpacity(0.1)
                                              : Colors.blue.withOpacity(0.1),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      width: 250,
                                      height: 100,
                                      child: Column(
                                        children: [
                                          Text(
                                            datajadwal[index].namaGuru,
                                            style: GoogleFonts.roboto(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(datajadwal[index].namaPelajaran),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Text(datajadwal[index].jmMulai +
                                              " - " +
                                              datajadwal[index].jmSelesai)
                                        ],
                                      ),
                                    )
                                  ],
                                ))
                              ],
                            ),
                          ),
                      childCount: datajadwal.length))
        ]));
  }

  Widget _buildAppbar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 90,
      backgroundColor: const Color(0xff20bfcc),
      leading: IconButton(
        onPressed: () => Navigator.of(context).pop(),
        icon: const Icon(
          Icons.arrow_back_outlined,
          size: 20,
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 24, 144, 155),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                "Jadwal Pelajaran",
                style: GoogleFonts.roboto(
                    fontSize: 13,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            FutureBuilder<Statistik?>(
                future: statikDataProvider.getStatik(),
                builder: (BuildContext context, snapshot) {
                  if (snapshot.hasData) {
                    return Text(
                      "Tahun Pelajaran ${snapshot.data!.data.tahun} Semester ${snapshot.data!.data.semester}",
                      style: GoogleFonts.roboto(
                          fontSize: 8,
                          color: Colors.grey[700],
                          fontWeight: FontWeight.bold),
                    );
                  } else {
                    return Text(
                      "Tahun Pelajaran -- Semester --",
                      style: GoogleFonts.roboto(
                          fontSize: 8,
                          color: Colors.grey[700],
                          fontWeight: FontWeight.bold),
                    );
                  }
                }),
          ],
        ),
      ),
    );
  }
}
