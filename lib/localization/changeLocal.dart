import 'dart:ui';


import 'package:get/get.dart';
import 'package:spooding_exp_ios/localization/services.dart';

class LocaleController extends GetxController {
  Locale? language;
  MyServices myServices = Get.put(MyServices());

  changeLange(String langCode) {
    Locale locale = Locale(langCode);
    myServices.sharedPreferences.setString('lang', langCode);
    Get.updateLocale(locale);
    update();
  }


  @override
  void onInit() {
    if (myServices.sharedPreferences.getString('lang') == 'fr') {
      language = Locale('fr');
    } else if (myServices.sharedPreferences.getString('lang') == 'en') {
      language = Locale('en');
    } else if (myServices.sharedPreferences.getString('lang') == 'ar') {
      language = Locale('ar');
    } else {
      language = Locale(Get.deviceLocale!.languageCode);
    }
    super.onInit();
  }
}
