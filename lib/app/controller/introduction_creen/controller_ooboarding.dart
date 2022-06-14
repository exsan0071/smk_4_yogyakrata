import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
///controller oobording page
class OoboardingController extends GetxController {
  
  var isSkipIntro = false.obs;
  var isAuth = false.obs;
  Future<void> firstInitialized() async {
    await skipIntro().then((value) {
      if (value) {
        isSkipIntro.value = true;
      }
    });
  }

  Future<bool> skipIntro() async {
    // kita akan mengubah isSkipIntro => true
    final box = GetStorage();
    if (box.read('skipIntro') != null || box.read('skipIntro') == true) {
      return true;
    }
    return false;
  }
}