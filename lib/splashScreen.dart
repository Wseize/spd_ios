import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spooding_exp_ios/20/express.dart';
import 'package:spooding_exp_ios/20/test/testController.dart';
import 'package:spooding_exp_ios/controller.dart';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({Key? key}) : super(key: key);

//   @override
//   _SplashScreenState createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen>
//     with SingleTickerProviderStateMixin {
//   late final AnimationController _controller;
//   late final Animation<double> _animation;
//   final CategoryController categoryController = Get.put(CategoryController());
//   final ToutController toutController = Get.put(ToutController());

//   bool hasInternet = true;

//   @override
//   void initState() {
//     super.initState();

//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 2800),
//     );

//     _animation = CurvedAnimation(
//       parent: _controller,
//       curve: Curves.easeOutCubic,
//     );

//     _loadDataAndNavigate();
//   }

//   Future<void> _loadDataAndNavigate() async {
//     bool connected = await _checkConnection();
//     if (!connected) {
//       setState(() {
//         hasInternet = false;
//       });
//       return;
//     }

//     try {
//       await Future.wait([
//         categoryController.fetchStoresBasic(),
//         toutController.fetchRecommendedItems(),
//         categoryController.fetchPublicities(),
//         toutController.fetchDiscountItems(),
//         _controller.forward(),
//       ]);
//       if (mounted) Get.offNamed('/home');
//     } catch (e) {
//       debugPrint('Error loading data: $e');
//     }
//   }

//   Future<bool> _checkConnection() async {
//     try {
//       final result = await InternetAddress.lookup('google.com');
//       return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
//     } catch (_) {
//       return false;
//     }
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     return Scaffold(
//       backgroundColor: theme.colorScheme.background,
//       body: Center(
//         child: hasInternet
//             ? FadeTransition(
//                 opacity: _animation,
//                 child: ScaleTransition(
//                   scale: _animation,
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       ClipOval(
//                         child: Image.asset(
//                           'images/splash_logo.png',
//                           fit: BoxFit.cover,
//                           width: 180,
//                           height: 180,
//                         ),
//                       ),
//                       const SizedBox(height: 24),
//                       Obx(() => categoryController.isLoading.value
//                           ? const SizedBox(
//                               width: 180,
//                               child: LinearProgressIndicator(
//                                 color: Color(0xFFFF7043),
//                                 minHeight: 4,
//                               ),
//                             )
//                           : const SizedBox.shrink()),
//                     ],
//                   ),
//                 ),
//               )
//             : Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(Icons.wifi_off, size: 80, color: Colors.red),
//                   const SizedBox(height: 20),
//                   Text(
//                     "Pas de connexion internet",
//                     style: TextStyle(fontSize: 18, color: Colors.grey[700]),
//                   ),
//                   const SizedBox(height: 20),
//                   ElevatedButton(
//                     onPressed: () {
//                       setState(() {
//                         hasInternet = true;
//                       });
//                       _loadDataAndNavigate();
//                     },
//                     child: const Text("Réessayer"),
//                   ),
//                 ],
//               ),
//       ),
//     );
//   }
// }

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final CategoryController categoryController = Get.put(CategoryController());
  final ToutController toutController = Get.put(ToutController());

  bool hasInternet = true;

  @override
  void initState() {
    super.initState();
    _loadDataAndNavigate();
  }

  Future<void> _loadDataAndNavigate() async {
    bool connected = await _checkConnection();
    if (!connected) {
      setState(() {
        hasInternet = false;
      });
      return;
    }

    try {
      await Future.wait([
        categoryController.fetchStoresBasic(),
        toutController.fetchRecommendedItems(),
        categoryController.fetchPublicities(),
        toutController.fetchDiscountItems(),
        categoryController.fetchUserProfile()
      ]);
      if (mounted) Get.offNamed('/home');
    } catch (e) {
      debugPrint('Error loading data: $e');
    }
  }

  Future<bool> _checkConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: Center(
        child: hasInternet
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ClipOval(
                    child: Image.asset(
                      'images/splash_logo.png',
                      fit: BoxFit.cover,
                      width: 180,
                      height: 180,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Obx(() => categoryController.isLoading.value
                      ? const SizedBox(
                          width: 180,
                          child: LinearProgressIndicator(
                            color: Color(0xFFFF7043),
                            minHeight: 4,
                          ),
                        )
                      : const SizedBox.shrink()),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.wifi_off, size: 80, color: Colors.red),
                  const SizedBox(height: 20),
                  Text(
                    "Pas de connexion internet",
                    style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        hasInternet = true;
                      });
                      _loadDataAndNavigate();
                    },
                    child: const Text("Réessayer"),
                  ),
                ],
              ),
      ),
    );
  }
}

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({Key? key}) : super(key: key);

//   @override
//   _SplashScreenState createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen>
//     with SingleTickerProviderStateMixin {
//   late final AnimationController _controller;
//   late final Animation<double> _animation;
//   final CategoryController categoryController = Get.put(CategoryController());
//   final ToutController toutController = Get.put(ToutController());

//   @override
//   void initState() {
//     super.initState();

//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 2800),
//     );

//     _animation = CurvedAnimation(
//       parent: _controller,
//       curve: Curves.easeOutCubic,
//     );

//     _controller.forward();

//     _loadDataAndNavigate();
//   }

//   Future<void> _loadDataAndNavigate() async {
//     try {
//       await categoryController.fetchTypeCategories();
//       await toutController.fetchRecommendedItems();
//       if (mounted) Get.offNamed('/home');
//     } catch (e) {
//       debugPrint('Error loading data: $e');
//     }
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     return Scaffold(
//       backgroundColor: theme.colorScheme.background,
//       body: Center(
//         child: FadeTransition(
//           opacity: _animation,
//           child: ScaleTransition(
//             scale: _animation,
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 ClipOval(
//                   child: Image.asset(
//                     'images/splash_logo.png',
//                     fit: BoxFit.cover,
//                     width: 180,
//                     height: 180,
//                   ),
//                 ),
//                 const SizedBox(height: 24),
//                 Obx(() => categoryController.isLoadingType.value
//                     ? const SizedBox(
//                         width: 180,
//                         child: LinearProgressIndicator(
//                           color: Color(0xFFFF7043),
//                           minHeight: 4,
//                         ),
//                       )
//                     : const SizedBox.shrink()),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
