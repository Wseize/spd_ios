import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:spooding_exp_ios/20/view/background.dart';
import 'dart:convert';

import 'package:spooding_exp_ios/20/view/trackMyOrder.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class ResetPasswordController extends GetxController {
  var isLoading = false.obs;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController tokenController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmNewPasswordController =
      TextEditingController();

  final isPasswordVisible = false.obs;
  final isConfirmPasswordVisible = false.obs;

  Future<void> sendResetRequest() async {
    if (emailController.text.isEmpty) {
      Get.snackbar(
        "Error",
        "Please enter your email",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isLoading.value = true;
    final url = Uri.parse(
      "https://sdingserver.xyz/accounts/api/auth/password/reset/",
    );

    try {
      final response = await http.post(
        url,
        body: jsonEncode({"email": emailController.text}),
        headers: {"Content-Type": "application/json"},
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        Get.snackbar(
          "Success",
          "A reset code has been sent to your email!",
          snackPosition: SnackPosition.BOTTOM,
        );
        Get.to(() => ConfirmResetPasswordScreen(email: emailController.text));
      } else {
        Get.snackbar(
          "Error",
          data["error"] ?? "Failed to send reset request",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Something went wrong. Try again.",
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> confirmReset() async {
    if (tokenController.text.isEmpty ||
        newPasswordController.text.isEmpty ||
        confirmNewPasswordController.text.isEmpty) {
      Get.snackbar(
        "Error",
        "Please fill in all fields",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (newPasswordController.text != confirmNewPasswordController.text) {
      Get.snackbar(
        "Error",
        "Passwords do not match",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isLoading.value = true;
    final url = Uri.parse(
      "https://sdingserver.xyz/accounts/api/auth/password/reset/confirm/",
    );

    try {
      final response = await http.post(
        url,
        body: jsonEncode({
          "email": emailController.text,
          "token": tokenController.text,
          "new_password1": newPasswordController.text,
          "new_password2": confirmNewPasswordController.text,
        }),
        headers: {"Content-Type": "application/json"},
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        Get.snackbar(
          "Success",
          "Password has been reset successfully!",
          snackPosition: SnackPosition.BOTTOM,
        );

        // Ensure the user is redirected to the login screen correctly
        Get.offAll(() => OrderScreen());
      } else {
        Get.snackbar(
          "Error",
          data["error"] ?? "Failed to reset password",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Something went wrong. Try again.",
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
}

class ResetPasswordScreen extends StatelessWidget {
  final ResetPasswordController controller = Get.put(
    ResetPasswordController(),
    permanent: true,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.orange.shade400,
        centerTitle: false,
        title: Text(
          'Reset Password',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Background(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Image.asset(
                      'images/enter_phone_number.png',
                      height: MediaQuery.of(context).size.width * 0.7,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Enter your email to receive a password reset code",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: controller.emailController,
                    decoration: InputDecoration(
                      labelText: "Email",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: Obx(
                      () => ElevatedButton(
                        onPressed: controller.isLoading.value
                            ? null
                            : controller.sendResetRequest,
                        child: controller.isLoading.value
                            ? CircularProgressIndicator()
                            : Text("Send Reset Code"),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ConfirmResetPasswordScreen extends StatefulWidget {
  final String email;

  ConfirmResetPasswordScreen({required this.email});

  @override
  _ConfirmResetPasswordScreenState createState() =>
      _ConfirmResetPasswordScreenState();
}

class _ConfirmResetPasswordScreenState
    extends State<ConfirmResetPasswordScreen> {
  late ResetPasswordController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<ResetPasswordController>(); // Use existing controller
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.emailController.text = widget.email;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.orange.shade400,
        centerTitle: false,
        title: Text(
          'Confirm Reset Password',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
      body: Stack(
        children: [
          Background(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Image.asset(
                      'images/enter_otp.png',
                      height: MediaQuery.of(context).size.width * 0.7,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Enter the 6-digit code sent to your email and create a new password",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 20),

                  /// OTP Input Field
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: PinCodeTextField(
                      appContext: context,
                      length: 6,
                      obscureText: false,
                      animationType: AnimationType.fade,
                      controller: controller.tokenController,
                      keyboardType: TextInputType.number,
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(10),
                        fieldHeight: 50,
                        fieldWidth: 40,
                        activeFillColor: Colors.white,
                        activeColor: Colors.blue,
                        selectedColor: Colors.blueAccent,
                        inactiveColor: Colors.grey,
                      ),
                      onChanged: (value) {},
                    ),
                  ),

                  SizedBox(height: 20),
                  Obx(
                    () => TextField(
                      controller: controller.newPasswordController,
                      obscureText: !controller.isPasswordVisible.value,
                      decoration: InputDecoration(
                        labelText: "New Password",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            controller.isPasswordVisible.value
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            controller.isPasswordVisible.value =
                                !controller.isPasswordVisible.value;
                          },
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Obx(
                    () => TextField(
                      controller: controller.confirmNewPasswordController,
                      obscureText: !controller.isConfirmPasswordVisible.value,
                      decoration: InputDecoration(
                        labelText: "Confirm New Password",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            controller.isConfirmPasswordVisible.value
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            controller.isConfirmPasswordVisible.value =
                                !controller.isConfirmPasswordVisible.value;
                          },
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 20),
                  Center(
                    child: Obx(
                      () => ElevatedButton(
                        onPressed: controller.isLoading.value
                            ? null
                            : controller.confirmReset,
                        child: controller.isLoading.value
                            ? CircularProgressIndicator()
                            : Text("Reset Password"),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
