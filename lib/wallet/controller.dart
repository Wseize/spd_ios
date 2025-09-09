// import 'dart:convert';

// import 'package:http/http.dart' as http;
// import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:spooding_exp/wallet/model.dart';

// class WalletController extends GetxController {
//   var wallet = Rxn<Wallet>();
//   var transactions = <WalletTransaction>[].obs;
//   final String baseUrl = 'https://sdingserver.xyz/accounts/api';

//   @override
//   void onInit() {
//     super.onInit();
//     loadWallet();
//     loadTransactions();
//   }

//   Future<void> loadWallet() async {
//     try {
//       final token = await _getToken();
//       final response = await http.get(
//         Uri.parse('$baseUrl/wallet/'),
//         headers: {'Authorization': 'Bearer $token'},
//       );
//       print("Token: $token");

//       if (response.statusCode == 200) {
//         wallet.value = Wallet.fromJson(jsonDecode(response.body));
//       } else {
//         throw Exception('Failed to load wallet: ${response.statusCode}');
//       }
//     } catch (e) {
//       print('Error loading wallet: $e');
//     }
//   }

//   // Future<bool> transferPoints(String phone, int amount) async {
//   //   try {
//   //     final token = await _getToken();
//   //     final response = await http.post(
//   //       Uri.parse('$baseUrl/wallet/transfer/'),
//   //       headers: {
//   //         'Authorization': 'Bearer $token',
//   //         'Content-Type': 'application/json',
//   //       },
//   //       body: jsonEncode({'recipient_username': phone, 'points': amount}),
//   //     );
//   //     return response.statusCode == 200;
//   //   } catch (e) {
//   //     print('Error sending points: $e');
//   //     return false;
//   //   }
//   // }

//   Future<(bool, String)> transferPoints(String phone, int amount) async {
//     try {
//       final token = await _getToken();
//       final response = await http.post(
//         Uri.parse('$baseUrl/wallet/transfer/'),
//         headers: {
//           'Authorization': 'Bearer $token',
//           'Content-Type': 'application/json',
//         },
//         body: jsonEncode({'recipient_username': phone, 'points': amount}),
//       );

//       if (response.statusCode == 200) {
//         return (true, '');
//       } else {
//         // Decode the response body as a list of JSON objects
//         var data = json.decode(utf8.decode(response.bodyBytes))
//             as Map<String, dynamic>;
//         final message =
//             (data['detail'] ?? data['error'] ?? 'An error occurred').toString();
//         return (false, message);
//       }
//     } catch (e) {
//       return (false, 'Error sending points: ${e.toString()}');
//     }
//   }

//   Future<String?> _getToken() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString('token');
//   }

//   Future<void> loadTransactions() async {
//     try {
//       final token = await _getToken();
//       final response = await http.get(
//         Uri.parse('$baseUrl/wallet/transactions/'),
//         headers: {'Authorization': 'Bearer $token'},
//       );

//       if (response.statusCode == 200) {
//         final List<dynamic> data = jsonDecode(response.body);
//         transactions.value =
//             data.map((json) => WalletTransaction.fromJson(json)).toList();
//       } else {
//         throw Exception('Failed to load transactions: ${response.statusCode}');
//       }
//     } catch (e) {
//       print('Error loading transactions: $e');
//     }
//   }

//   Future<bool> setReferralCode(String code) async {
//     try {
//       final token = await _getToken();
//       final response = await http.post(
//         Uri.parse('$baseUrl/wallet/set_referral_code/'),
//         headers: {
//           'Authorization': 'Bearer $token',
//           'Content-Type': 'application/json',
//         },
//         body: jsonEncode({'referral_code': code}),
//       );

//       if (response.statusCode == 200) {
//         await loadWallet();
//         return true;
//       }
//       return false;
//     } catch (e) {
//       print('Error setting referral code: $e');
//       return false;
//     }
//   }

//   Future<bool> skipReferral() async {
//     try {
//       final token = await _getToken();
//       final response = await http.post(
//         Uri.parse('$baseUrl/wallet/skip_referral/'),
//         headers: {
//           'Authorization': 'Bearer $token',
//           'Content-Type': 'application/json',
//         },
//       );

//       if (response.statusCode == 200) {
//         await loadWallet();
//         return true;
//       } else {
//         print('Failed to skip referral: ${response.statusCode}');
//         return false;
//       }
//     } catch (e) {
//       print('Error skipping referral: $e');
//       return false;
//     }
//   }

//   Future<(bool, String)> usePoints(int amount) async {
//     try {
//       final token = await _getToken();
//       final response = await http.post(
//         Uri.parse('$baseUrl/wallet/use_points/'),
//         headers: {
//           'Authorization': 'Bearer $token',
//           'Content-Type': 'application/json',
//         },
//         body: jsonEncode({'points': amount}),
//       );

//       if (response.statusCode == 200) {
//         await loadWallet(); // Reload wallet after deduction
//         return (true, 'Successfully used $amount points.');
//       } else {
//         var data = json.decode(utf8.decode(response.bodyBytes))
//             as Map<String, dynamic>;
//         final message =
//             (data['detail'] ?? data['error'] ?? 'An error occurred').toString();
//         return (false, message);
//       }
//     } catch (e) {
//       return (false, 'Error using points: ${e.toString()}');
//     }
//   }

//   Future<void> exchangePointsForCarnet(int points) async {
//     final prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString('token');

//     final response = await http.post(
//       Uri.parse('$baseUrl/exchange-points/'),
//       headers: {
//         'Authorization': 'Bearer $token',
//         'Content-Type': 'application/json; charset=UTF-8',
//       },
//       body: json.encode({"points": points}),
//     );

//     if (response.statusCode == 201) {
//       final data = json.decode(
//         utf8.decode(response.bodyBytes),
//       ); // فك التشفير بشكل صحيح
//       // Get.snackbar(
//       //   "نجاح",
//       //   "تم إنشاء ${data['tokens'].length} carnet(s) بنجاح 🎉",
//       // );
//       // هنا ممكن تعمل تحديث للـSPD points أو تخزين الـ tokens في حالة احتجتهم
//     } else {
//       final errorData = json.decode(utf8.decode(response.bodyBytes));
//       Get.snackbar("خطأ", errorData["detail"]);
//     }
//   }

//   Future<List<Carnet>> fetchCarnets() async {
//     final prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString('token');
//     final response = await http.get(
//       Uri.parse('$baseUrl/carnets/'),
//       headers: {
//         'Authorization': 'Bearer $token',
//         'Content-Type': 'application/json',
//       },
//     );

//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       final List carnetsJson = data['carnets'];
//       return carnetsJson.map((json) => Carnet.fromJson(json)).toList();
//     } else {
//       print("Status Code: ${response.statusCode}");
//       print("Response Body: ${response.body}");
//       throw Exception('Failed to load carnets');
//     }
//   }
// }
