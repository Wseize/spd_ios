// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spooding_exp_ios/20/test/testController.dart';
import 'package:spooding_exp_ios/20/test/testStore.dart';
import 'package:spooding_exp_ios/20/view/loginScreen.dart';
import 'package:spooding_exp_ios/controller.dart';

class Favorite extends StatelessWidget {
  final CategoryController categoryController = Get.put(CategoryController());
  final LoginController loginController = Get.put(LoginController());
  Favorite({super.key});

  @override
  Widget build(BuildContext context) {
    // categoryController.fetchFavoriteVendors();
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Image.asset('images/logo2.png', height: 125, width: 125),
        backgroundColor: Colors.white,
      ),
      body: Obx(() {
        if (categoryController.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(color: Colors.orange.shade400),
          );
        }
        return loginController.isAuthenticated.value
            ? categoryController.favoriteVendors.isEmpty
                  ? Center(child: Text('No shops in your favorites yet.'))
                  : Padding(
                      padding: const EdgeInsets.all(10),
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemCount: categoryController.favoriteVendors.length,
                        itemBuilder: (context, index) {
                          var store = categoryController.favoriteVendors[index];
                          return GestureDetector(
                            onTap: () {
                              Get.to(
                                () => StoreDetailScreen(storeId: store.id),
                              );
                            },
                            child: Stack(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey,
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  width: MediaQuery.of(context).size.width / 2,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(height: 15),
                                      CircleAvatar(
                                        radius: 50,
                                        backgroundImage:
                                            CachedNetworkImageProvider(
                                              store.image,
                                            ),
                                      ),
                                      SizedBox(height: 5),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            store.name,
                                            style: TextStyle(fontSize: 15),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    )
            : LoginScreen();
        // Column(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children: [
        //       Image.asset(
        //         'images/splash_logo.png',
        //         height: 250,
        //         width: 250,
        //       ),
        //       Row(
        //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //         children: [
        //           GestureDetector(
        //             onTap: () {
        //               Navigator.of(context).push(MaterialPageRoute(
        //                   builder: (context) => SignUp()));
        //             },
        //             child: Container(
        //               padding: EdgeInsets.symmetric(
        //                   horizontal: 20, vertical: 10),
        //               decoration: BoxDecoration(
        //                 gradient: LinearGradient(
        //                   colors: [
        //                     Colors.orange.shade400,
        //                     Colors.orange.shade200,
        //                   ],
        //                   begin: Alignment.topLeft,
        //                   end: Alignment.bottomRight,
        //                 ),
        //                 borderRadius: BorderRadius.circular(10),
        //               ),
        //               child: Row(
        //                 mainAxisAlignment: MainAxisAlignment.center,
        //                 children: [
        //                   Icon(Icons.app_registration,
        //                       color: Colors.white),
        //                   SizedBox(width: 8),
        //                   Text(
        //                     'Sign Up',
        //                     style: TextStyle(
        //                       color: Colors.white,
        //                       fontSize: 16,
        //                     ),
        //                   ),
        //                 ],
        //               ),
        //             ),
        //           ),
        //           GestureDetector(
        //             onTap: () {
        //               Navigator.of(context).push(
        //                 MaterialPageRoute(
        //                     builder: (context) => LoginScreen()),
        //               );
        //             },
        //             child: Container(
        //               padding: EdgeInsets.symmetric(
        //                   horizontal: 20, vertical: 10),
        //               decoration: BoxDecoration(
        //                 gradient: LinearGradient(
        //                   colors: [
        //                     Colors.orange.shade400,
        //                     Colors.orange.shade200,
        //                   ],
        //                   begin: Alignment.topLeft,
        //                   end: Alignment.bottomRight,
        //                 ),
        //                 borderRadius: BorderRadius.circular(10),
        //               ),
        //               child: Row(
        //                 mainAxisAlignment: MainAxisAlignment.center,
        //                 children: [
        //                   Icon(Icons.login, color: Colors.white),
        //                   SizedBox(width: 8),
        //                   Text(
        //                     'Login',
        //                     style: TextStyle(
        //                       color: Colors.white,
        //                       fontSize: 16,
        //                     ),
        //                   ),
        //                 ],
        //               ),
        //             ),
        //           ),
        //         ],
        //       ),
        //     ],
        //   );
      }),
    );
  }
}
