import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../controller/tugas_controller.dart';
import '../models/detail_tugas.dart';
import '../providers/tugas_providers.dart';
import '../widget/body_tugas_detail.dart';
import '../widget/title_tugas_detail.dart';

class DetailTugasSelesai extends StatefulWidget {
  const DetailTugasSelesai({Key? key}) : super(key: key);

  @override
  State<DetailTugasSelesai> createState() => _DetailTugasSelesaiState();
}

class _DetailTugasSelesaiState extends State<DetailTugasSelesai> {
  final TugasProvider tugasProvider = TugasProvider();
  final TugasController tugasC = Get.put(TugasController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Detail Tugas"),
        ),
        body: FutureBuilder<TugasDetail?>(
            future: tugasProvider.getDetailTugas(tugasC.id.toString()),
            builder: (BuildContext context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: Lottie.asset(
                    'assets/images/98586-loading-oneplace.json',
                    width: 200,
                    height: 200,
                    fit: BoxFit.fill,
                  ),
                );
              } else {
                if (snapshot.hasData) {
                  final data1 = snapshot.data!.data;
                  return ListView(children: [
                    TugasAktif(data1: data1),
                    BodyTugasAktif(
                      data1: data1,
                      id1: tugasC.id.toString(),
                    )
                  ]);
                } else {
                  return Center(
                      child: Lottie.asset(
                    'assets/icons/-no-internet-connection.json',
                  ));
                }
              }
            }));
  }
}
