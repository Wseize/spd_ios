import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class CouponController extends GetxController {
  var totalPrice = 0.0.obs; // Dynamic total price
  var discount = 0.0.obs; // Discount amount
  var couponCode = ''.obs; // Coupon code entered by the user
  var percent = false.obs; // Whether the discount is percentage-based

  // Initialize total price from the item's price
  void setInitialPrice(double price) {
    totalPrice.value = price;
  }

  // Apply Coupon
  Future<void> applyCoupon() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null || token.isEmpty) {
      Get.snackbar('Error', 'Authentication is required');
      return;
    }

    final url = Uri.parse('https://sdingserver.xyz/delivery/cpons/apply/');
    final response = await http.post(
      url,
      headers: {
        'X-Mobile-App': 'true',
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'code': couponCode.value}),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      discount.value = responseData['discount'];
      percent.value = responseData['is_percent'];
      calculateTotal();
    } else {
      Get.snackbar('Error', 'Invalid Coupon or Coupon expired');
    }
  }

  // Calculate the total price after applying the discount
  void calculateTotal() {
    if (percent.value) {
      totalPrice.value = totalPrice.value * (100 - discount.value) / 100;
    } else {
      totalPrice.value -= discount.value;
    }
  }
}
