import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../more/models/more_models.dart';
import '../../more/providers/more_providers.dart';

class AboutMe extends StatefulWidget {
  const AboutMe({Key? key}) : super(key: key);

  @override
  _AboutMeState createState() => _AboutMeState();
}

class _AboutMeState extends State<AboutMe> {
  final GetInfoSekolah getInfoSekolah = GetInfoSekolah();
  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('About', style: GoogleFonts.roboto()),
      ),
      body: FutureBuilder<InfoSekolah?>(
          future: getInfoSekolah.getInfo(),
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
                return ListView(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(20),
                      width: _width,
                      height: 160,
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
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Image.asset(
                            'assets/images/office_1.png',
                            width: 70,
                            height: 70,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            snapshot.data!.sistem,
                            style: GoogleFonts.roboto(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text("kantor : " + snapshot.data!.alamat)
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(20),
                      width: _width,
                      height: 200,
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
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Image.asset(
                            'assets/images/info-icon45.png',
                            width: 70,
                            height: 70,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Kontak & Sosial Media',
                            style: GoogleFonts.roboto(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text("Telpon : " + snapshot.data!.telpon,
                              style: GoogleFonts.roboto()),
                          Text("Email : " + snapshot.data!.email,
                              style: GoogleFonts.roboto()),
                          Text("Website : " + snapshot.data!.website,
                              style: GoogleFonts.roboto()),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(20),
                      width: _width,
                      height: 150,
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
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Image.asset(
                            'assets/icons/about.png',
                            width: 70,
                            height: 70,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            "App Version",
                            style: GoogleFonts.roboto(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text("1.0.2", style: GoogleFonts.roboto())
                        ],
                      ),
                    ),
                  ],
                );
              } else {
                return Center(
                    child: Container(
                        margin: const EdgeInsets.all(20),
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
              }
            }
          }),
    );
  }
}
