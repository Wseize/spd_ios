// ignore_for_file: must_be_immutable, camel_case_types, use_build_context_synchronously, sized_box_for_whitespace, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spooding_exp_ios/20/express.dart';
import 'package:spooding_exp_ios/20/test/testController.dart';
import 'package:spooding_exp_ios/20/view/background.dart';
import 'package:spooding_exp_ios/controller.dart';

class SignUp extends StatelessWidget {
  final SignUpController controller = Get.put(SignUpController());
  final LocationController locationController = Get.put(LocationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          'Sign Up',
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
          Container(
            padding: const EdgeInsets.only(
              left: 30,
              right: 30,
              bottom: 20,
              top: 0,
            ),
            child: Form(
              key: controller.formState,
              child: ListView(
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
                  // Phone number field
                  TextFormField(
                    controller: controller
                        .usernameController, // Remove first 4 characters

                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value) {
                      // Ensure the value is valid even after trimming
                      if (value == null || value.isEmpty) {
                        return 'Please enter your phone number';
                      }

                      if (value.length != 8) {
                        // Now it expects 4 digits (because first 4 digits were trimmed)
                        return 'Invalid phone number';
                      }

                      if (!['2', '4', '5', '9'].contains(value[0])) {
                        return 'It’s not a valid Tunisian phone number';
                      }

                      return null;
                    },
                  ),

                  SizedBox(height: 20),
                  // Other fields (email, password, confirm password)
                  TextFormField(
                    controller: controller.emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
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
                  TextFormField(
                    controller: controller.passwordController,
                    obscureText: !controller.isPasswordVisible.value,
                    decoration: InputDecoration(
                      labelText: 'Password',
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
                          Get.forceAppUpdate();
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: controller.confirmPasswordController,
                    obscureText: !controller.isPasswordConfirmVisible.value,
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          controller.isPasswordConfirmVisible.value
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          controller.isPasswordConfirmVisible.value =
                              !controller.isPasswordConfirmVisible.value;
                          Get.forceAppUpdate();
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please confirm your password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 30),
                  Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'have an account'.toUpperCase(),
                        style: TextStyle(color: Colors.orange.shade400),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Obx(() {
                    return controller.isLoading.value
                        ? CircularProgressIndicator()
                        : ElevatedButton(
                            child: Text("Sign Up"),
                            onPressed: () async {
                              if (controller.formState.currentState!
                                  .validate()) {
                                bool isSignedUp = await controller.registerUser(
                                  controller.usernameController.text.trim(),
                                  controller.emailController.text.trim(),
                                  controller.passwordController.text.trim(),
                                  controller.confirmPasswordController.text
                                      .trim(),
                                );
                                if (isSignedUp) {
                                  Get.dialog(
                                    AlertDialog(
                                      title: Text('Success'),
                                      content: Text('Sign up successful!'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(
                                              context,
                                            ).pushAndRemoveUntil(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    MenuScreen(),
                                              ),
                                              (Route<dynamic> route) => false,
                                            );
                                          },
                                          child: Text('OK'),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                              }
                            },
                          );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// class SignUpOrder extends StatelessWidget {
//   final SignUpController controller = Get.put(SignUpController());

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: false,
//         title: Text(
//           'Sign Up',
//           style: TextStyle(
//               fontSize: 22,
//               color: Colors.orange.shade400,
//               fontWeight: FontWeight.bold),
//         ),
//       ),
//       body: Stack(
//         children: [
//           Background(),
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
//             child: Form(
//               key: controller.formState,
//               child: ListView(
//                 children: [
//                   Align(
//                     alignment: Alignment.topLeft,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         RichText(
//                           text: const TextSpan(
//                             children: <TextSpan>[
//                               TextSpan(
//                                 text: 'Spooding',
//                                 style: TextStyle(
//                                   fontWeight: FontWeight.w900,
//                                   fontSize: 30,
//                                   color: Colors.black,
//                                 ),
//                               ),
//                               TextSpan(
//                                 text: ' Express',
//                                 style: TextStyle(
//                                   fontWeight: FontWeight.w400,
//                                   fontSize: 20,
//                                   color: Colors.grey,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         Text(
//                           '6'.tr,
//                           style: const TextStyle(
//                             fontWeight: FontWeight.w900,
//                             fontSize: 20,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   SizedBox(
//                     height: 40,
//                   ),
//                   TextFormField(
//                     controller: controller.usernameController,
//                     keyboardType: TextInputType.phone,
//                     decoration: InputDecoration(
//                       labelText: 'Phone Number',
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                     ),
//                     validator: (value) {
//                       // Check if the value is empty
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter your phone number';
//                       }

//                       if (value.length != 8) {
//                         return 'its not a tunisian phone number \nPlease enter your phone number';
//                       }

//                       if (!['2', '4', '5', '9'].contains(value[0])) {
//                         return 'its not a tunisian phone number \nPlease enter your phone number';
//                       }

//                       return null;
//                     },
//                   ),
//                   SizedBox(height: 20),
//                   TextFormField(
//                     controller: controller.emailController,
//                     decoration: InputDecoration(
//                       labelText: 'Email',
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                     ),
//                     validator: (value) {
//                       if (value!.isEmpty) {
//                         return 'Please enter your email';
//                       }
//                       return null;
//                     },
//                   ),
//                   SizedBox(height: 20),
//                   TextFormField(
//                     controller: controller.passwordController,
//                     obscureText: !controller.isPasswordVisible.value,
//                     decoration: InputDecoration(
//                       labelText: 'Password',
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       suffixIcon: IconButton(
//                         icon: Icon(
//                           controller.isPasswordVisible.value
//                               ? Icons.visibility
//                               : Icons.visibility_off,
//                         ),
//                         onPressed: () {
//                           controller.isPasswordVisible.value =
//                               !controller.isPasswordVisible.value;
//                           Get.forceAppUpdate();
//                         },
//                       ),
//                     ),
//                     validator: (value) {
//                       if (value!.isEmpty) {
//                         return 'Please enter your password';
//                       }
//                       return null;
//                     },
//                   ),
//                   SizedBox(height: 20),
//                   TextFormField(
//                     controller: controller.confirmPasswordController,
//                     obscureText: !controller.isPasswordConfirmVisible.value,
//                     decoration: InputDecoration(
//                       labelText: 'Confirm Password',
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       suffixIcon: IconButton(
//                         icon: Icon(
//                           controller.isPasswordConfirmVisible.value
//                               ? Icons.visibility
//                               : Icons.visibility_off,
//                         ),
//                         onPressed: () {
//                           controller.isPasswordConfirmVisible.value =
//                               !controller.isPasswordConfirmVisible.value;
//                           Get.forceAppUpdate();
//                         },
//                       ),
//                     ),
//                     validator: (value) {
//                       if (value!.isEmpty) {
//                         return 'Please confirm your password';
//                       }
//                       return null;
//                     },
//                   ),
//                   const SizedBox(height: 30),
//                   Align(
//                     alignment: Alignment.centerRight,
//                     child: InkWell(
//                       onTap: () {
//                         Navigator.pop(context);
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => LoginOrderScreen(),
//                           ),
//                         );
//                       },
//                       child: Text(
//                         'have an account'.toUpperCase(),
//                         style: TextStyle(color: Colors.orange.shade400),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 30),
//                   Obx(() {
//                     return controller.isLoading.value
//                         ? CircularProgressIndicator()
//                         : ElevatedButton(
//                             child: Text("SignUp"),
//                             onPressed: () async {
//                               if (controller.formState.currentState!
//                                   .validate()) {
//                                 bool isSignedUp = await controller.registerUser(
//                                   controller.usernameController.text.trim(),
//                                   controller.emailController.text.trim(),
//                                   controller.passwordController.text.trim(),
//                                   controller.confirmPasswordController.text
//                                       .trim(),
//                                 );
//                                 if (isSignedUp) {
//                                   Get.dialog(
//                                     AlertDialog(
//                                       title: Text('Success'),
//                                       content: Text('Sign up successful!'),
//                                       actions: [
//                                         TextButton(
//                                           onPressed: () {
//                                             Get.back();
//                                             Get.back();
//                                           },
//                                           child: Text('OK'),
//                                         ),
//                                       ],
//                                     ),
//                                   );
//                                 }
//                               }
//                             },
//                           );
//                   }),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

class SignUpOrder extends StatelessWidget {
  final SignUpController controller = Get.put(SignUpController());
  // final String phoneNumber; // Receive phone number from previous screen

  // SignUpOrder({required this.phoneNumber});

  @override
  Widget build(BuildContext context) {
    // Set the passed phone number to the usernameController
    // controller.usernameController.text = phoneNumber;

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          'Sign Up',
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
          Container(
            padding: const EdgeInsets.only(
              left: 30,
              right: 30,
              bottom: 20,
              top: 0,
            ),
            child: Form(
              key: controller.formState,
              child: ListView(
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
                  // Phone number field
                  TextFormField(
                    controller: controller.usernameController,
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value) {
                      // Ensure the value is valid even after trimming
                      if (value == null || value.isEmpty) {
                        return 'Please enter your phone number';
                      }

                      if (value.length != 8) {
                        // Now it expects 4 digits (because first 4 digits were trimmed)
                        return 'Invalid phone number';
                      }

                      if (!['2', '4', '5', '9'].contains(value[0])) {
                        return 'It’s not a valid Tunisian phone number';
                      }

                      return null;
                    },
                  ),

                  SizedBox(height: 20),
                  // Other fields (email, password, confirm password)
                  TextFormField(
                    controller: controller.emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
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
                  TextFormField(
                    controller: controller.passwordController,
                    obscureText: !controller.isPasswordVisible.value,
                    decoration: InputDecoration(
                      labelText: 'Password',
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
                          Get.forceAppUpdate();
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: controller.confirmPasswordController,
                    obscureText: !controller.isPasswordConfirmVisible.value,
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          controller.isPasswordConfirmVisible.value
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          controller.isPasswordConfirmVisible.value =
                              !controller.isPasswordConfirmVisible.value;
                          Get.forceAppUpdate();
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please confirm your password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 30),
                  Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      child: Text(
                        'have an account'.toUpperCase(),
                        style: TextStyle(color: Colors.orange.shade400),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Obx(() {
                    return controller.isLoading.value
                        ? CircularProgressIndicator()
                        : ElevatedButton(
                            child: Text("Sign Up"),
                            onPressed: () async {
                              if (controller.formState.currentState!
                                  .validate()) {
                                bool isSignedUp = await controller.registerUser(
                                  controller.usernameController.text.trim(),
                                  controller.emailController.text.trim(),
                                  controller.passwordController.text.trim(),
                                  controller.confirmPasswordController.text
                                      .trim(),
                                );
                                if (isSignedUp) {
                                  Get.dialog(
                                    AlertDialog(
                                      title: Text('Success'),
                                      content: Text('Sign up successful!'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Get.back();
                                            Get.back();
                                          },
                                          child: Text('OK'),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                              }
                            },
                          );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
