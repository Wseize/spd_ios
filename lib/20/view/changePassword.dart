import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spooding_exp_ios/20/express.dart';
import 'package:spooding_exp_ios/20/test/testController.dart';
import 'package:spooding_exp_ios/20/view/background.dart';
import 'package:spooding_exp_ios/controller.dart';

class ChangePasswordScreen extends StatelessWidget {
  final ChangePasswordController changePasswordController =
      Get.put(ChangePasswordController());
  final LoginController loginController = Get.put(LoginController());
  final LocationController locationController = Get.put(LocationController());
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Change Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: [
            Background(),
            SingleChildScrollView(
              child: Column(
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
                  SizedBox(
                    height: 40,
                  ),
                  Obx(() {
                    return TextFormField(
                      controller: newPasswordController,
                      obscureText: !loginController.isPasswordVisible.value,
                      decoration: InputDecoration(
                        labelText: 'New Password',
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
                  SizedBox(height: 10),
                  Obx(() {
                    return TextFormField(
                      controller: confirmPasswordController,
                      obscureText: !loginController.isPasswordVisible.value,
                      decoration: InputDecoration(
                        labelText: 'Confirm New Password',
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
                  Obx(() {
                    return changePasswordController.isLoading.value
                        ? CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: changePasswordController.isLoading.value
                                ? null // Disable button while loading
                                : () async {
                                    String newPassword =
                                        newPasswordController.text.trim();
                                    String confirmPassword =
                                        confirmPasswordController.text.trim();

                                    // Check if the passwords match
                                    if (newPassword != confirmPassword) {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title:
                                                Text('Passwords Do Not Match'),
                                            content: Text(
                                                'Please enter matching passwords.'),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(
                                                      context); // Close the dialog
                                                },
                                                child: Text('OK'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                      return; // Exit the onPressed function
                                    }

                                    changePasswordController.isLoading.value =
                                        true; // Start loading

                                    bool isLoggedIn =
                                        await changePasswordController
                                            .changePassword(
                                                newPassword, confirmPassword);

                                    changePasswordController.isLoading.value =
                                        false; // Stop loading

                                    if (isLoggedIn) {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return Dialog(
                                            child: Container(
                                              height:
                                                  150, // Adjusted height for the OK button
                                              width: 200,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                      'New password has been saved.'),
                                                  SizedBox(height: 20),
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      // Close the dialog and navigate to the HomeUpdate page
                                                      Navigator.pop(
                                                          context); // Close the dialog
                                                      Navigator
                                                          .pushAndRemoveUntil(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                MenuScreen()),
                                                        (Route<dynamic>
                                                                route) =>
                                                            false,
                                                      );
                                                    },
                                                    child: Text('OK'),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
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
                                                  child:
                                                      Text('Please try again.'),
                                                ),
                                              ),
                                            );
                                          });
                                    }
                                  },
                            child: Text('Save New Password'),
                          );
                  })
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
