import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../more/views/privacy.dart';
import '../../login/views/login.dart';
import '../../more/views/settings_umum.dart';
import '../../profile/models/profile.dart';
import '../../profile/provider/profile.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../profile/views/profile.dart';
import 'about.dart';

class MorePage extends StatefulWidget {
  const MorePage({Key? key}) : super(key: key);
  @override
  _MorePageState createState() => _MorePageState();
}

class _MorePageState extends State<MorePage> {
  final GetDataProflie proflie = GetDataProflie();

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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lainnya"),
      ),
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder<Profile?>(
                future: proflie.getDataUserProfile(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container(
                      width: _width,
                      height: 260,
                      color: Colors.white,
                      child: Column(
                        children: [
                          Container(
                            width: _width,
                            padding: const EdgeInsets.only(top: 20),
                            child: const CircleAvatar(
                              radius: 53,
                              backgroundColor: Colors.black,
                              child: CircleAvatar(
                                radius: 50,
                                backgroundColor: Colors.white,
                                child: CircleAvatar(
                                  radius: 57,
                                  backgroundImage: AssetImage(
                                      'assets/images/avatar-akun.png'),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text('-----',
                                style: GoogleFonts.roboto(
                                    fontSize: 20,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)),
                          ),
                          Text('-----',
                              style: GoogleFonts.roboto(
                                  fontSize: 15,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.bold)),
                          Container(
                            width: 135,
                            padding: const EdgeInsets.only(top: 10),
                            child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  shape: const StadiumBorder(),
                                  primary:
                                      const Color.fromARGB(255, 16, 92, 99),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("My Account",
                                        style: GoogleFonts.roboto(
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)),
                                    const Icon(
                                      Icons.arrow_forward_ios_outlined,
                                      size: 18,
                                    )
                                  ],
                                )),
                          )
                        ],
                      ),
                    );
                  } else {
                    if (snapshot.hasData) {
                      return Container(
                        width: _width,
                        height: 260,
                        color: Colors.white,
                        child: Column(
                          children: [
                            Container(
                              width: _width,
                              padding: const EdgeInsets.only(top: 20),
                              child: CircleAvatar(
                                radius: 53,
                                backgroundColor: Colors.black,
                                child: CircleAvatar(
                                  radius: 50,
                                  backgroundColor: Colors.white,
                                  child: CircleAvatar(
                                    radius: 57,
                                    backgroundImage: snapshot.data!.photo !=
                                            "NULL"
                                        ? NetworkImage(snapshot.data!.photo)
                                        : const NetworkImage(
                                            'https://sma1contoh.sekolahkita.net/assets/images/profile/thumb/1632116632-pria-min_thumb.png'),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Text(snapshot.data!.namasiswa,
                                  style: GoogleFonts.roboto(
                                      fontSize: 20,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold)),
                            ),
                            Text(snapshot.data!.nis,
                                style: GoogleFonts.roboto(
                                    fontSize: 15,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.bold)),
                            Container(
                              width: 135,
                              padding: const EdgeInsets.only(top: 10),
                              child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const ProfilePage()));
                                  },
                                  style: ElevatedButton.styleFrom(
                                    shape: const StadiumBorder(),
                                    primary:
                                        const Color.fromARGB(255, 16, 92, 99),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("My Account",
                                          style: GoogleFonts.roboto(
                                              fontSize: 15,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold)),
                                      const Icon(
                                        Icons.arrow_forward_ios_outlined,
                                        size: 18,
                                      )
                                    ],
                                  )),
                            )
                          ],
                        ),
                      );
                    } else {
                      return Container(
                        width: _width,
                        height: 260,
                        color: Colors.white,
                        child: Column(
                          children: [
                            Container(
                              width: _width,
                              padding: const EdgeInsets.only(top: 20),
                              child: const CircleAvatar(
                                radius: 53,
                                backgroundColor: Colors.black,
                                child: CircleAvatar(
                                  radius: 50,
                                  backgroundColor: Colors.white,
                                  child: CircleAvatar(
                                    radius: 57,
                                    backgroundImage: NetworkImage(
                                        'https://sma1contoh.sekolahkita.net/assets/images/avatar-akun.png'),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Text('-----',
                                  style: GoogleFonts.roboto(
                                      fontSize: 20,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold)),
                            ),
                            Text('-----',
                                style: GoogleFonts.roboto(
                                    fontSize: 15,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.bold)),
                            Container(
                              width: 135,
                              padding: const EdgeInsets.only(top: 10),
                              child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const ProfilePage()));
                                  },
                                  style: ElevatedButton.styleFrom(
                                    shape: const StadiumBorder(),
                                    primary:
                                        const Color.fromARGB(255, 16, 92, 99),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("My Account",
                                          style: GoogleFonts.roboto(
                                              fontSize: 15,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold)),
                                      const Icon(
                                        Icons.arrow_forward_ios_outlined,
                                        size: 18,
                                      )
                                    ],
                                  )),
                            )
                          ],
                        ),
                      );
                    }
                  }
                }),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  child: Text("Settings",
                      style: GoogleFonts.roboto(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            Container(
                width: _width,
                height: 200,
                color: Colors.white,
                child: Column(children: [
                  buildSetings(context),
                  buildResetPassword(context),
                  logoutSettings(context),
                ])),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  child: Text("Butuh Bantuan ?",
                      style: GoogleFonts.roboto(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            Container(
                width: _width,
                height: 200,
                color: Colors.white,
                child: Column(children: [
                  buildEmailSuport(context),
                  buildWaSuport(context),
                  buildAbout(context),
                  buildPrivasi(context),
                ])),
          ],
        ),
      ),
    );
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
  Widget buildPrivasi(BuildContext context) => SimpleSettingsTile(
        title: "Kebijakan Privasi",
        subtitle: "",
        leading: Image.asset(
          "assets/icons/privacy.png",
          width: 20,
          height: 20,
        ),
        onTap: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => const Privacy()));
        },
      );
  Widget buildSetings(BuildContext context) => SimpleSettingsTile(
        title: "Umum",
        subtitle: "",
        leading: Image.asset(
          "assets/icons/settings.png",
          width: 20,
          height: 20,
        ),
        onTap: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const SetingUmum()));
        },
      );
  Widget buildResetPassword(BuildContext context) => SimpleSettingsTile(
        title: "Ubah Password",
        subtitle: "",
        leading: Image.asset(
          "assets/icons/ubah_passwort.png",
          width: 20,
          height: 20,
        ),
        onTap: () {},
      );
  Widget logoutSettings(BuildContext context) => SimpleSettingsTile(
        title: "Log Out",
        subtitle: "",
        leading: Image.asset(
          "assets/icons/logout.png",
          width: 20,
          height: 20,
        ),
        onTap: () async {
          SharedPreferences delToken = await SharedPreferences.getInstance();
          await delToken.clear();
          Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                  pageBuilder: (context, animation, secondartyAnimation) =>
                      const Login()));
        },
      );
}
