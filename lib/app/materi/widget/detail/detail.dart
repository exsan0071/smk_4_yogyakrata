import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../controller/materi.dart';
import '../../../materi/models/detail/detail.dart';
import '../../../materi/provider/data_materi.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class Detail extends StatefulWidget {
  const Detail({Key? key}) : super(key: key);

  @override
  _DetailState createState() => _DetailState();
}

class _DetailState extends State<Detail> with TickerProviderStateMixin {
  final GetDataDetailMateri getDataDetailMateri = GetDataDetailMateri();
  final MateriController materiC = Get.put(MateriController());
  late TabController _tabController;
  late YoutubePlayerController _controller;
  late TextEditingController _idController;
  late TextEditingController _seekToController;

  bool _muted = false;
  bool _isPlayerReady = false;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: materiC.dataUrl.toString(),
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: true,
      ),
    )..addListener(listener);
    _tabController = TabController(vsync: this, length: 2);
    _idController = TextEditingController();
    _seekToController = TextEditingController();
  }

  void listener() {
    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
      setState(() {});
    }
  }

  @override
  void deactivate() {
    // Pauses video while navigating to next page.
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();
    _idController.dispose();
    _seekToController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    return YoutubePlayerBuilder(
      onExitFullScreen: () {
        SystemChrome.setPreferredOrientations(DeviceOrientation.values);
      },
      player: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Colors.blueAccent,
        topActions: <Widget>[
          const SizedBox(width: 8.0),
          Expanded(
            child: Text(
              materiC.judul.toString(),
              style: GoogleFonts.roboto(
                color: Colors.white,
                fontSize: 18.0,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.settings,
              color: Colors.white,
              size: 25.0,
            ),
            onPressed: () {
              log('Settings Tapped!');
            },
          ),
        ],
        onReady: () {
          _isPlayerReady = true;
        },
      ),
      builder: (context, player) => Scaffold(
        appBar: AppBar(
            title: Center(
              child: Column(
                children: [
                  Text(
                    materiC.judul.toString(),
                    style: GoogleFonts.roboto(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                  Text(
                    'X IPS 1',
                    style:
                        GoogleFonts.roboto(color: Colors.white, fontSize: 13),
                  )
                ],
              ),
            ),
            actions: [
              GestureDetector(
                onTap: () {},
                child: Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20)),
                  child: const Icon(
                    Icons.search,
                    size: 20,
                    color: Colors.black,
                  ),
                ),
              )
            ]),
        body: ListView(
          children: [
            player,
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        children: [
                          TextButton.icon(
                              onPressed: () {},
                              icon: Image.asset(
                                'assets/icons/like_vedeo.png',
                                width: 20,
                                height: 20,
                              ),
                              label: Text("(1)", style: GoogleFonts.roboto())),
                          TextButton.icon(
                              onPressed: () {},
                              icon: Image.asset(
                                'assets/icons/dont-like_vedeo.png',
                                width: 20,
                                height: 20,
                              ),
                              label: Text("(0)", style: GoogleFonts.roboto())),
                        ],
                      ),
                      IconButton(
                        icon: Icon(
                          _controller.value.isPlaying
                              ? Icons.pause
                              : Icons.play_arrow,
                        ),
                        onPressed: _isPlayerReady
                            ? () {
                                _controller.value.isPlaying
                                    ? _controller.pause()
                                    : _controller.play();
                                setState(() {});
                              }
                            : null,
                      ),
                      IconButton(
                        icon: Icon(_muted ? Icons.volume_off : Icons.volume_up),
                        onPressed: _isPlayerReady
                            ? () {
                                _muted
                                    ? _controller.unMute()
                                    : _controller.mute();
                                setState(() {
                                  _muted = !_muted;
                                });
                              }
                            : null,
                      ),
                      FullScreenButton(
                        controller: _controller,
                        color: Colors.blueAccent,
                      ),
                    ],
                  ),
                ),
                Container(
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20))),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: TabBar(
                          labelPadding:
                              const EdgeInsets.only(left: 20, right: 20),
                          controller: _tabController,
                          labelColor: Colors.blue,
                          unselectedLabelColor: Colors.grey,
                          isScrollable: true,
                          labelStyle: GoogleFonts.roboto(
                              fontWeight: FontWeight.bold, fontSize: 14),
                          indicatorSize: TabBarIndicatorSize.label,
                          tabs: const [
                            Tab(text: "Keterangan"),
                            Tab(text: "Transkip"),
                          ]),
                    )),
                SizedBox(
                    height: 500,
                    width: double.maxFinite,
                    child: TabBarView(controller: _tabController, children: [
                      Container(
                        margin: const EdgeInsets.all(10),
                        height: 200,
                        color: Colors.white,
                        child: FutureBuilder<DetailMateri?>(
                            future: getDataDetailMateri
                                .getDataDetailMateri(materiC.idD.toString()),
                            builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  final data = snapshot.data!;
                                  return SingleChildScrollView(
                                    child: Container(
                                      margin: const EdgeInsets.all(5),
                                      width: _width,
                                      child: Center(
                                        child: Text(data.detail),
                                      ),
                                    ),
                                  );
                                } else {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                }
                              }
                            ),
                      ),
                      Container(
                          margin: const EdgeInsets.all(10),
                          height: 200,
                          color: Colors.white,
                          child: Center(
                            child: Text("Belum Ada Traskip",
                                style: GoogleFonts.roboto(
                                    fontWeight: FontWeight.bold)),
                          ))
                    ]))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
