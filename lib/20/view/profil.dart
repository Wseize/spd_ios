// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spooding_exp_ios/20/test/testController.dart';
import 'package:spooding_exp_ios/20/view/changePassword.dart';
import 'package:spooding_exp_ios/20/view/createFormDelivery.dart';
import 'package:spooding_exp_ios/20/view/createFormStore.dart';
import 'package:spooding_exp_ios/20/view/loginScreen.dart';
import 'package:spooding_exp_ios/20/view/wallet/carnet.dart';
import 'package:spooding_exp_ios/20/view/wallet/view.dart';
import 'package:spooding_exp_ios/controller.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  final CategoryController categoryController = Get.put(CategoryController());
  final LoginController loginController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    categoryController.fetchUserProfile();
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: GestureDetector(
          child: Image.asset('images/logo2.png', height: 125, width: 125),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Obx(() {
              if (categoryController.isLoading.value) {
                // Show loading indicator when data is still being fetched
                return Center(child: CircularProgressIndicator());
              }

              // Check if the user is authenticated
              return loginController.isAuthenticated.value
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.orange.shade400,
                              child: Icon(
                                Icons.account_circle,
                                size: 130,
                                color: Colors.white,
                              ),
                              radius: 70,
                            ),
                            SizedBox(height: 5),
                            // Show username
                            Text(
                              categoryController.userProfile.value.username,
                              style: TextStyle(fontSize: 22),
                            ),
                            SizedBox(height: 20),
                            ListTile(
                              title: Text(
                                categoryController.userProfile.value.username,
                              ),
                              leading: const Icon(Icons.mobile_friendly),
                            ),
                            ListTile(
                              title: const Text('My Wallet'),
                              leading: const Icon(Icons.wallet),
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => WalletLauncher(),
                                  ),
                                );
                              },
                            ),
                            ListTile(
                              title: const Text('Mes Carnets'),
                              leading: const Icon(Icons.card_giftcard),
                              onTap: () async {
                                final prefs =
                                    await SharedPreferences.getInstance();
                                final token = prefs.getString('token');

                                String userToken = token!;
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        CarnetScreen(userToken: userToken),
                                  ),
                                );
                              },
                            ),
                            ListTile(
                              title: const Text('Change password'),
                              leading: const Icon(Icons.password),
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ChangePasswordScreen(),
                                  ),
                                );
                              },
                            ),
                            ListTile(
                              title: const Text('Delete Account'),
                              leading: const Icon(Icons.delete),
                              onTap: () {
                                // Handle password change
                              },
                            ),
                          ],
                        ),
                      ),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'images/splash_logo.png',
                          height: 250,
                          width: 250,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GestureDetector(
                              onTap: () {
                                // Navigator.of(context).push(
                                //   MaterialPageRoute(
                                //       builder: (context) => SignUp()),
                                // );
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.orange.shade400,
                                      Colors.orange.shade200,
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.app_registration,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'Sign Up',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => LoginScreen(),
                                  ),
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.orange.shade400,
                                      Colors.orange.shade200,
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.login, color: Colors.white),
                                    SizedBox(width: 8),
                                    Text(
                                      'Login',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
            }),
            SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CreateFormDelivery()),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1.0),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'I want to be a delivery person in SpooDing Express',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CreateFormStore()),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1.0),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('I want to be a shop on SpooDing Express'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
