import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../more/views/about.dart';

class PesanViews extends StatefulWidget {
  const PesanViews({Key? key}) : super(key: key);

  @override
  _PesanViewsState createState() => _PesanViewsState();
}

class _PesanViewsState extends State<PesanViews> with TickerProviderStateMixin {
  _launchURLEmail() async {
    const url = "mailto:sekolahkitanet@gmail.com";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _launchURLWa() async {
    const url =
        "https://api.whatsapp.com/send/?phone=%2B6281321214107&text&app_absent=0";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Pesan',
            style: GoogleFonts.roboto(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        //tab bar
        body: SafeArea(
            child: GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: DefaultTabController(
                    length: 2,
                    initialIndex: 0,
                    child: Column(children: [
                      TabBar(
                        labelColor: Colors.black,
                        labelStyle: GoogleFonts.roboto(
                          fontWeight: FontWeight.w600,
                        ),
                        indicatorColor: const Color(0xff20bfcc),
                        tabs: const [
                          Tab(
                            text: 'INFO',
                          ),
                          Tab(
                            text: 'BANTUAN',
                          ),
                        ],
                      ),
                      Expanded(
                          child: TabBarView(children: [
                        Center(
                          child: Text(
                            'Belum Ada Pesan ..',
                            style: GoogleFonts.roboto(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            buildEmailSuport(context),
                            buildWaSuport(context),
                            buildAbout(context),
                          ],
                        ),
                      ]))
                    ])))));
  }

  Widget buildAbout(BuildContext context) => SimpleSettingsTile(
        title: "About ?",
        subtitle: "",
        leading: Image.asset(
          "assets/icons/about.png",
          width: 20,
          height: 20,
        ),
        onTap: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => const AboutMe()));
        },
      );
  Widget buildEmailSuport(BuildContext context) => SimpleSettingsTile(
        title: "Suport Email",
        subtitle: "",
        leading: Image.asset(
          "assets/icons/about_gmail.png",
          width: 20,
          height: 20,
        ),
        onTap: () {
          _launchURLEmail();
        },
      );
  Widget buildWaSuport(BuildContext context) => SimpleSettingsTile(
        title: "Wa Suport",
        subtitle: "",
        leading: Image.asset(
          "assets/icons/wa_suport.png",
          width: 20,
          height: 20,
        ),
        onTap: () {
          _launchURLWa();
        },
      );
}
