import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import '../../home/views/home.dart';
import '../../more/models/more_models.dart';
import '../../more/providers/more_providers.dart';
import 'styles.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

///views ooboarding
class _OnboardingScreenState extends State<OnboardingScreen> {
  final GetInfoSekolah getInfoSekolah = GetInfoSekolah();
  final int _numPages = 3;
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < _numPages; i++) {
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      height: 8.0,
      width: isActive ? 24.0 : 16.0,
      decoration: BoxDecoration(
        color: isActive ? Colors.white : const Color(0xFF7B51D3),
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.1, 0.4, 0.7, 0.9],
                  colors: [
                    Color(0xFF3594DD),
                    Color(0xFF4563DB),
                    Color(0xFF5036D5),
                    Color(0xFF5B16D0),
                  ],
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).padding.top + 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => Navigator.pushReplacement(
                            context,
                            PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondartyAnimation) =>
                                        const Home())),
                        child: const Text(
                          'Skip',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height - 220,
                      child: PageView(
                        physics: const ClampingScrollPhysics(),
                        controller: _pageController,
                        onPageChanged: (int page) {
                          setState(() {
                            _currentPage = page;
                          });
                        },
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: FutureBuilder<InfoSekolah?>(
                                future: getInfoSekolah.getInfo(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        const Center(
                                          child: Image(
                                            image: AssetImage(
                                              'assets/images/ki-hajar-dewantara-png-4.png',
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 20.0),
                                        Text(
                                          snapshot.data!.sistem,
                                          style: kTitleStyle,
                                        ),
                                        const SizedBox(height: 15.0),
                                        Text(
                                          snapshot.data!.descLogin,
                                          maxLines: 10,
                                          style: kSubtitleStyle,
                                        ),
                                      ],
                                    );
                                  } else {
                                    return Container();
                                  }
                                }),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const <Widget>[
                                Center(
                                  child: Image(
                                    image: AssetImage(
                                      'assets/images/mobile_guy.png',
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20.0),
                                Text(
                                  'Belajar Bersama Guru Kelas kamu \nKapan saja Dimana Saja !',
                                  style: kTitleStyle,
                                ),
                                SizedBox(height: 15.0),
                                Text(
                                  'Kerjakan tugas sekolah kapansaja dimana saja degan platforms Aplikasi Media Sosial Sekolah ',
                                  maxLines: 5,
                                  style: kSubtitleStyle,
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const <Widget>[
                                Center(
                                  child: Image(
                                    image: AssetImage(
                                      'assets/images/119-working1.png',
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20.0),
                                Text(
                                  'Intraksi Guru Dan siswa\nTanya Guru Kapan saja !',
                                  style: kTitleStyle,
                                ),
                                SizedBox(height: 15.0),
                                Text(
                                  'Belajar Jadi lebih Interaktif ! Pertanyaanmu dapat di jawab langsung oleh guru Mata pelajaran Kamu ',
                                  maxLines: 5,
                                  style: kSubtitleStyle,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: _buildPageIndicator(),
                    ),
                    _currentPage != _numPages - 1
                        ? Expanded(
                            child: Align(
                              alignment: FractionalOffset.bottomRight,
                              child: TextButton(
                                onPressed: () {
                                  _pageController.nextPage(
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.ease,
                                  );
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: const <Widget>[
                                    Text(
                                      'Next',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16.0,
                                      ),
                                    ),
                                    SizedBox(width: 5.0),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      color: Colors.white,
                                      size: 16.0,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        : const Text(''),
                  ],
                ),
              ),
            ),
            Positioned(
                top: MediaQuery.of(context).size.height - 120,
                left: 0,
                right: 150,
                child: Container(
                  width: 207,
                  height: 246,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage('assets/images/bg-login.png'))),
                ))
          ],
        ),
      ),
      bottomSheet: _currentPage == _numPages - 1
          ? Container(
              height: 120.0,
              width: double.infinity,
              color: Colors.white,
              child: GestureDetector(
                // ignore: avoid_print
                onTap: () {
                  final box = GetStorage();
                  if (box.read('skipIntro') != null) {
                    box.remove('skipIntro');
                  }
                  box.write('skipIntro', true);
                  Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondartyAnimation) =>
                                  const Home()));
                },
                child: const Center(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 30.0),
                    child: Text(
                      'Mulai Sekarang',
                      style: TextStyle(
                        color: Color(0xFF5B16D0),
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            )
          : const Text(''),
    );
  }
}
