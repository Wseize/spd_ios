import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:spooding_exp_ios/20/express.dart';
import 'package:spooding_exp_ios/20/test/testController.dart';

class CheckLocationScreen extends StatelessWidget {
  final LocationController homeController = Get.put(LocationController());
  final CategoryController categoryController = Get.put(CategoryController());
  final ToutController toutController = Get.put(ToutController());
  CheckLocationScreen({super.key});

  Future<void> _checkLocation(BuildContext context) async {
    bool serviceEnabled;
    LocationPermission permission;

    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: CircularProgressIndicator(
            color: Colors.orange.shade400,
          ),
        );
      },
    );

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Close loading indicator
      Navigator.pop(context);

      // Location services are not enabled, show a Snackbar
      Get.snackbar(
        'Location Error',
        'Location services are disabled. Please enable location services.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.orange.shade400,
        colorText: Colors.white,
        icon: Icon(Icons.location_off, color: Colors.white),
        duration: Duration(seconds: 3),
      );
      return;
    }

    // Check for location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      // Permissions are denied, request permissions
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        // Close loading indicator
        Navigator.pop(context);

        // Permissions are still denied after requesting
        Get.snackbar(
          'Location Permission Denied',
          'Location permissions are denied. Please grant location permissions.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.orange.shade400,
          colorText: Colors.white,
          icon: Icon(Icons.error, color: Colors.white),
          duration: Duration(seconds: 3),
        );
        return;
      }
    }

    // Permissions are granted and services are enabled, get the current position
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    // Update the HomeController with the new position
    homeController.currentPosition.value = position;
    homeController.update();

    // Close the loading indicator
    Navigator.pop(context);

    categoryController.fetchStoresBasic();
    toutController.fetchRecommendedItems();
    categoryController.fetchPublicities();
    toutController.fetchDiscountItems();

    // Navigate to the HomeUpdate
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => MenuScreen()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 10,
        title: Image.asset(
          'images/logo2.png',
          height: 120,
          width: 120,
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: GestureDetector(
            onTap: () => _checkLocation(context),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(
                  'images/location.json',
                  width: 300,
                  height: 300,
                  fit: BoxFit.contain,
                ),
                SizedBox(height: 20),
                Text(
                  "Enable Location Services",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Text(
                  "To proceed, please enable your location services so we can show nearby stores and services.",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 30),
                ElevatedButton.icon(
                  onPressed: () => _checkLocation(context),
                  icon: Icon(Icons.my_location, color: Colors.white),
                  label: Text(
                    'Check Location',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    backgroundColor: Colors.orange.shade400,
                    textStyle: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
