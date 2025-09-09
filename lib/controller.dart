// ignore_for_file: unused_local_variable, avoid_print, non_constant_identifier_names

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spooding_exp_ios/20/express.dart';
import 'package:spooding_exp_ios/model.dart';
import 'package:spooding_exp_ios/storage.dart';

// class HomeController extends GetxController {
//   Position? currentPosition;
//   String locationName = '';
//   String locationNameCountry = '';
//   double maxDistance = 13.0;

//   @override
//   void onInit() {
//     super.onInit();
//     _initCurrentPosition();
//     _getLocationPermission();
//   }

//   Future<void> _initCurrentPosition() async {
//     Position? savedPosition = await getSavedPosition();
//     if (savedPosition != null) {
//       currentPosition = savedPosition;
//       print(
//           'Initialized with saved position: Latitude: ${currentPosition!.latitude}, Longitude: ${currentPosition!.longitude}');
//       _updateLocationData(savedPosition);
//     } else {
//       print('No saved position found, will try to get current location.');
//     }
//     _checkPositionAndNavigate();
//   }

//   Future<void> refreshCurrentPosition() async {
//     await _initCurrentPosition();
//     _checkPositionAndNavigate();
//   }

//   void _getLocationPermission() async {
//     LocationPermission permission = await Geolocator.requestPermission();
//     if (permission == LocationPermission.denied ||
//         permission == LocationPermission.deniedForever) {
//       print('Location permission denied');
//     } else {
//       _getCurrentLocation();
//     }
//     _checkPositionAndNavigate();
//   }

//   Future<void> _getCurrentLocation() async {
//     try {
//       Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high,
//       );
//       _updateLocationData(position);
//       _saveCurrentPosition(position);
//     } catch (e) {
//       if (e is LocationServiceDisabledException) {
//         print('Location service is disabled on the device.');
//       } else {
//         print('Error: $e');
//       }
//     }
//     _checkPositionAndNavigate();
//   }

//   void _checkPositionAndNavigate() {
//     if (currentPosition == null) {
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         if (Get.isOverlaysOpen == false && Get.context != null) {
//           Get.offNamed('/check-location');
//         }
//       });
//     }
//   }

//   void _updateLocationData(Position position) async {
//     final url =
//         'https://nominatim.openstreetmap.org/reverse?lat=${position.latitude}&lon=${position.longitude}&format=json&addressdetails=1';

//     final response = await http.get(Uri.parse(url));

//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       final address = data['address']['state'];
//       final addressCountry = data['address']['country'];

//       currentPosition = position;
//       locationName = address;
//       locationNameCountry = addressCountry;
//       update();
//       print('Location updated: $locationName, $locationNameCountry');
//     } else {
//       print('Failed to fetch location data: ${response.statusCode}');
//     }
//   }

//   void _saveCurrentPosition(Position position) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setDouble('latitude', position.latitude);
//     await prefs.setDouble('longitude', position.longitude);
//     print(
//         'Saved position: Latitude: ${position.latitude}, Longitude: ${position.longitude}');
//   }

//   Future<Position?> getSavedPosition() async {
//     final prefs = await SharedPreferences.getInstance();
//     final double? latitude = prefs.getDouble('latitude');
//     final double? longitude = prefs.getDouble('longitude');
//     if (latitude != null && longitude != null) {
//       print(
//           'Retrieved saved position: Latitude: $latitude, Longitude: $longitude');
//       return Position(
//         latitude: latitude,
//         longitude: longitude,
//         timestamp: DateTime.now(),
//         accuracy: 0.0,
//         altitude: 0.0,
//         heading: 0.0,
//         speed: 0.0,
//         speedAccuracy: 0.0,
//         headingAccuracy: 0.0,
//         altitudeAccuracy: 0.0,
//       );
//     } else {
//       print('No saved position found');
//     }
//     return null;
//   }

//   Future<void> checkAndUpdateCurrentPosition() async {
//     LocationPermission permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.whileInUse ||
//         permission == LocationPermission.always) {
//       await _getCurrentLocation();
//     } else {
//       _getLocationPermission();
//     }
//   }

//   Store findStoreByItemId(int itemId, CategoryController categoryController) {
//     for (var typeCategory in categoryController.typecategories) {
//       for (var store in typeCategory.stores) {
//         if (store.items.any((item) => item.id == itemId)) {
//           return store;
//         }
//       }
//     }
//     return Store(
//         id: 0,
//         name: 'name',
//         image: 'image',
//         phoneNumber: 'phoneNumber',
//         country: 'kasserine',
//         governorate: 'sbeitla',
//         available: true,
//         items: [],
//         latitude: 10.2,
//         longitude: 10.2,
//         average_rating: 0,
//         favorited_by: [],
//         category: 0,
//         ratings: [],
//         free_delivery: false);
//   }

//   double calculateDistance(double currentLatitude, double currentLongitude,
//       double shopLatitude, double shopLongitude) {
//     const earthRadius = 6371.0;

//     final startLatRad = degreesToRadians(currentLatitude);
//     final endLatRad = degreesToRadians(shopLatitude);
//     final latDiffRad = degreesToRadians(shopLatitude - currentLatitude);
//     final lonDiffRad = degreesToRadians(shopLongitude - currentLongitude);

//     final a = pow(sin(latDiffRad / 2), 2) +
//         cos(startLatRad) * cos(endLatRad) * pow(sin(lonDiffRad / 2), 2);
//     final c = 2 * atan2(sqrt(a), sqrt(1 - a));
//     final distance = earthRadius * c;

//     return distance;
//   }

//   double degreesToRadians(double degrees) {
//     return degrees * pi / 180.0;
//   }

//   List<Store> findNearbyStores(CategoryController categoryController) {
//     List<Store> nearbyStores = [];

//     if (currentPosition != null) {
//       for (var store in categoryController.stores) {
//         double distance = calculateDistance(
//           currentPosition!.latitude,
//           currentPosition!.longitude,
//           store.latitude,
//           store.longitude,
//         );

//         if (distance <= maxDistance) {
//           nearbyStores.add(store);
//         }
//       }
//     }

//     return nearbyStores;
//   }
// }

// class CategoryController extends GetxController {
//   var categories = <Category>[].obs;
//   var typecategories = <TypeCategory>[].obs;
//   var stores = <Store>[].obs;
//   var notices = <Notice>[].obs;
//   var user = <User>[].obs;
//   var publicities = <Publicity>[].obs;
//   var isLoading = true.obs;
//   var isLoadingType = true.obs;
//   var cartItems = <Item>[].obs;

//   final List<String> Kasserine = ['sbeitla', 'feriana', 'thala'];
//   final List<String> Mahdia = ['rejiche', 'chebba', 'sidi_alouane'];
//   String selectedCity = 'sbeitla';
//   final List<String> governorate = ['kasserine', 'mahdia'];
//   String selectedGovernorate = 'kasserine';

//   RxInt selectedIndexCategory = 0.obs;

//   var selectedTypeCategory = Rx<TypeCategory?>(null);

//   void selectTypeCategory(TypeCategory category) {
//     selectedTypeCategory.value = category;
//   }

//   Rx<Category?> selectedCategory = Rx<Category?>(null);
//   void selectCategory(Category? category) {
//     selectedCategory.value = category;
//   }

//   RxInt selectedCategory1 = 1.obs;

//   void selectCategory1(int index) {
//     selectedCategory1.value = index;
//   }

//   final HomeController homeController = Get.put(HomeController());
//   void onCategorySelected(int index) {
//     selectedIndexCategory.value = index;
//   }

//   var selectedCategoryBoutique = Rx<Category?>(null);
//   var selectedSubcategory = RxString('');

//   void selectCategoryBoutique(Category? category) {
//     selectedCategoryBoutique.value = category;
//     // Reset selected subcategory when category changes
//     selectedSubcategory.value = '';
//   }

//   void selectSubcategory(String subcategory) {
//     selectedSubcategory.value = subcategory;
//   }

//   final TextEditingController searchController = TextEditingController();
//   RxList<Item> searchProductList = RxList<Item>();

//   void searchProducts(String query, Store store) {
//     searchProductList.assignAll(store.items.where(
//         (item) => item.name.toLowerCase().contains(query.toLowerCase())));
//   }

//   var filteredItems = <Item>[].obs;
//   var filteredStores = <Store>[].obs;

//   void searchItemsAndStores(String query) {
//     if (query.length < 3) {
//       filteredItems.clear();
//       filteredStores.clear();
//       return;
//     }

//     // Search items inside typeCategories.stores
//     filteredItems.value = typecategories
//         .expand((typeCategory) => typeCategory.stores)
//         .expand((store) => store.items)
//         .where((item) => item.name.toLowerCase().contains(query.toLowerCase()))
//         .toList();

//     // Search stores inside typeCategories
//     filteredStores.value = typecategories
//         .expand((typeCategory) => typeCategory.stores)
//         .where(
//             (store) => store.name.toLowerCase().contains(query.toLowerCase()))
//         .toList();

//     // Remove items from stores that are too far
//     filteredItems.removeWhere((item) {
//       var store = homeController.findStoreByItemId(item.id, this);
//       var distance = homeController.calculateDistance(
//         homeController.currentPosition!.latitude,
//         homeController.currentPosition!.longitude,
//         store.latitude,
//         store.longitude,
//       );
//       return distance > homeController.maxDistance;
//     });

//     // Remove stores that are too far
//     filteredStores.removeWhere((store) {
//       var distance = homeController.calculateDistance(
//         homeController.currentPosition!.latitude,
//         homeController.currentPosition!.longitude,
//         store.latitude,
//         store.longitude,
//       );
//       return distance > homeController.maxDistance;
//     });
//   }

//   RxString sortBy = ''.obs;
//   void updateSorting(String criteria) {
//     sortBy.value = criteria;
//     update();
//   }

//   @override
//   void onInit() {
//     fetchTypeCategories();
//     fetchPublicities();
//     fetchUserProfile();
//     super.onInit();
//   }

//   // Future<void> fetchTypeCategories() async {
//   //   try {
//   //     final response = await http
//   //         .get(Uri.parse('https://sdingserver.xyz/delivery/typecategories/'));
//   //     if (response.statusCode == 200) {
//   //       isLoading.value = true;
//   //       var jsonList = json.decode(response.body) as List;
//   //       typecategories.value = jsonList
//   //           .map((category) => TypeCategory.fromJson(category))
//   //           .toList();
//   //     } else {
//   //       // Handle server errors
//   //       print('Server error: ${response.statusCode}');
//   //     }
//   //   } catch (e, stackTrace) {
//   //     print('Error fetching data: $e');
//   //     print('Stack trace: $stackTrace');
//   //   }
//   //   isLoading.value = false;
//   // }

//   // Future<void> fetchTypeCategories() async {
//   //   try {
//   //     final response = await http
//   //         .get(Uri.parse('https://sdingserver.xyz/delivery/typecategories/'));
//   //     if (response.statusCode == 200) {
//   //       isLoading.value = true;
//   //       var jsonList = json.decode(response.body) as List;
//   //       List<TypeCategory> fetchedTypeCategories = jsonList.map((categoryJson) {
//   //         TypeCategory category = TypeCategory.fromJson(categoryJson);
//   //         return category;
//   //       }).toList();

//   //       if (homeController.currentPosition != null) {
//   //         double maxDistance = homeController.maxDistance;
//   //         fetchedTypeCategories = fetchedTypeCategories.where((category) {
//   //           bool hasNearbyStore = category.stores.any((store) {
//   //             double distance = homeController.calculateDistance(
//   //               homeController.currentPosition!.latitude,
//   //               homeController.currentPosition!.longitude,
//   //               store.latitude,
//   //               store.longitude,
//   //             );
//   //             return distance <= maxDistance;
//   //           });
//   //           return hasNearbyStore;
//   //         }).toList();
//   //       }

//   //       typecategories.value = fetchedTypeCategories;
//   //     } else {
//   //       print('Server error: ${response.statusCode}');
//   //     }
//   //   } catch (e, stackTrace) {
//   //     print('Error fetching data: $e');
//   //     print('Stack trace: $stackTrace');
//   //   } finally {
//   //     isLoading.value = false;
//   //   }
//   // }

//   RxString selectedSubCategory = ''.obs;
//   RxList<String> subCategories = <String>[].obs;
//   Future<void> fetchTypeCategories() async {
//     try {
//       final response = await http.get(
//           Uri.parse('https://sdingserver.xyz/delivery/typecategories/'),
//           headers: {
//             'X-Mobile-App': 'true',
//           });

//       if (response.statusCode == 200) {
//         isLoadingType.value = true;

//         // Decode the response body using UTF-8 to handle any special characters
//         final decodedBody = utf8.decode(response.bodyBytes);
//         var jsonList = json.decode(decodedBody) as List;
//         List<TypeCategory> fetchedTypeCategories = jsonList.map((categoryJson) {
//           TypeCategory category = TypeCategory.fromJson(categoryJson);
//           return category;
//         }).toList();

//         if (homeController.currentPosition != null) {
//           double maxDistance = homeController.maxDistance;
//           fetchedTypeCategories = fetchedTypeCategories.where((category) {
//             bool hasNearbyStore = category.stores.any((store) {
//               double distance = homeController.calculateDistance(
//                 homeController.currentPosition!.latitude,
//                 homeController.currentPosition!.longitude,
//                 store.latitude,
//                 store.longitude,
//               );
//               return distance <= maxDistance;
//             });
//             return hasNearbyStore;
//           }).toList();
//         }

//         typecategories.value = fetchedTypeCategories;

//         final allSubCategories = <String>{};
//         for (var type in typecategories) {
//           for (var store in type.stores) {
//             for (var item in store.items) {
//               if (item.sub_category_name != null) {
//                 allSubCategories.add(item.sub_category_name!);
//               }
//             }
//           }
//         }
//         subCategories.value = allSubCategories.toList();

//         if (subCategories.isNotEmpty) {
//           selectedSubCategory.value = subCategories.first;
//         }
//       } else {
//         print('Server error: ${response.statusCode}');
//       }
//     } catch (e, stackTrace) {
//       print('Error fetching data: $e');
//       print('Stack trace: $stackTrace');
//     } finally {
//       isLoadingType.value = false;
//     }
//   }

//   // Future<void> fetchCategories() async {
//   //   try {
//   //     final response = await http
//   //         .get(Uri.parse('https://sdingserver.xyz/delivery/categories/'));
//   //     if (response.statusCode == 200) {
//   //       isLoading.value = true;
//   //       var jsonList = json.decode(response.body) as List;
//   //       categories.value =
//   //           jsonList.map((category) => Category.fromJson(category)).toList();

//   //       print('==============');
//   //       print(categories);
//   //       print('==============');
//   //     } else {
//   //       print('Server error: ${response.statusCode}');
//   //     }
//   //   } catch (e, stackTrace) {
//   //     print('Error fetching data: $e');
//   //     print('Stack trace: $stackTrace');
//   //   }
//   //   isLoading.value = false;
//   // }

//   Future<void> fetchCategories() async {
//     try {
//       final response = await http.get(
//           Uri.parse('https://sdingserver.xyz/delivery/categories/'),
//           headers: {
//             'X-Mobile-App': 'true',
//           });

//       if (response.statusCode == 200) {
//         isLoading.value = true;

//         // Decode the response body using UTF-8
//         final decodedBody = utf8.decode(response.bodyBytes);
//         var jsonList = json.decode(decodedBody) as List;
//         categories.value =
//             jsonList.map((category) => Category.fromJson(category)).toList();

//         print('==============');
//         print(categories);
//         print('==============');
//       } else {
//         print('Server error: ${response.statusCode}');
//       }
//     } catch (e, stackTrace) {
//       print('Error fetching data: $e');
//       print('Stack trace: $stackTrace');
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   // Store findStoreByItemId(int itemId) {
//   //   for (var store in stores) {
//   //     if (store.items.any((item) => item.id == itemId)) {
//   //       return store;
//   //     }
//   //   }
//   //   return Store(
//   //       id: 0,
//   //       name: 'name',
//   //       image: 'image',
//   //       phoneNumber: 'phoneNumber',
//   //       country: 'kasserine',
//   //       governorate: 'sbeitla',
//   //       available: true,
//   //       items: [],
//   //       latitude: 10.2,
//   //       longitude: 10.2,
//   //       average_rating: 0,
//   //       favorited_by: [],
//   //       category: 0,
//   //       ratings: []);
//   // }

//   // Future<void> fetchCategories() async {
//   //   try {
//   //     final response = await http
//   //         .get(Uri.parse('https://sdingserver.xyz/delivery/categories/'));
//   //     if (response.statusCode == 200) {
//   //       isLoading.value = true;
//   //       var jsonList = json.decode(response.body) as List;
//   //       List<Category> fetchedCategories = jsonList.map((categoryJson) {
//   //         return Category.fromJson(categoryJson);
//   //       }).toList();

//   //       if (homeController.currentPosition != null) {
//   //         double maxDistance = homeController.maxDistance;

//   //         fetchedCategories = fetchedCategories.where((category) {
//   //           bool hasNearbyItem = category.items.any((item) {
//   //             Store store = findStoreByItemId(item.id);

//   //             double distance = homeController.calculateDistance(
//   //               homeController.currentPosition!.latitude,
//   //               homeController.currentPosition!.longitude,
//   //               store.latitude,
//   //               store.longitude,
//   //             );
//   //             return distance <= maxDistance;
//   //           });
//   //           return hasNearbyItem;
//   //         }).toList();
//   //       }

//   //       categories.value = fetchedCategories;

//   //       print('==============');
//   //       print(categories);
//   //       print('==============');
//   //     } else {
//   //       print('Server error: ${response.statusCode}');
//   //     }
//   //   } catch (e, stackTrace) {
//   //     print('Error fetching data: $e');
//   //     print('Stack trace: $stackTrace');
//   //   } finally {
//   //     isLoading.value = false;
//   //   }
//   // }

//   // Future<void> fetchStores() async {
//   //   try {
//   //     final response = await http
//   //         .get(Uri.parse('https://sdingserver.xyz/delivery/stores/'));
//   //     if (response.statusCode == 200) {
//   //       isLoading.value = true;
//   //       var jsonList = json.decode(response.body) as List;
//   //       List<Store> fetchedStores = jsonList.map((storeJson) {
//   //         Store store = Store.fromJson(storeJson);
//   //         return store;
//   //       }).toList();

//   //       if (homeController.currentPosition != null) {
//   //         double maxDistance = homeController.maxDistance;
//   //         fetchedStores = fetchedStores.where((store) {
//   //           double distance = homeController.calculateDistance(
//   //             homeController.currentPosition!.latitude,
//   //             homeController.currentPosition!.longitude,
//   //             store.latitude,
//   //             store.longitude,
//   //           );
//   //           return distance <= maxDistance;
//   //         }).toList();
//   //       }

//   //       stores.value = fetchedStores;
//   //       print('==============');
//   //       print(stores);
//   //       print('==============');
//   //     } else {
//   //       // Handle server errors
//   //       print('Server error: ${response.statusCode}');
//   //     }
//   //   } catch (e, stackTrace) {
//   //     print('Error fetching data: $e');
//   //     print('Stack trace: $stackTrace');
//   //   } finally {
//   //     isLoading.value = false;
//   //   }
//   // }

//   Future<void> fetchStores() async {
//     try {
//       final response = await http
//           .get(Uri.parse('https://sdingserver.xyz/delivery/stores/'), headers: {
//         'X-Mobile-App': 'true',
//       });

//       if (response.statusCode == 200) {
//         isLoading.value = true;

//         // Decode the response body using UTF-8
//         final decodedBody = utf8.decode(response.bodyBytes);
//         var jsonList = json.decode(decodedBody) as List;
//         List<Store> fetchedStores = jsonList.map((storeJson) {
//           Store store = Store.fromJson(storeJson);
//           return store;
//         }).toList();

//         // Filter stores based on distance
//         if (homeController.currentPosition != null) {
//           double maxDistance = homeController.maxDistance;
//           fetchedStores = fetchedStores.where((store) {
//             double distance = homeController.calculateDistance(
//               homeController.currentPosition!.latitude,
//               homeController.currentPosition!.longitude,
//               store.latitude,
//               store.longitude,
//             );
//             return distance <= maxDistance;
//           }).toList();
//         }

//         stores.value = fetchedStores;
//         print('==============');
//         print(stores);
//         print('==============');
//       } else {
//         // Handle server errors
//         print('Server error: ${response.statusCode}');
//       }
//     } catch (e, stackTrace) {
//       print('Error fetching data: $e');
//       print('Stack trace: $stackTrace');
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   // Future<void> fetchNoticeStores() async {
//   //   final SharedPreferences prefs = await SharedPreferences.getInstance();
//   //   final token = prefs.getString('token');
//   //   isLoading.value = true;
//   //   try {
//   //     final response = await http.get(
//   //       Uri.parse('https://sdingserver.xyz/delivery/notices/'),
//   //       // headers: {'Authorization': 'Bearer $token'},
//   //     );
//   //     print('Response status: ${response.statusCode}');
//   //     print('Response body: ${response.body}');

//   //     if (response.statusCode == 200) {
//   //       var jsonList = json.decode(response.body) as List;
//   //       notices.value = jsonList.map((storeJson) {
//   //         print(storeJson);
//   //         return Notice.fromJson(storeJson);
//   //       }).toList();
//   //       print('Notices fetched: ${notices.length}');
//   //     } else {
//   //       // Handle server errors
//   //       print('Server error: ${response.statusCode}');
//   //     }
//   //   } catch (e, stackTrace) {
//   //     print('Error fetching data: $e');
//   //     print('Stack trace: $stackTrace');
//   //   } finally {
//   //     isLoading.value = false; // Stop loading
//   //   }
//   // }
//   Future<void> fetchNoticeStores() async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString('token');
//     isLoading.value = true;

//     try {
//       final response = await http.get(
//         Uri.parse('https://sdingserver.xyz/delivery/notices/'),
//         headers: {
//           'X-Mobile-App': 'true',
//           'Authorization': 'Bearer $token',
//         },
//       );
//       print('Response status: ${response.statusCode}');
//       print('Response body: ${response.body}');

//       if (response.statusCode == 200) {
//         // Decode the response body using UTF-8
//         final decodedBody = utf8.decode(response.bodyBytes);
//         var jsonList = json.decode(decodedBody) as List;
//         notices.value = jsonList.map((storeJson) {
//           print(storeJson);
//           return Notice.fromJson(storeJson);
//         }).toList();
//         print('Notices fetched: ${notices.length}');
//       } else {
//         // Handle server errors
//         print('Server error: ${response.statusCode}');
//       }
//     } catch (e, stackTrace) {
//       print('Error fetching data: $e');
//       print('Stack trace: $stackTrace');
//     } finally {
//       isLoading.value = false; // Stop loading
//     }
//   }

//   Future<void> createNotice(String noticeText, int storeId) async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString('token');

//     try {
//       final response = await http.post(
//         Uri.parse('https://sdingserver.xyz/delivery/notices/'),
//         headers: {
//           'X-Mobile-App': 'true',
//           'Authorization': 'Bearer $token',
//           'Content-Type': 'application/json',
//         },
//         body: jsonEncode({
//           'user_name': userProfile.value.username,
//           'notice': noticeText,
//           'store': storeId
//         }),
//       );

//       if (response.statusCode == 201) {
//         // Notice created successfully
//         fetchNoticeStores(); // Refresh notices list
//       } else {
//         // Handle error
//         print('Error creating notice: ${response.statusCode}');
//       }
//     } catch (e) {
//       print('Error creating notice: $e');
//     }
//   }

//   Future<void> deleteNotice(int noticeId) async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString('token');

//     try {
//       final response = await http.delete(
//         Uri.parse('https://sdingserver.xyz/delivery/notices/$noticeId/'),
//         headers: {'X-Mobile-App': 'true', 'Authorization': 'Bearer $token'},
//       );

//       if (response.statusCode == 200) {
//         // Notice deleted successfully
//         fetchNoticeStores(); // Refresh notices list
//       } else {
//         // Handle error
//         print('Error deleting notice: ${response.statusCode}');
//       }
//     } catch (e) {
//       print('Error deleting notice: $e');
//     }
//   }

//   Future<void> fetchPublicities() async {
//     try {
//       final response = await http.get(
//         Uri.parse('https://sdingserver.xyz/delivery/publicities/'),
//         headers: {
//           'X-Mobile-App': 'true',
//         },
//       );

//       if (response.statusCode == 200) {
//         isLoading.value = true;
//         // Decode the response body using UTF-8 to handle any special characters
//         final decodedBody = utf8.decode(response.bodyBytes);
//         var jsonList = json.decode(decodedBody) as List;

//         // Parse the publicities from the JSON response
//         List<Publicity> fetchedPublicities = jsonList.map((itemJson) {
//           Publicity publicity = Publicity.fromJson(itemJson);
//           return publicity;
//         }).toList();

//         // Filter publicities based on the user's current position and max distance
//         if (homeController.currentPosition != null) {
//           double maxDistance = homeController.maxDistance;
//           fetchedPublicities = fetchedPublicities.where((publicity) {
//             // Assume each Publicity has a property 'store' with latitude and longitude
//             double distance = homeController.calculateDistance(
//               homeController.currentPosition!.latitude,
//               homeController.currentPosition!.longitude,
//               publicity.latitude, // Update this if the structure is different
//               publicity.longitude, // Update this if the structure is different
//             );
//             return distance <= maxDistance;
//           }).toList();
//         }

//         // Update the publicities value with the filtered list
//         publicities.value = fetchedPublicities;
//       } else {
//         print('Server error: ${response.statusCode}');
//       }
//     } catch (e, stackTrace) {
//       print('Error fetching data: $e');
//       print('Stack trace: $stackTrace');
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   final Rx<User> userProfile = User(
//     id: 0,
//     username: '',
//     // mobile: '',
//     isNotBlocked: true,
//   ).obs;

//   Future<void> fetchUserProfile() async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString('token');
//     final id = prefs.getInt('id');

//     try {
//       final response = await http.get(
//         Uri.parse('https://sdingserver.xyz/accounts/api/user-profiles/$id/'),
//         headers: {'X-Mobile-App': 'true', 'Authorization': 'Bearer $token'},
//       );

//       print('Response Body: ${response.body}');

//       if (response.statusCode == 200) {
//         final userProfileData = User.fromJson(json.decode(response.body));
//         userProfile.value = userProfileData;
//         print(userProfileData);
//       } else {
//         print('Failed to load user profile: ${response.body}');
//         throw Exception('Failed to load user profile');
//       }
//     } catch (e) {
//       print('Exception during fetchUserProfile: $e');
//     }
//   }

//   Future<void> updateProfile(User user) async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString('token');
//     final username = prefs.getString('username');
//     final id = prefs.getInt('id');

//     try {
//       final Map<String, dynamic> requestBody = {
//         'username': username,
//         // 'mobile': user.mobile,
//       };

//       final response = await http.patch(
//         Uri.parse('https://sdingserver.xyz/accounts/api/user-profiles/$id/'),
//         headers: {
//           'X-Mobile-App': 'true',
//           'Authorization': 'Bearer $token',
//           'Content-Type': 'application/json',
//         },
//         body: jsonEncode(requestBody),
//       );

//       if (response.statusCode == 200) {
//         final updatedProfile = User.fromJson(json.decode(response.body));
//         userProfile.value = updatedProfile;
//         print('Profile updated successfully');
//       } else {
//         print(response.statusCode);
//         print('Response Body: ${response.body}'); // Debug print
//         print('Response Headers: ${response.headers}'); // Debug print
//         throw Exception('Failed to update user profile');
//       }
//     } catch (e) {
//       print('Exception during updateProfile: $e');
//     }
//   }

//   Future<void> addFavoritestore(int storeId) async {
//     try {
//       final SharedPreferences prefs = await SharedPreferences.getInstance();
//       final token = prefs.getString('token');
//       final userId = prefs.getInt('id');

//       final response = await http.post(
//         Uri.parse(
//             'https://sdingserver.xyz/accounts/api/user-profiles/$userId/add-favorite/'),
//         headers: {
//           'X-Mobile-App': 'true',
//           'Authorization': 'Bearer $token',
//           'Content-Type': 'application/json',
//         },
//         body: jsonEncode({'store_id': storeId}),
//       );

//       if (response.statusCode == 200) {
//         await fetchUserProfile();
//         await fetchStores();
//         print('store added to favorites successfully');
//       } else {
//         print('Failed to add store to favorites');
//       }
//     } catch (e) {
//       print('Exception during addFavoritestore: $e');
//     }
//   }

//   Future<void> removeFavoritestore(int storeId) async {
//     try {
//       final SharedPreferences prefs = await SharedPreferences.getInstance();
//       final token = prefs.getString('token');
//       final userId = prefs.getInt('id');

//       final response = await http.post(
//         Uri.parse(
//             'https://sdingserver.xyz/accounts/api/user-profiles/$userId/remove-favorite/'),
//         headers: {
//           'X-Mobile-App': 'true',
//           'Authorization': 'Bearer $token',
//           'Content-Type': 'application/json',
//         },
//         body: jsonEncode({'store_id': storeId}),
//       );

//       if (response.statusCode == 200) {
//         await fetchUserProfile();
//         await fetchStores();
//         print('store removed from favorites successfully');
//       } else {
//         print('Failed to remove store from favorites');
//       }
//     } catch (e) {
//       print('Exception during removeFavoritestore: $e');
//     }
//   }

//   Future<void> fetchFavoriteVendors() async {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       isLoading.value = true;
//     });
//     try {
//       final SharedPreferences prefs = await SharedPreferences.getInstance();
//       final token = prefs.getString('token');
//       final userId = prefs.getInt('id');

//       final response = await http.get(
//         Uri.parse(
//             'https://sdingserver.xyz/accounts/api/user-profiles/$userId/favorite-stores/'),
//         headers: {
//           'X-Mobile-App': 'true',
//           'Authorization': 'Bearer $token',
//         },
//       );

//       if (response.statusCode == 200) {
//         final List<dynamic> data = jsonDecode(response.body);
//         List<Store> fetchedFavoriteStores =
//             data.map((item) => Store.fromJson(item)).toList();

//         favoriteVendors.assignAll(fetchedFavoriteStores);
//         print(response.body);
//       } else {
//         print('Failed to fetch favorite vendors: ${response.statusCode}');
//         throw Exception('Failed to fetch favorite vendors');
//       }
//     } catch (e) {
//       print('Exception during fetchFavoriteVendors: $e');
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   final RxList<Store> favoriteVendors = <Store>[].obs;
//   bool isFavorite(int vendorId) {
//     return favoriteVendors.any((vendor) => vendor.id == vendorId);
//   }
// }

class CartController extends GetxController {
  var orders = <Order>[].obs;
  var ordersCourier = <OrderCourier>[].obs;

  final apiUrl = 'https://sdingserver.xyz/';
  final _cart = <Map<String, dynamic>>[].obs;
  var isAuthenticated = false.obs;

  List<Map<String, dynamic>> get cart => _cart;

  void addToCart(Item item, int quantity,
      {List<Suppliment> selectedSuppliments = const []}) {
    if (item.personalized) {
      _cart.add({
        'item': item,
        'quantity': quantity,
        'suppliments': selectedSuppliments
      });
    } else {
      final existingItemIndex =
          _cart.indexWhere((cartItem) => cartItem['item'].id == item.id);

      if (existingItemIndex != -1) {
        _cart[existingItemIndex]['quantity'] += quantity;
      } else {
        _cart.add({
          'item': item,
          'quantity': quantity,
          'suppliments': selectedSuppliments
        });
      }
    }
    LocalStorageHelper.saveCart(_cart);
  }

  void removeFromCart(int index) {
    _cart.removeAt(index);
    LocalStorageHelper.saveCart(_cart);
  }

  void clearCart() {
    _cart.clear();
    LocalStorageHelper.saveCart(_cart);
  }

  void increaseQuantity(int index) {
    _cart[index]['quantity']++;
    LocalStorageHelper.saveCart(_cart);
  }

  void decreaseQuantity(int index) {
    if (_cart[index]['quantity'] > 1) {
      _cart[index]['quantity']--;
      LocalStorageHelper.saveCart(_cart);
    }
  }

  String currentStatus = 'Delivery';

  Future<Map<String, dynamic>?> createOrder(
    String address,
    double total_price,
    double delivery_coast,
    int used_points,
    String comment,
  ) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final id = prefs.getInt('id');
      final double? latitude = prefs.getDouble('latitude');
      final double? longitude = prefs.getDouble('longitude');
      final List<Map<String, dynamic>> items = _cart.map((itm) {
        final Item item = itm['item'];
        final int quantity = itm['quantity'];
        final List<int> suppliments = (itm['suppliments'] as List<Suppliment>)
            .map<int>((suppliment) => suppliment.id)
            .toList();
        return {
          'item': item.id,
          'quantity': quantity,
          'suppliments': suppliments,
        };
      }).toList();

      print('List of item items: $items');

      final response = await http.post(
        Uri.parse('${apiUrl}delivery/orders/'),
        headers: <String, String>{
          'X-Mobile-App': 'true',
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'location': address,
          'total_price': total_price,
          'delivery_cost': delivery_coast,
          'items': items,
          'user': id,
          'eat': currentStatus,
          'latitude': latitude,
          'longitude': longitude,
          'used_points': used_points,
          'comment': comment,
        }),
      );

      if (response.statusCode == 201) {
        final Map<String, dynamic> order = jsonDecode(response.body);
        return order;
      } else {
        print('Response status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error creating order: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> createOrderCourier(
    String objectSent,
    String pickupAddress,
    double pickupLatitude,
    double pickupLongitude,
    String deliveryAddress,
    double deliveryLatitude,
    double deliveryLongitude,
    String recipientPhone,
    String status,
    DateTime? deliveryTime,
  ) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final id = prefs.getInt('id');

      final response = await http.post(
        Uri.parse('${apiUrl}delivery/ordersCourier/'),
        headers: <String, String>{
          'X-Mobile-App': 'true',
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'objectSent': objectSent,
          'pickup_address': pickupAddress,
          'pickup_latitude': pickupLatitude,
          'pickup_longitude': pickupLongitude,
          'delivery_address': deliveryAddress,
          'delivery_latitude': deliveryLatitude,
          'delivery_longitude': deliveryLongitude,
          'recipient_phone': recipientPhone,
          'delivery_time':
              deliveryTime != null ? deliveryTime.toIso8601String() : null,
          'user': id,
        }),
      );

      if (response.statusCode == 201) {
        final Map<String, dynamic> order = jsonDecode(response.body);
        return order;
      } else {
        print('Response status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error creating order courier: $e');
      return null;
    }
  }

  @override
  void onInit() {
    super.onInit();
    _loadCartFromStorage();
    fetchUserOrders();
    fetchUserOrdersCourier();
  }

  Future<void> _loadCartFromStorage() async {
    final List<Map<String, dynamic>> storedCart =
        await LocalStorageHelper.loadCart();
    _cart.assignAll(storedCart);
  }

  List<String> eatList = [
    'Delivery',
    'Take Out',
    'On The Spot',
  ];

  var isLoading = true.obs;

  Future<void> fetchUserOrders() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final id = prefs.getInt('id');
      final token = prefs.getString('token');
      if (id != null) {
        final response = await http.get(
          Uri.parse('${apiUrl}delivery/orders/'),
          headers: {
            'X-Mobile-App': 'true',
            'Accept-Language': 'ar',
            'Authorization': 'Bearer $token',
          },
        );
        if (response.statusCode == 200) {
          final List<Order> allOrders = List<Order>.from(
            jsonDecode(utf8.decode(response.bodyBytes))
                .map((item) => Order.fromJson(item)),
          );

          orders.value = allOrders.where((order) => order.user == id).toList();
        }
      } else {
        print('User ID not found');
      }
    } catch (e) {
      print('Failed to fetch orders: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchUserOrdersCourier() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final id = prefs.getInt('id');
      final token = prefs.getString('token');
      if (id != null) {
        final response = await http.get(
          Uri.parse('${apiUrl}delivery/ordersCourier/'),
          headers: {
            'X-Mobile-App': 'true',
            'Accept-Language': 'ar',
            'Authorization': 'Bearer $token',
          },
        );
        if (response.statusCode == 200) {
          final List<OrderCourier> allOrders = List<OrderCourier>.from(
            jsonDecode(utf8.decode(response.bodyBytes))
                .map((item) => OrderCourier.fromJson(item)),
          );

          ordersCourier.value =
              allOrders.where((order) => order.user == id).toList();
        }
      } else {
        print('User ID not found');
      }
    } catch (e) {
      print('Failed to fetch orders: $e');
    } finally {
      isLoading.value = false;
    }
  }

  var order = Order(
          id: 0,
          status: '',
          user: 0,
          items: [],
          location: '',
          order_id_returned: 0,
          total_price: '',
          createdAt: DateTime.now(),
          total_price_float: 0)
      .obs;

  var orderCourier = OrderCourier(
          id: 0,
          user: 0,
          status: '',
          createdAt: DateTime.now(),
          objectSent: '',
          pickupAddress: '',
          pickupLatitude: 0,
          pickupLongitude: 0,
          deliveryAddress: '',
          deliveryLatitude: 0,
          deliveryLongitude: 0,
          deliveryTime: DateTime.now(),
          recipientPhone: '',
          price: '')
      .obs;

  Future<void> fetchOrderStatus(int orderId) async {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      isLoading.value = true;
    });

    try {
      final response = await http.get(
          Uri.parse('https://sdingserver.xyz/delivery/orders/$orderId/'),
          headers: {
            'X-Mobile-App': 'true',
          });
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        order.value = Order(
            items: [],
            id: orderId,
            status: jsonData['status'],
            user: jsonData['user'],
            location: '',
            order_id_returned: jsonData['order_id_returned'],
            total_price: '',
            total_price_float: 0,
            createdAt: DateTime.now());
      } else {
        print('Failed to fetch order status');
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> sendFeedbackRating(int itemId, double rating) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final url = Uri.parse('https://sdingserver.xyz/delivery/ratings/');
    final response = await http.post(
      url,
      headers: <String, String>{
        'X-Mobile-App': 'true',
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, int>{
        'item': itemId,
        'rating': rating.toInt(),
      }),
    );

    if (response.statusCode == 200) {
      print('Feedback rating submitted successfully');
    } else {
      print('Failed to submit feedback rating');
      print('Response body: ${response.body}');
    }
  }

  // Future<void> sendFeedbackRatingStore(int storeId, double rating) async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   final token = prefs.getString('token');
  //   final url = Uri.parse('https://sdingserver.xyz/delivery/ratingsStore/');
  //   final response = await http.post(
  //     url,
  //     headers: <String, String>{
  //       'X-Mobile-App': 'true',
  //       'Content-Type': 'application/json; charset=UTF-8',
  //       'Authorization': 'Bearer $token',
  //     },
  //     body: jsonEncode(<String, int>{
  //       'store': storeId,
  //       'rating': rating.round(),
  //     }),
  //   );

  //   if (response.statusCode == 200) {
  //     print('Feedback rating submitted successfully');
  //   } else {
  //     print('Failed to submit feedback rating');
  //     print('Response body: ${response.body}');
  //   }
  // }

  Future<void> sendFeedbackRatingStore(int storeId, double rating) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final url = Uri.parse('https://sdingserver.xyz/delivery/ratingsStore/');

    // Temporary: bypass SSL certificate errors (dev only!)
    HttpClient httpClient = HttpClient()
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
    IOClient ioClient = IOClient(httpClient);

    final response = await ioClient.post(
      url,
      headers: <String, String>{
        'X-Mobile-App': 'true',
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, int>{
        'store': storeId,
        'rating': rating.round(),
      }),
    );

    if (response.statusCode == 200) {
      print('Feedback rating submitted successfully');
    } else {
      print('Failed to submit feedback rating');
      print('Response body: ${response.body}');
    }

    ioClient.close();
  }

  Future<bool> updateOrderStatus(int orderId, String newStatus) async {
    try {
      final response = await http.put(
        Uri.parse('https://sdingserver.xyz/delivery/orders/$orderId/status/'),
        headers: {
          'X-Mobile-App': 'true',
        },
        body: {
          'status': newStatus,
        },
      );
      if (response.statusCode == 200) {
        print('Status updated successfully');
        return true;
      } else {
        print('Failed to update status: ${response.statusCode}');
        print('Failed to update status: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Failed to update status: $e');
      return false;
    }
  }
}

class LoginController extends GetxController {
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final apiUrl = 'https://sdingserver.xyz/accounts/api/auth/login/';
  var isLoading = false.obs;
  final isPasswordVisible = false.obs;
  final RxBool isAuthenticated = false.obs;

  void onInit() {
    super.onInit();
    checkAuthStatus();
    saveUserToken();
  }

  Future<void> checkAuthStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token != null) {
      isAuthenticated.value = true;
    }
  }

  Future<bool> loginUser(String username, String password) async {
    try {
      isLoading(true);
      final response = await http.post(Uri.parse(apiUrl),
          headers: {'X-Mobile-App': 'true', 'Content-type': 'application/json'},
          body: json.encode({'username': username, 'password': password}));
      isLoading(false);
      if (response.statusCode == 200) {
        Map<String, dynamic> responseMap = json.decode(response.body);
        final token = responseMap['access'];
        final id = responseMap['user']['pk'];
        final username = responseMap['user']['username'];
        await saveToken(token);
        await saveId(id);
        await saveUsername(username);
        print(token);
        print(id);
        print(username);
        isAuthenticated.value = true;
        return true;
      } else {
        print(response.statusCode);
        return false;
      }
    } catch (e) {
      isLoading(false);
      return false;
    }
  }

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  RxString token = ''.obs;
  Future<void> loadToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    token.value = prefs.getString('token') ?? '';
  }

  Future<void> logout() async {
    print('token');
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    print('token');
    isAuthenticated.value = false;
    prefs.remove('id');
    prefs.remove('username');
  }

  Future<void> saveId(int id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('id', id);
  }

  RxInt id = 0.obs;
  Future<void> loadId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    id.value = prefs.getInt('id') ?? 0;
  }

  Future<void> saveUsername(String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
  }

  RxString username = ''.obs;
  Future<void> loadUsername() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    username.value = prefs.getString('username') ?? '';
  }

  Future<void> saveUserToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      int? userId = prefs.getInt('id');

      if (userId == null) {
        print('User ID is null, cannot send token');
        return;
      }

      if (token != null) {
        final response = await http.post(
          Uri.parse("https://sdingserver.xyz/accounts/api/save-token/"),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({"user_id": userId, "fcm_token": token}),
        );
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error sending token: $e');
    }
  }
}

class SignUpController extends GetxController {
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final apiUrl = 'https://sdingserver.xyz/accounts/dj-rest-auth/registration/';
  var isLoading = false.obs;
  final isPasswordVisible = false.obs;
  final isPasswordConfirmVisible = false.obs;

  final LoginController loginController = Get.put(LoginController());

  Future<bool> registerUser(
      String username, String email, String password1, String password2) async {
    try {
      isLoading(true);
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-type': 'application/json'},
        body: json.encode({
          'username': username,
          'email': email,
          'password1': password1,
          'password2': password2
        }),
      );

      if (response.statusCode == 201) {
        // Successful registration
        Map<String, dynamic> responseMap = json.decode(response.body);
        final token = responseMap['access'];
        final id = responseMap['user']['pk'];
        final username = responseMap['user']['username'];

        // Save token and user info
        await loginController.saveToken(token);
        await loginController.saveId(id);
        await loginController.saveUsername(username);

        loginController.isAuthenticated.value = true;
        isLoading(false);
        return true;
      } else {
        // Handle other status codes
        isLoading(false);
        String errorMessage = 'Error occurred (${response.statusCode}): ';

        try {
          Map<String, dynamic> errorMap = json.decode(response.body);
          if (errorMap.containsKey('username')) {
            errorMessage += errorMap['username'][0];
          } else if (errorMap.containsKey('detail')) {
            errorMessage += errorMap['detail'];
          } else if (errorMap.containsKey('non_field_errors')) {
            errorMessage += errorMap['non_field_errors'][0];
          } else if (errorMap.containsKey('password1')) {
            errorMessage += errorMap['password1'][0];
          } else {
            errorMessage += 'Unknown error';
          }
        } catch (e) {
          errorMessage += 'Unknown error parsing response';
          print('Exception decoding error response: $e');
        }

        if (errorMessage.contains('password')) {
          errorMessage =
              'Password must contain a number, a capital letter, and a small letter.';
        }

        Get.dialog(
          AlertDialog(
            title: Text('Error'),
            content: Text(errorMessage),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: Text('OK'),
              ),
            ],
          ),
        );
        return false;
      }
    } catch (e) {
      // Handle general exceptions
      isLoading(false);
      print('Error: $e');
      return false;
    }
  }

  Future<void> updateProfile(User user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final id = user.id;

    try {
      final response = await http.patch(
        Uri.parse('https://sdingserver.xyz/accounts/api/user-profiles/$id/'),
        headers: {
          'X-Mobile-App': 'true',
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'username': user.username,
          // 'mobile': user.mobile,
          // 'address': user.address,
        }),
      );

      if (response.statusCode == 200) {
        final updatedProfile = User.fromJson(json.decode(response.body));
        print('Profile updated successfully');
      } else {
        print(response.statusCode);
        throw Exception('Failed to update user profile');
      }
    } catch (e) {
      print('Exception during updateProfile: $e');
    }
  }
}

class FormController extends GetxController {
  var name = ''.obs;
  var phoneNumber = ''.obs;

  Future<void> submitForm(BuildContext context) async {
    final url = 'https://sdingserver.xyz/delivery/deliveryForm/';
    final headers = {
      'X-Mobile-App': 'true',
      'Content-Type': 'application/json'
    };
    final body = json.encode({
      'name': name.value,
      'phone_number': phoneNumber.value,
    });

    try {
      final response =
          await http.post(Uri.parse(url), headers: headers, body: body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.defaultDialog(
          title: 'Success',
          middleText: 'Form submitted successfully!',
          textConfirm: 'OK',
          confirmTextColor: Colors.white,
          onConfirm: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => MenuScreen(),
              ),
              (Route<dynamic> route) => false,
            );
          },
        );
      } else {
        Get.defaultDialog(
          title: 'Error',
          middleText: 'Failed to submit form.',
          textConfirm: 'OK',
          confirmTextColor: Colors.white,
          onConfirm: () {
            Get.back();
          },
        );
      }
    } catch (e) {
      Get.defaultDialog(
        title: 'Error',
        middleText: 'An error occurred: $e',
        textConfirm: 'OK',
        confirmTextColor: Colors.white,
        onConfirm: () {
          Get.back();
        },
      );
    }
  }

  var nameStore = ''.obs;
  var phoneNumberStore = ''.obs;

  Future<void> submitStoreForm(BuildContext context) async {
    final url = 'https://sdingserver.xyz/delivery/storeForm/';
    final headers = {
      'X-Mobile-App': 'true',
      'Content-Type': 'application/json'
    };
    final body = json.encode({
      'name': nameStore.value,
      'phone_number': phoneNumberStore.value,
    });

    try {
      final response =
          await http.post(Uri.parse(url), headers: headers, body: body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.defaultDialog(
          title: 'Success',
          middleText: 'Form submitted successfully!',
          textConfirm: 'OK',
          confirmTextColor: Colors.white,
          onConfirm: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => MenuScreen(),
              ),
              (Route<dynamic> route) => false,
            );
          },
        );
      } else {
        Get.defaultDialog(
          title: 'Error',
          middleText: 'Failed to submit form.',
          textConfirm: 'OK',
          confirmTextColor: Colors.white,
          onConfirm: () {
            Get.back();
          },
        );
      }
    } catch (e) {
      Get.defaultDialog(
        title: 'Error',
        middleText: 'An error occurred: $e',
        textConfirm: 'OK',
        confirmTextColor: Colors.white,
        onConfirm: () {
          Get.back();
        },
      );
    }
  }
}

class ChangePasswordController extends GetxController {
  final apiUrl = 'https://sdingserver.xyz/accounts/api/auth/password/change/';
  var isLoading = false.obs;

  Future<bool> changePassword(
      String newPassword, String confirmPassword) async {
    final token = await getToken();

    final response = await http.post(Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-type': 'application/json'
        },
        body: json.encode(
            {'new_password1': newPassword, 'new_password2': confirmPassword}));
    isLoading(false);
    if (response.statusCode == 200) {
      print(response.statusCode);
      print(response.body);
      return true;
    } else {
      print(response.statusCode);
      return false;
    }
  }

  Future<String> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token') ?? '';
  }
}
