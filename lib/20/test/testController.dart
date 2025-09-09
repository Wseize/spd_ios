import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:spooding_exp_ios/model.dart';
import 'dart:math';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationController extends GetxController {
  Rx<Position?> currentPosition = Rx<Position?>(null);
  String locationName = '';
  String locationNameCountry = '';
  double maxDistance = 13.0;

  @override
  void onInit() {
    super.onInit();
    _initCurrentPosition();
    _getLocationPermission();
  }

  // Future<void> _initCurrentPosition() async {
  //   Position? savedPosition = await getSavedPosition();
  //   if (savedPosition != null) {
  //     currentPosition.value = savedPosition;
  //     _updateLocationData(savedPosition);
  //   }
  // }

  // Future<void> refreshCurrentPosition() async {
  //   await _initCurrentPosition();
  // }

  // void _getLocationPermission() async {
  //   LocationPermission permission = await Geolocator.requestPermission();
  //   if (permission == LocationPermission.denied ||
  //       permission == LocationPermission.deniedForever) {
  //     print('Location permission denied');
  //   } else {
  //     await _getCurrentLocation();
  //   }
  // }

  // Future<void> _getCurrentLocation() async {
  //   try {
  //     Position position = await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.high,
  //     );
  //     updateFromSelectedPosition(position);
  //   } catch (e) {
  //     print('Location error: $e');
  //   }
  // }

  // void updateFromSelectedPosition(Position position) {
  //   currentPosition.value = position;
  //   _saveCurrentPosition(position);
  //   _updateLocationData(position);
  //   update();
  // }

  // Future<void> _updateLocationData(Position position) async {
  //   final url =
  //       'https://nominatim.openstreetmap.org/reverse?lat=${position.latitude}&lon=${position.longitude}&format=json&addressdetails=1';
  //   final response = await http.get(
  //     Uri.parse(url),
  //     headers: {'User-Agent': 'spooding-web'},
  //   );

  //   if (response.statusCode == 200) {
  //     final data = json.decode(response.body);
  //     locationName = data['address']['state'] ?? 'Inconnu';
  //     locationNameCountry = data['address']['country'] ?? 'Inconnu';
  //     update();
  //   } else {
  //     print('Failed to fetch location info');
  //   }
  // }

  // Future<void> _saveCurrentPosition(Position position) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.setDouble('latitude', position.latitude);
  //   await prefs.setDouble('longitude', position.longitude);
  // }

  // Future<Position?> getSavedPosition() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final double? latitude = prefs.getDouble('latitude');
  //   final double? longitude = prefs.getDouble('longitude');
  //   if (latitude != null && longitude != null) {
  //     return Position(
  //       latitude: latitude,
  //       longitude: longitude,
  //       timestamp: DateTime.now(),
  //       accuracy: 0.0,
  //       altitude: 0.0,
  //       heading: 0.0,
  //       speed: 0.0,
  //       speedAccuracy: 0.0,
  //       headingAccuracy: 0.0,
  //       altitudeAccuracy: 0.0,
  //     );
  //   }
  //   return null;
  // }

  // double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
  //   const earthRadius = 6371.0; // km
  //   final dLat = _degToRad(lat2 - lat1);
  //   final dLon = _degToRad(lon2 - lon1);
  //   final a = sin(dLat / 2) * sin(dLat / 2) +
  //       cos(_degToRad(lat1)) *
  //           cos(_degToRad(lat2)) *
  //           sin(dLon / 2) *
  //           sin(dLon / 2);
  //   final c = 2 * atan2(sqrt(a), sqrt(1 - a));
  //   return earthRadius * c;
  // }

  // double _degToRad(double deg) => deg * pi / 180;

  Store findStoreByItemId(int itemId, CategoryController categoryController) {
    for (var store in categoryController.stores) {
      if (store.items.any((item) => item.id == itemId)) {
        return store;
      }
    }
    return Store(
      id: 0,
      name: 'unknown',
      image: '',
      phoneNumber: '',
      country: 'unknown',
      governorate: 'unknown',
      available: false,
      items: [],
      latitude: 0,
      longitude: 0,
      average_rating: 0,
      favorited_by: [],
      category: 0,
      ratings: [],
      free_delivery: false,
      firstItemImage: '',
      has_discounted_item: false,
    );
  }

  /// يرجع قائمة المتاجر القريبة حسب currentPosition و maxDistance
  List<Store> findNearbyStores(CategoryController categoryController) {
    if (currentPosition.value == null) return [];
    return categoryController.stores.where((store) {
      final d = calculateDistance(
        currentPosition.value!.latitude,
        currentPosition.value!.longitude,
        store.latitude,
        store.longitude,
      );
      return d <= maxDistance;
    }).toList();
  }

  // Position? currentPosition;
  // String locationName = '';
  // String locationNameCountry = '';
  // double maxDistance = 13.0;

  Future<void> _initCurrentPosition() async {
    Position? savedPosition = await getSavedPosition();
    if (savedPosition != null) {
      currentPosition.value = savedPosition;
      print(
          'Initialized with saved position: Latitude: ${currentPosition.value!.latitude}, Longitude: ${currentPosition.value!.longitude}');
      _updateLocationData(savedPosition);
    } else {
      print('No saved position found, will try to get current location.');
    }
    _checkPositionAndNavigate();
  }

  Future<void> refreshCurrentPosition() async {
    await _initCurrentPosition();
    _checkPositionAndNavigate();
  }

  void _getLocationPermission() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      print('Location permission denied');
    } else {
      _getCurrentLocation();
    }
    _checkPositionAndNavigate();
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      _updateLocationData(position);
      _saveCurrentPosition(position);
    } catch (e) {
      if (e is LocationServiceDisabledException) {
        print('Location service is disabled on the device.');
      } else {
        print('Error: $e');
      }
    }
    _checkPositionAndNavigate();
  }

  void _checkPositionAndNavigate() {
    if (currentPosition.value == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (Get.isOverlaysOpen == false && Get.context != null) {
          Get.offNamed('/check-location');
        }
      });
    }
  }

  void _updateLocationData(Position position) async {
    final url =
        'https://nominatim.openstreetmap.org/reverse?lat=${position.latitude}&lon=${position.longitude}&format=json&addressdetails=1';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final address = data['address']['state'];
      final addressCountry = data['address']['country'];

      currentPosition.value = position;
      locationName = address;
      locationNameCountry = addressCountry;
      update();
      print('Location updated: $locationName, $locationNameCountry');
    } else {
      print('Failed to fetch location data: ${response.statusCode}');
    }
  }

  void _saveCurrentPosition(Position position) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('latitude', position.latitude);
    await prefs.setDouble('longitude', position.longitude);
    print(
        'Saved position: Latitude: ${position.latitude}, Longitude: ${position.longitude}');
  }

  Future<Position?> getSavedPosition() async {
    final prefs = await SharedPreferences.getInstance();
    final double? latitude = prefs.getDouble('latitude');
    final double? longitude = prefs.getDouble('longitude');
    if (latitude != null && longitude != null) {
      print(
          'Retrieved saved position: Latitude: $latitude, Longitude: $longitude');
      return Position(
        latitude: latitude,
        longitude: longitude,
        timestamp: DateTime.now(),
        accuracy: 0.0,
        altitude: 0.0,
        heading: 0.0,
        speed: 0.0,
        speedAccuracy: 0.0,
        headingAccuracy: 0.0,
        altitudeAccuracy: 0.0,
      );
    } else {
      print('No saved position found');
    }
    return null;
  }

  Future<void> checkAndUpdateCurrentPosition() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      await _getCurrentLocation();
    } else {
      _getLocationPermission();
    }
  }

  double calculateDistance(double currentLatitude, double currentLongitude,
      double shopLatitude, double shopLongitude) {
    const earthRadius = 6371.0;

    final startLatRad = degreesToRadians(currentLatitude);
    final endLatRad = degreesToRadians(shopLatitude);
    final latDiffRad = degreesToRadians(shopLatitude - currentLatitude);
    final lonDiffRad = degreesToRadians(shopLongitude - currentLongitude);

    final a = pow(sin(latDiffRad / 2), 2) +
        cos(startLatRad) * cos(endLatRad) * pow(sin(lonDiffRad / 2), 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    final distance = earthRadius * c;

    return distance;
  }

  double degreesToRadians(double degrees) {
    return degrees * pi / 180.0;
  }
}

class CategoryController extends GetxController {
  final LocationController locationController = Get.put(LocationController());
  var stores = <Store>[].obs;
  var publicities = <Publicity>[].obs;
  var isLoading = false.obs;

  final TextEditingController searchController = TextEditingController();
  RxList<Store> filteredStores = <Store>[].obs;

  Future<void> fetchStoresBasic() async {
    try {
      isLoading.value = true;

      final response = await http.get(
        Uri.parse('https://sdingserver.xyz/delivery/stores-basic/'),
        headers: {'X-Mobile-App': 'true'},
      );

      if (response.statusCode == 200) {
        final decodedBody = utf8.decode(response.bodyBytes);
        var jsonList = json.decode(decodedBody) as List;

        stores.value =
            jsonList.map((storeJson) => Store.fromJson(storeJson)).toList();

        // مسح الفلترة لأننا نشوفوا الكل
        filteredStores.clear();
      } else {
        print('Server error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching stores basic: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void searchStores(String query) {
    if (query.length < 2) {
      filteredStores.clear();
      return;
    }

    filteredStores.value = stores
        .where(
          (store) => store.name.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
  }

  final selectedStore = Rxn<Store>();
  final isLoadingStoreItems = false.obs;

  // باقي الخصائص...

  // Future<void> fetchStoreWithItems(int storeId) async {
  //   try {
  //     isLoadingStoreItems.value = true;

  //     final response = await http.get(
  //       Uri.parse('https://sdingserver.xyz/delivery/stores/$storeId/'),
  //       headers: {'X-Mobile-App': 'true'},
  //     );

  //     if (response.statusCode == 200) {
  //       final decodedBody = utf8.decode(response.bodyBytes);
  //       var jsonMap = json.decode(decodedBody);
  //       var store = Store.fromJson(jsonMap);

  //       selectedStore.value = store;

  //       // تحديث القائمة العامة إذا تحب
  //       int index = stores.indexWhere((s) => s.id == store.id);
  //       if (index != -1) {
  //         stores[index] = store;
  //       } else {
  //         stores.add(store);
  //       }
  //     } else {
  //       print('Error fetching store: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     print('Exception: $e');
  //   } finally {
  //     isLoadingStoreItems.value = false;
  //   }
  // }

  final Map<int, Store> _cachedStores = {};

  Future<void> fetchStoreWithItems(int storeId) async {
    // إذا موجود في الكاش، نستعمله على طول
    if (_cachedStores.containsKey(storeId)) {
      selectedStore.value = _cachedStores[storeId]!;
      return;
    }

    try {
      isLoadingStoreItems.value = true;

      final response = await http.get(
        Uri.parse('https://sdingserver.xyz/delivery/stores/$storeId/'),
        headers: {'X-Mobile-App': 'true'},
      );

      if (response.statusCode == 200) {
        final decodedBody = utf8.decode(response.bodyBytes);
        var jsonMap = json.decode(decodedBody);
        var store = Store.fromJson(jsonMap);

        selectedStore.value = store;

        // نضيف للكاش
        _cachedStores[storeId] = store;

        // تحديث القائمة العامة
        int index = stores.indexWhere((s) => s.id == store.id);
        if (index != -1) {
          stores[index] = store;
        } else {
          stores.add(store);
        }
      } else {
        print('Error fetching store: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception: $e');
    } finally {
      isLoadingStoreItems.value = false;
    }
  }

  Future<void> fetchPublicities() async {
    try {
      final response = await http.get(
        Uri.parse('https://sdingserver.xyz/delivery/publicities/'),
        headers: {'X-Mobile-App': 'true'},
      );

      if (response.statusCode == 200) {
        isLoading.value = true;
        final decodedBody = utf8.decode(response.bodyBytes);
        var jsonList = json.decode(decodedBody) as List;

        List<Publicity> fetchedPublicities = jsonList.map((itemJson) {
          Publicity publicity = Publicity.fromJson(itemJson);
          return publicity;
        }).toList();

        if (locationController.currentPosition != null) {
          double maxDistance = locationController.maxDistance;
          fetchedPublicities = fetchedPublicities.where((publicity) {
            double distance = locationController.calculateDistance(
              locationController.currentPosition.value!.latitude,
              locationController.currentPosition.value!.longitude,
              publicity.latitude, // Update this if the structure is different
              publicity.longitude, // Update this if the structure is different
            );
            return distance <= maxDistance;
          }).toList();
        }

        // Update the publicities value with the filtered list
        publicities.value = fetchedPublicities;
      } else {
        print('Server error: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      print('Error fetching data: $e');
      print('Stack trace: $stackTrace');
    } finally {
      isLoading.value = false;
    }
  }

  RxList<SubCategory> subCategories = <SubCategory>[].obs;

  Future<void> fetchSubCategories() async {
    try {
      final response = await http.get(
        Uri.parse("https://sdingserver.xyz/delivery/sub-categories-basic/"),
        headers: {'X-Mobile-App': 'true'},
      );

      if (response.statusCode == 200) {
        final decoded = json.decode(utf8.decode(response.bodyBytes)) as List;
        subCategories.value =
            decoded.map((e) => SubCategory.fromJson(e)).toList();
      } else {
        print("Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching sub-categories: $e");
    }
  }

  var items = <Item>[].obs;
  var isLoadingItems = false.obs;

  // Future<void> fetchItemsBySubCategory(int subCategoryId) async {
  //   try {
  //     isLoadingItems.value = true;
  //     final url = Uri.parse(
  //       "https://sdingserver.xyz/delivery/sub-categories/$subCategoryId/",
  //     );
  //     final response = await http.get(url, headers: {'X-Mobile-App': 'true'});

  //     if (response.statusCode == 200) {
  //       final Map<String, dynamic> decoded = json.decode(
  //         utf8.decode(response.bodyBytes),
  //       );
  //       final List<dynamic> itemsJson = decoded['items'] ?? [];
  //       items.value = itemsJson.map((e) => Item.fromJson(e)).toList();
  //     } else {
  //       print("Erreur serveur: ${response.statusCode}");
  //       items.clear();
  //     }
  //   } catch (e) {
  //     print("Erreur: $e");
  //     items.clear();
  //   } finally {
  //     isLoadingItems.value = false;
  //   }
  // }

  final Map<int, List<Item>> _cachedItems = {};

  Future<void> fetchItemsBySubCategory(int subCategoryId) async {
    // لو موجودة في الكاش، نرجعها فوراً بدون تحميل
    if (_cachedItems.containsKey(subCategoryId)) {
      items.value = _cachedItems[subCategoryId]!;
      return;
    }

    try {
      isLoadingItems.value = true;
      final url = Uri.parse(
        "https://sdingserver.xyz/delivery/sub-categories/$subCategoryId/",
      );
      final response = await http.get(url, headers: {'X-Mobile-App': 'true'});

      if (response.statusCode == 200) {
        final Map<String, dynamic> decoded = json.decode(
          utf8.decode(response.bodyBytes),
        );
        final List<dynamic> itemsJson = decoded['items'] ?? [];
        final fetchedItems = itemsJson.map((e) => Item.fromJson(e)).toList();

        // خزّن البيانات في الكاش
        _cachedItems[subCategoryId] = fetchedItems;

        items.value = fetchedItems;
      } else {
        print("Erreur serveur: ${response.statusCode}");
        items.clear();
      }
    } catch (e) {
      print("Erreur: $e");
      items.clear();
    } finally {
      isLoadingItems.value = false;
    }
  }

  @override
  void onInit() {
    fetchStoresBasic();
    fetchSubCategories();
    super.onInit();
  }

  var notices = <Notice>[].obs;
  var user = <User>[].obs;

  Future<void> fetchNoticeStores() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    isLoading.value = true;

    try {
      final response = await http.get(
        Uri.parse('https://sdingserver.xyz/delivery/notices/'),
        headers: {'X-Mobile-App': 'true', 'Authorization': 'Bearer $token'},
      );
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        // Decode the response body using UTF-8
        final decodedBody = utf8.decode(response.bodyBytes);
        var jsonList = json.decode(decodedBody) as List;
        notices.value = jsonList.map((storeJson) {
          print(storeJson);
          return Notice.fromJson(storeJson);
        }).toList();
        print('Notices fetched: ${notices.length}');
      } else {
        // Handle server errors
        print('Server error: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      print('Error fetching data: $e');
      print('Stack trace: $stackTrace');
    } finally {
      isLoading.value = false; // Stop loading
    }
  }

  Future<void> createNotice(String noticeText, int storeId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    try {
      final response = await http.post(
        Uri.parse('https://sdingserver.xyz/delivery/notices/'),
        headers: {
          'X-Mobile-App': 'true',
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'user_name': userProfile.value.username,
          'notice': noticeText,
          'store': storeId,
        }),
      );

      if (response.statusCode == 201) {
        // Notice created successfully
        fetchNoticeStores(); // Refresh notices list
      } else {
        // Handle error
        print('Error creating notice: ${response.statusCode}');
      }
    } catch (e) {
      print('Error creating notice: $e');
    }
  }

  Future<void> deleteNotice(int noticeId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    try {
      final response = await http.delete(
        Uri.parse('https://sdingserver.xyz/delivery/notices/$noticeId/'),
        headers: {'X-Mobile-App': 'true', 'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        // Notice deleted successfully
        fetchNoticeStores(); // Refresh notices list
      } else {
        // Handle error
        print('Error deleting notice: ${response.statusCode}');
      }
    } catch (e) {
      print('Error deleting notice: $e');
    }
  }

  final Rx<User> userProfile = User(
    id: 0,
    username: '',
    // mobile: '',
    isNotBlocked: true,
  ).obs;

  Future<void> fetchUserProfile() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final id = prefs.getInt('id');

    try {
      final response = await http.get(
        Uri.parse('https://sdingserver.xyz/accounts/api/user-profiles/$id/'),
        headers: {'X-Mobile-App': 'true', 'Authorization': 'Bearer $token'},
      );

      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final userProfileData = User.fromJson(json.decode(response.body));
        userProfile.value = userProfileData;
        print(userProfileData);
      } else {
        print('Failed to load user profile: ${response.body}');
        throw Exception('Failed to load user profile');
      }
    } catch (e) {
      print('Exception during fetchUserProfile: $e');
    }
  }

  Future<void> updateProfile(User user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final username = prefs.getString('username');
    final id = prefs.getInt('id');

    try {
      final Map<String, dynamic> requestBody = {
        'username': username,
        // 'mobile': user.mobile,
      };

      final response = await http.patch(
        Uri.parse('https://sdingserver.xyz/accounts/api/user-profiles/$id/'),
        headers: {
          'X-Mobile-App': 'true',
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final updatedProfile = User.fromJson(json.decode(response.body));
        userProfile.value = updatedProfile;
        print('Profile updated successfully');
      } else {
        print(response.statusCode);
        print('Response Body: ${response.body}'); // Debug print
        print('Response Headers: ${response.headers}'); // Debug print
        throw Exception('Failed to update user profile');
      }
    } catch (e) {
      print('Exception during updateProfile: $e');
    }
  }

  Future<void> addFavoritestore(int storeId) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final userId = prefs.getInt('id');

      final response = await http.post(
        Uri.parse(
          'https://sdingserver.xyz/accounts/api/user-profiles/$userId/add-favorite/',
        ),
        headers: {
          'X-Mobile-App': 'true',
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'store_id': storeId}),
      );

      if (response.statusCode == 200) {
        await fetchUserProfile();
        // await fetchStoreWithItems();
        print('store added to favorites successfully');
      } else {
        print('Failed to add store to favorites');
      }
    } catch (e) {
      print('Exception during addFavoritestore: $e');
    }
  }

  Future<void> removeFavoritestore(int storeId) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final userId = prefs.getInt('id');

      final response = await http.post(
        Uri.parse(
          'https://sdingserver.xyz/accounts/api/user-profiles/$userId/remove-favorite/',
        ),
        headers: {
          'X-Mobile-App': 'true',
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'store_id': storeId}),
      );

      if (response.statusCode == 200) {
        await fetchUserProfile();
        // await fetchStores();
        print('store removed from favorites successfully');
      } else {
        print('Failed to remove store from favorites');
      }
    } catch (e) {
      print('Exception during removeFavoritestore: $e');
    }
  }

  Future<void> fetchFavoriteVendors() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      isLoading.value = true;
    });
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final userId = prefs.getInt('id');

      final response = await http.get(
        Uri.parse(
          'https://sdingserver.xyz/accounts/api/user-profiles/$userId/favorite-stores/',
        ),
        headers: {'X-Mobile-App': 'true', 'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        List<Store> fetchedFavoriteStores =
            data.map((item) => Store.fromJson(item)).toList();

        favoriteVendors.assignAll(fetchedFavoriteStores);
        print(response.body);
      } else {
        print('Failed to fetch favorite vendors: ${response.statusCode}');
        throw Exception('Failed to fetch favorite vendors');
      }
    } catch (e) {
      print('Exception during fetchFavoriteVendors: $e');
    } finally {
      isLoading.value = false;
    }
  }

  final RxList<Store> favoriteVendors = <Store>[].obs;
  bool isFavorite(int vendorId) {
    return favoriteVendors.any((vendor) => vendor.id == vendorId);
  }
}

class ToutController extends GetxController {
  final CategoryController categoryController = Get.put(CategoryController());
  RxString selectedSort = 'asc'.obs;
  RxBool freeDeliveryOnly = false.obs;
  final showMore = false.obs;

  RxList<Item> recommendedItems = <Item>[].obs;
  RxBool isLoadingRecommended = false.obs;
  RxList<Item> discountedItems = <Item>[].obs;
  RxBool isLoadingDiscount = false.obs;
  @override
  void onInit() {
    super.onInit();
    fetchDiscountItems();
    fetchRecommendedItems();
  }

  Future<void> fetchRecommendedItems() async {
    try {
      isLoadingRecommended.value = true;
      final response = await http.get(
        Uri.parse('https://sdingserver.xyz/delivery/recommended-items/'),
        headers: {'X-Mobile-App': 'true'},
      );
      if (response.statusCode == 200) {
        final decoded = json.decode(utf8.decode(response.bodyBytes)) as List;
        recommendedItems.value = decoded.map((e) => Item.fromJson(e)).toList();
      } else {
        print('Recommend API error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error loading recommendations: $e');
    } finally {
      isLoadingRecommended.value = false;
    }
  }

  Future<void> fetchDiscountItems() async {
    try {
      isLoadingDiscount.value = true;
      final response = await http.get(
        Uri.parse('https://sdingserver.xyz/delivery/discounted/'),
        headers: {'X-Mobile-App': 'true'},
      );
      if (response.statusCode == 200) {
        final decoded = json.decode(utf8.decode(response.bodyBytes)) as List;
        discountedItems.value = decoded.map((e) => Item.fromJson(e)).toList();
      } else {
        print('Discount API error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error loading recommendations: $e');
    } finally {
      isLoadingDiscount.value = false;
    }
  }

  var searchText = ''.obs;

  var filteredSearchStores = <Store>[].obs;
  var filteredSearchItems = <Item>[].obs;

  // final CategoryController categoryController = Get.find();

  void search(String query) {
    searchText.value = query.trim();

    if (searchText.value.isEmpty) {
      filteredSearchStores.value = [];
      filteredSearchItems.value = [];
      return;
    }

    filteredSearchStores.value = categoryController.stores.where((store) {
      return store.name.toLowerCase().contains(searchText.value.toLowerCase());
    }).toList();

    // Assuming you have a flat list of items somewhere
    List<Item> allItems = [];
    for (var store in categoryController.stores) {
      allItems.addAll(store.items);
    }

    filteredSearchItems.value = allItems.where((item) {
      return item.name.toLowerCase().contains(searchText.value.toLowerCase());
    }).toList();
  }

  String getStoreNameById(int storeId, List<Store> stores) {
    final store = stores.firstWhere(
      (store) => store.id == storeId,
      orElse: () => Store(
        id: 0,
        name: 'Inconnu',
        available: false,
        image: '',
        category: 0,
        phoneNumber: '',
        country: '',
        governorate: '',
        items: [],
        latitude: 0,
        longitude: 0,
        ratings: [],
        average_rating: 0,
        favorited_by: [],
        free_delivery: false,
        firstItemImage: '',
        has_discounted_item: false,
      ),
    );
    return store.name;
  }
}
