import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spooding_exp_ios/20/express.dart';
import 'package:spooding_exp_ios/20/test/testController.dart';
import 'package:spooding_exp_ios/controller.dart';
import 'package:spooding_exp_ios/localization/changeLocal.dart';
import 'package:spooding_exp_ios/localization/localization.dart';
import 'package:spooding_exp_ios/localization/services.dart';
import 'package:spooding_exp_ios/splashScreen.dart';
import 'package:spooding_exp_ios/videScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initialServices();

  Get.put(LoginController(), permanent: true);
  Get.put(CategoryController(), permanent: true);
  Get.put(CartController(), permanent: true);
  Get.put(LocationController(), permanent: true);
  Get.put(ToutController(), permanent: true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    LocaleController languageController = Get.put(LocaleController());
    return GetMaterialApp(
      translations: MyTranslation(),
      debugShowCheckedModeBanner: false,
      locale: languageController.language,
      title: 'SpooDing Express',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 255, 183, 0),
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        useMaterial3: true,
      ),
      initialRoute: '/splash',
      getPages: [
        GetPage(name: '/splash', page: () => SplashScreen()),
        GetPage(name: '/home', page: () => MenuScreen()),
        GetPage(name: '/check-location', page: () => CheckLocationScreen()),
      ],
    );
  }
}
