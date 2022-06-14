import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/komentar.dart';
import '../models/models.dart';
import '../models/privasi_status.dart';

class StatusController extends GetxController {
  ///list data status
  List<DataStatus> listStatus = [];
  ///list data privasi
  List<ItemsPrivasi> listItems = [];
  ///list data komentar
  List<DataKomen> listKomen = [];
  int? expended;
  String? idK;
  var isLoading = false;
  String? selecItems;
  final TextEditingController data = TextEditingController(text: '');
  final TextEditingController komen = TextEditingController(text: '');
}
