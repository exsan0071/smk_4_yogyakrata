import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
//conetctivitiy cheek
class ConnectivityProfider with ChangeNotifier {
  final Connectivity _connectivity = Connectivity();
  bool? isOnline;
  strartMonitiring() async {
    await _checkConnectivityState();
    _connectivity.onConnectivityChanged.listen((result) async {
      if (result == ConnectivityResult.none) {
        isOnline = false;
        notifyListeners();
      } else {
        await _updateConectivtyStaus().then((bool? isConnected) {
          isOnline = isConnected;
          notifyListeners();
        });
      }
    });
  }

  Future<void> _checkConnectivityState() async {
    final ConnectivityResult status = await Connectivity().checkConnectivity();
    try {
      if (status == ConnectivityResult.none) {
        isOnline = false;
        notifyListeners();
      } else {
        isOnline = true;
        notifyListeners();
      }
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print('PlatformException:' + e.toString());
      }
    }
  }

  Future<bool?> _updateConectivtyStaus() async {
    bool? isConnected;
    try {
      final List<InternetAddress> result =
          await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        isConnected = true;
      }
    } on SocketException catch (_) {
      isConnected = true;
    }
    return isConnected;
  }
}
