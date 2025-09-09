import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spooding_exp_ios/20/express.dart';
import 'package:spooding_exp_ios/20/test/testController.dart';
import 'package:spooding_exp_ios/20/view/background.dart';
import 'package:spooding_exp_ios/20/view/resetpassword.dart';
import 'package:spooding_exp_ios/20/view/signUpScreen.dart' show SignUp, SignUpOrder;
import 'package:spooding_exp_ios/controller.dart';

class LoginScreen extends StatelessWidget {
  final LoginController loginController = Get.put(LoginController());
  final LocationController locationController = Get.put(LocationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Background(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: loginController.formstate,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: const TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                    text: 'Spooding',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 30,
                                      color: Colors.black,
                                    ),
                                  ),
                                  TextSpan(
                                    text: ' Express',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 20,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              '6'.tr,
                              style: const TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 40),
                      TextFormField(
                        controller: loginController.usernameController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          labelText: 'Phone Number',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your Phone number';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      Obx(() {
                        return TextFormField(
                          controller: loginController.passwordController,
                          obscureText: !loginController.isPasswordVisible.value,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                loginController.isPasswordVisible.value
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                loginController.isPasswordVisible.value =
                                    !loginController.isPasswordVisible.value;
                              },
                            ),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                        );
                      }),
                      SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        // PhoneInputScreen(),
                                        SignUp(),
                                  ),
                                );
                              },
                              child: Text(
                                'create account'.toUpperCase(),
                                style: TextStyle(color: Colors.orange.shade400),
                              ),
                            ),
                            Container(
                              color: Colors.black54,
                              width: 2,
                              height: 20,
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ResetPasswordScreen(),
                                  ),
                                );
                              },
                              child: Text('Forget Password'.toUpperCase()),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Obx(() {
                        return loginController.isLoading.value
                            ? CircularProgressIndicator()
                            : ElevatedButton(
                                child: Text("Login"),
                                onPressed: () async {
                                  String username = loginController
                                      .usernameController
                                      .text
                                      .trim();
                                  String password = loginController
                                      .passwordController
                                      .text
                                      .trim();

                                  bool isLoggedIn = await loginController
                                      .loginUser(username, password);
                                  if (isLoggedIn) {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return Dialog(
                                          child: Container(
                                            height: 100,
                                            width: 200,
                                            child: Center(
                                              child: Text('Logged'),
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => MenuScreen(
                                         
                                        ),
                                      ),
                                      (Route<dynamic> route) => false,
                                    );
                                  } else {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return Dialog(
                                          child: Container(
                                            height: 100,
                                            width: 200,
                                            child: Center(
                                              child: Text('Login failed'),
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  }
                                },
                              );
                      }),
                    ],
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

class LoginOrderScreen extends StatelessWidget {
  final LoginController loginController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Login',
          style: TextStyle(
            fontSize: 22,
            color: Colors.orange.shade400,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Stack(
        children: [
          Background(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: loginController.formstate,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: const TextSpan(
                              children: <TextSpan>[
                                TextSpan(
                                  text: 'Spooding',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 30,
                                    color: Colors.black,
                                  ),
                                ),
                                TextSpan(
                                  text: ' Express',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 20,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '6'.tr,
                            style: const TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 40),
                    TextFormField(
                      controller: loginController.usernameController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: 'Phone Number',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your email';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    Obx(() {
                      return TextFormField(
                        controller: loginController.passwordController,
                        obscureText: !loginController.isPasswordVisible.value,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              loginController.isPasswordVisible.value
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              loginController.isPasswordVisible.value =
                                  !loginController.isPasswordVisible.value;
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                      );
                    }),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      // PhoneInputScreenOrder(),
                                      SignUpOrder(),
                                ),
                              );
                            },
                            child: Text(
                              'create account'.toUpperCase(),
                              style: TextStyle(color: Colors.orange.shade400),
                            ),
                          ),
                          Container(
                            color: Colors.black54,
                            width: 2,
                            height: 20,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ResetPasswordScreen(),
                                ),
                              );
                            },
                            child: Text('Forget Password'.toUpperCase()),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Obx(() {
                      return loginController.isLoading.value
                          ? CircularProgressIndicator()
                          : ElevatedButton(
                              child: Text("Login"),
                              onPressed: () async {
                                String username = loginController
                                    .usernameController
                                    .text
                                    .trim();
                                String password = loginController
                                    .passwordController
                                    .text
                                    .trim();

                                bool isLoggedIn = await loginController
                                    .loginUser(username, password);
                                if (isLoggedIn) {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return Dialog(
                                        child: Container(
                                          height: 100,
                                          width: 200,
                                          child: Center(child: Text('Logged')),
                                        ),
                                      );
                                    },
                                  );
                                  Get.back();
                                  Get.back();
                                } else {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return Dialog(
                                        child: Container(
                                          height: 100,
                                          width: 200,
                                          child: Center(
                                            child: Text('Login failed'),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                }
                              },
                            );
                    }),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
