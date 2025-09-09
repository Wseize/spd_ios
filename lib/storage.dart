import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:spooding_exp_ios/model.dart';

class LocalStorageHelper {
  static Future<void> saveCart(List<Map<String, dynamic>> cart) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final List<String> cartJsonList = cart.map((item) {
      return jsonEncode({
        'item': item['item'].toJson(), // Ensure `item` has a `toJson()` method
        'quantity': item['quantity'],
        'suppliments': (item['suppliments'] as List<Suppliment>).map((s) => s.toJson()).toList(),
      });
    }).toList();

    await prefs.setStringList('cart', cartJsonList);
  }

  static Future<List<Map<String, dynamic>>> loadCart() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String>? cartJsonList = prefs.getStringList('cart');

    if (cartJsonList != null) {
      return cartJsonList.map((jsonString) {
        final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
        return {
          'item': Item.fromJson(jsonMap['item']), // Ensure `Item` has a `fromJson()` method
          'quantity': jsonMap['quantity'],
          'suppliments': (jsonMap['suppliments'] as List<dynamic>)
              .map((s) => Suppliment.fromJson(s))
              .toList(), // Ensure `Suppliment` has a `fromJson()` method
        };
      }).toList();
    }

    return [];
  }
}
