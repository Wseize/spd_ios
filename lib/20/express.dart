import 'dart:ui' as ui;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:spooding_exp_ios/20/test/category.dart';
import 'package:spooding_exp_ios/20/test/promotion.dart';
import 'package:spooding_exp_ios/20/test/testController.dart';
import 'package:spooding_exp_ios/20/test/testStore.dart';
import 'package:spooding_exp_ios/20/view/about.dart';
import 'package:spooding_exp_ios/20/view/courier.dart';
import 'package:spooding_exp_ios/20/view/favorite.dart';
import 'package:spooding_exp_ios/20/view/itemsPage.dart';
import 'package:spooding_exp_ios/20/view/loginScreen.dart';
import 'package:spooding_exp_ios/20/view/order.dart';
import 'package:spooding_exp_ios/20/view/profil.dart';
import 'package:spooding_exp_ios/20/view/signUpScreen.dart';
import 'package:spooding_exp_ios/20/view/trackMyOrder.dart';
import 'package:spooding_exp_ios/20/view/wallet/carnet.dart';
import 'package:spooding_exp_ios/20/view/wallet/view.dart';
import 'package:spooding_exp_ios/controller.dart';
import 'package:spooding_exp_ios/localization/changeLocal.dart';
import 'package:spooding_exp_ios/model.dart';

// class ToutController extends GetxController {
//   final CategoryController categoryController = Get.put(CategoryController());

//   // RxString selectedSubCategory = ''.obs;
//   // RxList<String> subCategories = <String>[].obs;
//   RxString selectedSort = 'asc'.obs;
//   RxBool freeDeliveryOnly = false.obs;
//   final showMore = false.obs;

//   RxList<Item> recommendedItems = <Item>[].obs;
//   RxBool isLoadingRecommended = false.obs;

//   @override
//   void onInit() {
//     super.onInit();

//     fetchRecommendedItems();
//   }

//   Future<void> fetchRecommendedItems() async {
//     try {
//       isLoadingRecommended.value = true;
//       final response = await http.get(
//         Uri.parse('https://sdingserver.xyz/delivery/recommended-items/'),
//         headers: {'X-Mobile-App': 'true'},
//       );
//       if (response.statusCode == 200) {
//         final decoded = json.decode(utf8.decode(response.bodyBytes)) as List;
//         recommendedItems.value = decoded.map((e) => Item.fromJson(e)).toList();
//       } else {
//         print('Recommend API error: ${response.statusCode}');
//       }
//     } catch (e) {
//       print('Error loading recommendations: $e');
//     } finally {
//       isLoadingRecommended.value = false;
//     }
//   }

//   // Future<void> fetchTypeCategories() async {
//   //   try {
//   //     isLoading.value = true;
//   //     final response = await http.get(
//   //       Uri.parse('https://sdingserver.xyz/delivery/typecategories/'),
//   //       headers: {'X-Mobile-App': 'true'},
//   //     );

//   //     if (response.statusCode == 200) {
//   //       final decodedBody = utf8.decode(response.bodyBytes);
//   //       final List<dynamic> jsonList = json.decode(decodedBody);

//   //       typecategories.value =
//   //           jsonList.map((e) => TypeCategory.fromJson(e)).toList();

//   //       final allSubCategories = <String>{};
//   //       for (var type in typecategories) {
//   //         for (var store in type.stores) {
//   //           for (var item in store.items) {
//   //             if (item.sub_category_name != null) {
//   //               allSubCategories.add(item.sub_category_name!);
//   //             }
//   //           }
//   //         }
//   //       }
//   //       subCategories.value = allSubCategories.toList();

//   //       if (subCategories.isNotEmpty) {
//   //         selectedSubCategory.value = subCategories.first;
//   //       }
//   //     } else {
//   //       print("Error: ${response.statusCode}");
//   //     }
//   //   } catch (e) {
//   //     print("Exception: $e");
//   //   } finally {
//   //     isLoading.value = false;
//   //   }
//   // }

//   List<Item> get promoItems {
//     final items = <Item>[];

//     for (var type in categoryController.typecategories) {
//       for (var store in type.stores) {
//         for (var item in store.items) {
//           if (item.percentage_discount != 0) {
//             if (freeDeliveryOnly.value && !store.free_delivery) {
//               continue;
//             }
//             items.add(item);
//           }
//         }
//       }
//     }

//     // Sort by highest percentage_discount first
//     items
//         .sort((a, b) => b.percentage_discount.compareTo(a.percentage_discount));

//     return items;
//   }

//   List<Item> get filteredItems {
//     final items = <Item>[];

//     for (var type in categoryController.typecategories) {
//       for (var store in type.stores) {
//         for (var item in store.items) {
//           if (item.sub_category_name ==
//               categoryController.selectedSubCategory.value) {
//             if (freeDeliveryOnly.value && !store.free_delivery) {
//               continue;
//             }
//             items.add(item);
//           }
//         }
//       }
//     }

//     if (selectedSort.value == 'asc') {
//       items.sort((a, b) => a.price.compareTo(b.price));
//     } else {
//       items.sort((a, b) => b.price.compareTo(a.price));
//     }

//     return items;
//   }

//   void applyFilters() {
//     update();
//   }

//   String getStoreNameById(int storeId, List<Store> stores) {
//     final store = stores.firstWhere(
//       (store) => store.id == storeId,
//       orElse: () => Store(
//         id: 0,
//         name: 'Store inconnu',
//         image: '',
//         category: 0,
//         phoneNumber: '',
//         country: '',
//         governorate: '',
//         available: true,
//         items: [],
//         latitude: 0,
//         longitude: 0,
//         ratings: [],
//         average_rating: 0,
//         favorited_by: [],
//         free_delivery: true,
//       ),
//     );
//     return store.name;
//   }

//   // void showItemDetail(BuildContext context, Item item) {
//   //   Get.dialog(
//   //     AlertDialog(
//   //       title: Text(item.name),
//   //       content: Column(
//   //         mainAxisSize: MainAxisSize.min,
//   //         children: [
//   //           CachedNetworkImage(item.image),
//   //           const SizedBox(height: 10),
//   //           Text(item.description),
//   //           const SizedBox(height: 10),
//   //           Text('Prix: \$${item.price.toStringAsFixed(2)}'),
//   //         ],
//   //       ),
//   //       actions: [
//   //         TextButton(onPressed: () => Get.back(), child: const Text('Fermer')),
//   //       ],
//   //     ),
//   //   );
//   // }

//   var searchText = ''.obs;
//   var filteredSearchItems = <Item>[].obs;
//   var filteredSearchStores = <Store>[].obs;

//   void search(String query) {
//     searchText.value = query;

//     if (query.length < 3) {
//       filteredSearchItems.value = [];
//       filteredSearchStores.value = [];
//       return;
//     }

//     final items = <Item>[];
//     final stores = <Store>[];

//     for (var type in categoryController.typecategories) {
//       for (var store in type.stores) {
//         // 🔍 Recherche sur nom du store
//         if (store.name.toLowerCase().contains(query.toLowerCase())) {
//           stores.add(store);
//         }

//         for (var item in store.items) {
//           if (item.name.toLowerCase().contains(query.toLowerCase()) ||
//               item.description.toLowerCase().contains(query.toLowerCase())) {
//             items.add(item);
//           }
//         }
//       }
//     }

//     filteredSearchItems.value = items;
//     filteredSearchStores.value = stores;
//   }

//   // var publicities = <Publicity>[].obs;
//   // var isLoadingPublicities = false.obs;

//   // Future<void> fetchPublicities() async {
//   //   try {
//   //     isLoadingPublicities.value = true;
//   //     final url = Uri.parse('https://sdingserver.xyz/delivery/publicities/');
//   //     final response = await http.get(url, headers: {'X-Mobile-App': 'true'});
//   //     if (response.statusCode == 200) {
//   //       final List<dynamic> data = jsonDecode(response.body);
//   //       publicities.value =
//   //           data.map((json) => Publicity.fromJson(json)).toList();
//   //     } else {
//   //       print('Failed to load publicities, status: ${response.statusCode}');
//   //     }
//   //   } catch (e) {
//   //     print('Failed to fetch publicities: $e');
//   //   } finally {
//   //     isLoadingPublicities.value = false;
//   //   }
//   // }
// }

// ============================ VIEW ============================

class MenuScreen extends StatelessWidget {
  final controller = Get.put(ToutController());
  final CategoryController categoryController = Get.put(CategoryController());
  final CartController cartController = Get.put(CartController());
  final LocationController homeController = Get.put(LocationController());
  final LoginController loginController = Get.put(LoginController());
  final ToutController toutController = Get.put(ToutController());

  @override
  Widget build(BuildContext context) {
    TextEditingController searchController = TextEditingController();

    return Scaffold(
      // backgroundColor: const Color(0xFFFFF8E1),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: cartController.cart.isNotEmpty
          ? SizedBox(
              width: MediaQuery.of(context).size.width, // 95% largeur
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.orange.shade700,
                      Colors.orange.shade400,
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  // borderRadius: BorderRadius.circular(50),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0, 4),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: FloatingActionButton.extended(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddCartScreen(),
                      ),
                    );
                  },
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  icon: const Icon(
                    Icons.shopping_basket_outlined,
                    color: Colors.white,
                    size: 28,
                  ),
                  label: Row(
                    children: [
                      Text(
                        "Mon Panier - ${cartController.cart.length} articles ",
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          : null,

      body: SafeArea(
        child: Obx(() {
          if (categoryController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                pinned: true,
                floating: true,
                snap: false,
                backgroundColor: Colors.white,
                elevation: 1,
                title: GestureDetector(
                  onTap: () async {
                    await Future.wait([
                      categoryController.fetchStoresBasic(),
                      categoryController.fetchPublicities(),
                      toutController.fetchDiscountItems(),
                      toutController.fetchRecommendedItems()
                    ]);
                  },
                  child: Image.asset(
                    'images/logo2.png',
                    height: 125,
                    width: 125,
                  ),
                ),
                actions: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddCartScreen()),
                      );
                    },
                    child: Row(
                      children: [
                        cartController.cart.isNotEmpty
                            ? CircleAvatar(
                                backgroundColor: Colors.red,
                                radius: 8,
                                child: Text(
                                  '${cartController.cart.length}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              )
                            : Container(),
                        Icon(
                          Icons.shopping_basket_outlined,
                          color: Colors.orange.shade400,
                        ),
                      ],
                    ),
                  ),
                  PopupMenuButton<String>(
                    icon: Icon(
                      Icons.menu,
                      color: Colors.orange.shade400,
                    ),
                    onSelected: (value) async {
                      final prefs = await SharedPreferences.getInstance();
                      final token = prefs.getString('token');
                      switch (value) {
                        case 'track':
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => OrderTabScreen()),
                          );

                          break;
                        case 'wallet':
                          if (token == null) {
                            Get.snackbar(
                              "Authentication Required",
                              "You need to log in to access your wallet.",
                              snackPosition: SnackPosition.TOP,
                              backgroundColor:
                                  Colors.redAccent.withOpacity(0.8),
                              colorText: Colors.white,
                              icon: Icon(Icons.lock, color: Colors.white),
                            );
                            return; // نوقف الكود هنا
                          }
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => WalletLauncher()),
                          );

                          break;

                        case 'carnet':
                          if (token == null) {
                            Get.snackbar(
                              "Authentication Required",
                              "You need to log in to access your carnet.",
                              snackPosition: SnackPosition.TOP,
                              backgroundColor:
                                  Colors.redAccent.withOpacity(0.8),
                              colorText: Colors.white,
                              icon: Icon(Icons.lock, color: Colors.white),
                            );
                            return; // نوقف الكود هنا
                          }

                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  CarnetScreen(userToken: token),
                            ),
                          );
                          break;

                        case 'profile':
                          if (loginController.isAuthenticated.value) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AboutScreen()),
                            );
                          } else {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text("Authentication Required"),
                                content: Text(
                                    "You need to log in or sign up to access your profile."),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                LoginScreen()),
                                      );
                                    },
                                    child: Text("Login"),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => SignUp()),
                                      );
                                    },
                                    child: Text("Sign Up"),
                                  ),
                                ],
                              ),
                            );
                          }
                          break;
                        case 'language':
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return LanguageSelectionDialog();
                            },
                          );
                          break;

                        case 'logout':
                          loginController.logout();

                          Get.snackbar(
                            "Logout", // العنوان
                            "You have been logged out successfully!", // المحتوى
                            snackPosition: SnackPosition.TOP, // يظهر فوق
                            backgroundColor: Colors.redAccent.withOpacity(0.8),
                            colorText: Colors.white,
                            margin: const EdgeInsets.all(10),
                            borderRadius: 12,
                            icon: const Icon(Icons.logout, color: Colors.white),
                            duration: const Duration(seconds: 2),
                          );

                          break;

                        case 'about':
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    AboutSpoodingExpressScreen()),
                          );
                          break;
                      }
                    },
                    itemBuilder: (BuildContext context) {
                      return [
                        const PopupMenuItem<String>(
                          value: 'track',
                          child: Row(
                            children: [
                              Icon(Icons.delivery_dining),
                              SizedBox(
                                width: 10,
                              ),
                              Text('Order Tracking'),
                            ],
                          ),
                        ),
                        const PopupMenuItem<String>(
                          value: 'wallet',
                          child: Row(
                            children: [
                              Icon(Icons.wallet),
                              SizedBox(
                                width: 10,
                              ),
                              Text('My Wallet'),
                            ],
                          ),
                        ),
                        const PopupMenuItem<String>(
                          value: 'carnet',
                          child: Row(
                            children: [
                              Icon(Icons.card_giftcard),
                              SizedBox(
                                width: 10,
                              ),
                              Text('Mes Carnet'),
                            ],
                          ),
                        ),
                        const PopupMenuItem<String>(
                          value: 'profile',
                          child: Row(
                            children: [
                              Icon(Icons.person),
                              SizedBox(
                                width: 10,
                              ),
                              Text('Profile'),
                            ],
                          ),
                        ),
                        const PopupMenuItem<String>(
                          value: 'language',
                          child: Row(
                            children: [
                              Icon(Icons.language),
                              SizedBox(
                                width: 10,
                              ),
                              Text('Language'),
                            ],
                          ),
                        ),
                        if (loginController.isAuthenticated.value)
                          const PopupMenuItem<String>(
                            value: 'logout',
                            child: Row(
                              children: [
                                Icon(Icons.logout),
                                SizedBox(width: 10),
                                Text('Logout'),
                              ],
                            ),
                          ),
                        const PopupMenuItem<String>(
                          value: 'about',
                          child: Row(
                            children: [
                              Icon(Icons.mobile_friendly),
                              SizedBox(
                                width: 10,
                              ),
                              Text('About'),
                            ],
                          ),
                        ),
                      ];
                    },
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                ],
                bottom: AppBar(
                  automaticallyImplyLeading: false,
                  toolbarHeight: 60, // adjust height as needed
                  backgroundColor: Colors.white,
                  title: TextField(
                    controller: searchController,
                    onChanged: controller.search,
                    decoration: InputDecoration(
                      hintText: 'Rechercher un resto...',
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Colors.deepOrange,
                      ),
                      suffixIcon: searchController.text.isNotEmpty
                          ? IconButton(
                              icon: Icon(Icons.clear, color: Colors.deepOrange),
                              onPressed: () {
                                searchController.clear();
                                controller.search('');
                              },
                            )
                          : null,
                      filled: true,
                      fillColor: Colors.grey[200],
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 0,
                        horizontal: 20,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Obx(() {
                    final nearbyStores = controller.filteredSearchStores
                        .where(
                          (store) =>
                              homeController.currentPosition.value != null &&
                              homeController.calculateDistance(
                                    homeController
                                        .currentPosition.value!.latitude,
                                    homeController
                                        .currentPosition.value!.longitude,
                                    store.latitude,
                                    store.longitude,
                                  ) <=
                                  homeController.maxDistance,
                        )
                        .toList();

                    final nearbyItems = controller.filteredSearchItems.where((
                      item,
                    ) {
                      final foundStore = homeController.findStoreByItemId(
                        item.id,
                        categoryController,
                      );
                      return homeController.currentPosition.value != null &&
                          homeController.calculateDistance(
                                homeController.currentPosition.value!.latitude,
                                homeController.currentPosition.value!.longitude,
                                foundStore.latitude,
                                foundStore.longitude,
                              ) <=
                              homeController.maxDistance;
                    }).toList();

                    if (controller.searchText.isEmpty ||
                        (nearbyItems.isEmpty && nearbyStores.isEmpty)) {
                      return const SizedBox.shrink();
                    }

                    return Container(
                      key: ValueKey(controller.searchText),
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 6,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '🔍 Résultats de recherche',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepOrange.shade700,
                            ),
                          ),
                          const SizedBox(height: 10),

                          /// Stores
                          AnimatedSize(
                            duration: const Duration(milliseconds: 300),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: nearbyStores.map((store) {
                                return GestureDetector(
                                  onTap: () {
                                    Get.to(
                                      () =>
                                          StoreDetailScreen(storeId: store.id),
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.orange.shade50,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color: Colors.orange.shade200,
                                        ),
                                      ),
                                      child: ListTile(
                                        leading: const Icon(
                                          Icons.storefront_rounded,
                                          color: Colors.deepOrange,
                                        ),
                                        title: Text(
                                          store.name,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        subtitle: Text(
                                          store.available ? 'ouvert' : 'fermer',
                                        ),
                                        trailing: const Icon(
                                          Icons.arrow_forward_ios,
                                          size: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                          const SizedBox(height: 10),

                          /// Items
                          AnimatedSize(
                            duration: const Duration(milliseconds: 300),
                            child: Column(
                              children: nearbyItems.map((item) {
                                final storeName = controller.getStoreNameById(
                                  item.store,
                                  categoryController.stores,
                                );
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            FoodDetailPage(item: item),
                                      ),
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey[100],
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color: Colors.deepOrange.shade100,
                                        ),
                                      ),
                                      child: ListTile(
                                        leading: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: CachedNetworkImage(
                                            imageUrl: item.image,
                                            width: 50,
                                            height: 50,
                                            fit: BoxFit.cover,
                                            placeholder: (context, url) =>
                                                Shimmer.fromColors(
                                              baseColor: Colors.grey[300]!,
                                              highlightColor: Colors.grey[100]!,
                                              child: Container(
                                                height: 130,
                                                width: double.infinity,
                                                color: Colors.grey[300],
                                              ),
                                            ),
                                          ),
                                        ),
                                        title: Text(
                                          item.name,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        subtitle: Text(storeName),
                                        trailing: Text(
                                          '${item.price.toStringAsFixed(2)} DT',
                                          style: const TextStyle(
                                            color: Colors.deepOrange,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
              SliverToBoxAdapter(
                child: Obx(() {
                  if (categoryController.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (categoryController.publicities.isEmpty) {
                    return const SizedBox();
                  }

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: CarouselSlider(
                      options: CarouselOptions(
                        height: 180,
                        enlargeCenterPage: true,
                        viewportFraction: 0.9,
                        aspectRatio: 16 / 9,
                        autoPlay: true,
                        autoPlayInterval: Duration(seconds: 2),
                        // enlargeStrategy: CenterPageEnlargeStrategy.height,
                      ),
                      items: categoryController.publicities.map((pub) {
                        return Builder(
                          builder: (BuildContext context) {
                            return GestureDetector(
                              // onTap: () {
                              //   final matchedStore =
                              //       categoryController.stores.firstWhere(
                              //     (store) =>
                              //         store.latitude.toStringAsFixed(5) ==
                              //             pub.latitude.toStringAsFixed(5) &&
                              //         store.longitude.toStringAsFixed(5) ==
                              //             pub.longitude.toStringAsFixed(5),
                              //     orElse: () => Store(
                              //       id: 0,
                              //       name: 'Inconnu',
                              //       image: '',
                              //       category: 0,
                              //       phoneNumber: '',
                              //       country: '',
                              //       governorate: '',
                              //       available: false,
                              //       items: [],
                              //       latitude: 0.0,
                              //       longitude: 0.0,
                              //       ratings: [],
                              //       average_rating: 0.0,
                              //       favorited_by: [],
                              //       free_delivery: false,
                              //       firstItemImage: '',
                              //     ),
                              //   );

                              //   if (matchedStore.id != 0) {
                              //     Get.to(
                              //       () => StoreDetailScreen(
                              //         storeId: matchedStore.id,
                              //       ),
                              //     );
                              //   } else {
                              //     Get.to(
                              //       () => FullScreenImageScreen(
                              //         imageUrl: pub.image,
                              //       ),
                              //     );
                              //   }
                              // },
                              onTap: () {
                                final matchedStore =
                                    categoryController.stores.firstWhere(
                                  (store) =>
                                      store.latitude.toStringAsFixed(5) ==
                                          pub.latitude.toStringAsFixed(5) &&
                                      store.longitude.toStringAsFixed(5) ==
                                          pub.longitude.toStringAsFixed(5),
                                  orElse: () => Store(
                                    id: 0,
                                    name: '',
                                    image: '',
                                    category: 0,
                                    phoneNumber: '',
                                    country: '',
                                    governorate: '',
                                    available: true,
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

                                final store =
                                    matchedStore.id != 0 ? matchedStore : null;

                                Get.to(
                                  () => PublicityPreviewScreen(
                                    pub: pub,
                                    matchedStore: store,
                                  ),
                                );
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: CachedNetworkImage(
                                  imageUrl: pub.image,
                                  fit: BoxFit.cover,
                                  width: MediaQuery.of(context).size.width,
                                  placeholder: (context, url) =>
                                      Shimmer.fromColors(
                                    baseColor: Colors.grey[300]!,
                                    highlightColor: Colors.grey[100]!,
                                    child: Container(
                                      height: 130,
                                      width: double.infinity,
                                      color: Colors.grey[300],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      }).toList(),
                    ),
                  );
                }),
              ),
              SliverToBoxAdapter(
                child: Obx(() {
                  final subCategories = categoryController.subCategories;
                  if (subCategories.isEmpty) {
                    return const SizedBox.shrink();
                  }

                  final displayList = [
                    SubCategory(id: -1, name: "View All"),
                    ...subCategories,
                  ];

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
                    child: SizedBox(
                      height: 40,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: displayList.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 5),
                        itemBuilder: (context, index) {
                          final sub = displayList[index];

                          if (sub.id == -1) {
                            // زر View All بتصميم مميز
                            return InkWell(
                              borderRadius: BorderRadius.circular(20),
                              onTap: () {
                                Get.bottomSheet(
                                  Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.6,
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(24),
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.symmetric(
                                            vertical: 12,
                                          ),
                                          width: 60,
                                          height: 6,
                                          decoration: BoxDecoration(
                                            color: Colors.grey[300],
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: ListView.separated(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 16,
                                            ),
                                            itemCount: subCategories.length,
                                            separatorBuilder: (_, __) =>
                                                Divider(
                                                    color: Colors.grey[300]),
                                            itemBuilder: (context, idx) {
                                              final subCategory =
                                                  subCategories[idx];
                                              return ListTile(
                                                contentPadding: EdgeInsets.zero,
                                                title: Text(
                                                  subCategory.name,
                                                  style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                trailing: const Icon(
                                                  Icons.arrow_forward_ios,
                                                  size: 18,
                                                  color: Colors.orange,
                                                ),
                                                onTap: () {
                                                  Get.back();
                                                  Get.to(
                                                    () =>
                                                        SubCategoryDetailScreen(
                                                      subCategoryId:
                                                          subCategory.id,
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  isScrollControlled: true,
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.orange.shade700,
                                      Colors.orange.shade400,
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(35),
                                ),
                                child: const Center(
                                  child: Text(
                                    "View All",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }

                          // باقي الفئات الفرعية - تصميم عصري مع تدرج ونظافة
                          return InkWell(
                            borderRadius: BorderRadius.circular(30),
                            onTap: () {
                              Get.to(
                                () => SubCategoryDetailScreen(
                                  subCategoryId: sub.id,
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.orange.shade100,
                                    Colors.orange.shade50,
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                  color: Colors.orange.shade300,
                                  width: 1.5,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  sub.name,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                }),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 12)),
              if (controller.recommendedItems.isNotEmpty)
                SliverToBoxAdapter(
                  child: Obx(() {
                    final nearbyRecommendedItems =
                        controller.recommendedItems.where((item) {
                      final store = categoryController.stores.firstWhere(
                        (s) => s.id == item.store,
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

                      if (homeController.currentPosition.value == null)
                        return false;

                      final distance = homeController.calculateDistance(
                        homeController.currentPosition.value!.latitude,
                        homeController.currentPosition.value!.longitude,
                        store.latitude,
                        store.longitude,
                      );

                      return distance <= homeController.maxDistance;
                    }).toList();

                    if (nearbyRecommendedItems.isEmpty)
                      return const SizedBox.shrink();

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            children: [
                              const Expanded(child: Divider(thickness: 1)),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),
                                child: Text(
                                  '🍽️ Populaires dans votre région',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                    color: Colors.orange.shade900,
                                  ),
                                ),
                              ),
                              const Expanded(child: Divider(thickness: 1)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 241,
                          child: ListView.separated(
                            padding: const EdgeInsets.only(left: 16),
                            scrollDirection: Axis.horizontal,
                            // Make a sorted copy of the list
                            itemCount: nearbyRecommendedItems.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(width: 12),
                            itemBuilder: (context, index) {
                              // Sort items so that stores that are available come first
                              final sortedItems = [...nearbyRecommendedItems]
                                ..sort((a, b) {
                                  final storeA =
                                      categoryController.stores.firstWhere(
                                    (s) => s.id == a.store,
                                    orElse: () => Store(
                                      id: 0,
                                      name: '',
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
                                  final storeB =
                                      categoryController.stores.firstWhere(
                                    (s) => s.id == b.store,
                                    orElse: () => Store(
                                      id: 0,
                                      name: '',
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

                                  // Convert bool to int for comparison: true=1, false=0
                                  return (storeB.available ? 1 : 0) -
                                      (storeA.available ? 1 : 0);
                                });

                              final item = sortedItems[index];
                              final foundstore =
                                  categoryController.stores.firstWhere(
                                (s) => s.id == item.store,
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

                              return SizedBox(
                                width: 180,
                                child: FoodCardRecom(
                                  name: item.name,
                                  description: item.description,
                                  price: item.price,
                                  rating: item.average_rating,
                                  storeName: foundstore.name,
                                  item: item,
                                  store: foundstore,
                                  displayMode: 1,
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 10),
                        const SimpleLivraisonBanner(),
                      ],
                    );
                  }),
                ),
              if (controller.discountedItems.isNotEmpty)
                SliverToBoxAdapter(
                  child: Obx(() {
                    final nearbyDiscountedItems =
                        controller.discountedItems.where((item) {
                      final store = categoryController.stores.firstWhere(
                        (s) => s.id == item.store,
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

                      if (homeController.currentPosition.value == null)
                        return false;

                      final distance = homeController.calculateDistance(
                        homeController.currentPosition.value!.latitude,
                        homeController.currentPosition.value!.longitude,
                        store.latitude,
                        store.longitude,
                      );

                      return distance <= homeController.maxDistance;
                    }).toList();
                    nearbyDiscountedItems.sort((a, b) {
                      final storeA = categoryController.stores
                          .firstWhere((s) => s.id == a.store);
                      final storeB = categoryController.stores
                          .firstWhere((s) => s.id == b.store);

                      // 1. Compare by availability (available first)
                      final availabilityComparison = (storeB.available ? 1 : 0)
                          .compareTo(storeA.available ? 1 : 0);

                      if (availabilityComparison != 0)
                        return availabilityComparison;

                      // 2. Compare by item discount (descending)
                      return (b.percentage_discount)
                          .compareTo(a.percentage_discount);
                    });

                    if (nearbyDiscountedItems.isEmpty)
                      return const SizedBox.shrink();

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            children: [
                              const Expanded(child: Divider(thickness: 1)),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),
                                child: Text(
                                  '🔥 Promotions',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                    color: Colors.orange.shade900,
                                  ),
                                ),
                              ),
                              const Expanded(child: Divider(thickness: 1)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 241,
                          child: ListView.separated(
                            padding: const EdgeInsets.only(left: 16),
                            scrollDirection: Axis.horizontal,
                            itemCount: nearbyDiscountedItems.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(width: 12),
                            itemBuilder: (context, index) {
                              final item = nearbyDiscountedItems[index];
                              final store =
                                  categoryController.stores.firstWhere(
                                (s) => s.id == item.store,
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
                              return SizedBox(
                                width: 180,
                                child: FoodCardRecom(
                                  name: item.name,
                                  description: item.description,
                                  price: item.price,
                                  rating: item.average_rating,
                                  storeName: store.name,
                                  item: item,
                                  store: store,
                                  displayMode: 3,
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.center,
                          child: TextButton(
                            onPressed: () {
                              Get.to(() => PromotionScreen());
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(right: 16),
                              child: Text(
                                "Voir tout",
                                style: TextStyle(
                                  color: Colors.orange.shade800,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    );
                  }),
                ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(child: Divider(thickness: 1)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          '🍽️ Restaurants proches',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                            color: Colors.orange.shade900,
                          ),
                        ),
                      ),
                      Expanded(child: Divider(thickness: 1)),
                    ],
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 10)),
              SliverToBoxAdapter(
                child: Obx(() {
                  if (categoryController.stores.isEmpty ||
                      homeController.currentPosition.value == null) {
                    return Center(
                      child: Text(
                        "يبدو أنك خارج منطقة التوصيل الحالية لدينا. نحن قادمون قريباً إلى موقعك. يرجى التحقق مرة أخرى لاحقاً لتقديم طلب",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 17,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    );
                  }

                  final filteredStores =
                      categoryController.stores.where((store) {
                    final distance = homeController.calculateDistance(
                      homeController.currentPosition.value!.latitude,
                      homeController.currentPosition.value!.longitude,
                      store.latitude,
                      store.longitude,
                    );
                    return distance < homeController.maxDistance;
                  }).toList();

                  filteredStores.sort((a, b) {
                    if (a.available != b.available) {
                      return a.available ? -1 : 1;
                    } else {
                      return b.average_rating.compareTo(a.average_rating);
                    }
                  });

                  if (filteredStores.isEmpty) {
                    return Center(
                      child: Text(
                        "Aucun restaurant disponible dans votre région.",
                      ),
                    );
                  }

                  return ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: filteredStores.length,
                    itemBuilder: (context, index) {
                      final store = filteredStores[index];
                      double distance = homeController.calculateDistance(
                        homeController.currentPosition.value!.latitude,
                        homeController.currentPosition.value!.longitude,
                        store.latitude,
                        store.longitude,
                      );

                      return Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    blurRadius: 10,
                                    spreadRadius: 2,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  Get.to(
                                    () => StoreDetailScreen(storeId: store.id),
                                  );
                                },
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: CachedNetworkImage(
                                        imageUrl: store.firstItemImage,
                                        placeholder: (context, url) => Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            ColorFiltered(
                                          colorFilter: const ColorFilter.mode(
                                            Colors.grey,
                                            BlendMode.saturation,
                                          ),
                                          child: Image.asset(
                                            'images/logo2.png',
                                            fit: BoxFit.contain,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.9,
                                            height: 150,
                                          ),
                                        ),
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.9,
                                        height: 150,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    // if (store.free_delivery == true)
                                    //   Positioned(
                                    //     top: 20,
                                    //     right: 0,
                                    //     child: Container(
                                    //       padding: const EdgeInsets.symmetric(
                                    //           horizontal: 15, vertical: 10),
                                    //       decoration: BoxDecoration(
                                    //         color: Colors.green.shade600,
                                    //         borderRadius:
                                    //             const BorderRadius.only(
                                    //           topLeft: Radius.circular(12),
                                    //           bottomLeft: Radius.circular(12),
                                    //         ),
                                    //       ),
                                    //       child: const Row(
                                    //         children: [
                                    //           Text(
                                    //             "Livraison Gratuite",
                                    //             style: TextStyle(
                                    //               color: Colors.white,
                                    //               fontWeight: FontWeight.bold,
                                    //               fontSize: 14,
                                    //             ),
                                    //           ),
                                    //           SizedBox(width: 5),
                                    //           Icon(
                                    //             Icons.delivery_dining,
                                    //             size: 22,
                                    //             color: Colors.white,
                                    //           ),
                                    //         ],
                                    //       ),
                                    //     ),
                                    //   ),
                                    Positioned(
                                      bottom: 0,
                                      right: 0,
                                      left: 0,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 15,
                                          vertical: 8,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.6),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                CircleAvatar(
                                                  backgroundImage:
                                                      CachedNetworkImageProvider(
                                                    store.image,
                                                  ),
                                                ),
                                                SizedBox(width: 10),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      store.name,
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    store.available
                                                        ? (store.free_delivery ==
                                                                false
                                                            ? Row(
                                                                children: [
                                                                  Icon(
                                                                    Icons
                                                                        .directions_bike,
                                                                    color: Colors
                                                                        .grey
                                                                        .shade300,
                                                                    size: 18,
                                                                  ),
                                                                  SizedBox(
                                                                    width: 5,
                                                                  ),
                                                                  Text(
                                                                    '${distance.toStringAsFixed(2)} Km',
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .white70,
                                                                    ),
                                                                  ),
                                                                ],
                                                              )
                                                            : GlowingFreeDelivery())
                                                        : const Text(
                                                            'Closed Now',
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                              color: Colors
                                                                  .redAccent,
                                                            ),
                                                            maxLines: 2,
                                                          ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            if (store.free_delivery == true)
                                              Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      ShaderMask(
                                                        shaderCallback:
                                                            (bounds) =>
                                                                LinearGradient(
                                                          colors: [
                                                            Colors.greenAccent,
                                                            Colors.green
                                                          ],
                                                          begin:
                                                              Alignment.topLeft,
                                                          end: Alignment
                                                              .bottomRight,
                                                        ).createShader(bounds),
                                                        child: Text(
                                                          "Livraison",
                                                          style: TextStyle(
                                                            color: Colors
                                                                .white, // couleur de base, remplacée par le shader
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 16,
                                                            shadows: [
                                                              Shadow(
                                                                color: Colors
                                                                    .greenAccent
                                                                    .withOpacity(
                                                                        0.7),
                                                                blurRadius: 6,
                                                                offset: Offset(
                                                                    0, 0),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(width: 5),
                                                      Icon(
                                                        Icons.delivery_dining,
                                                        size: 22,
                                                        color:
                                                            Colors.greenAccent,
                                                      ),
                                                    ],
                                                  ),
                                                  ShaderMask(
                                                    shaderCallback: (bounds) =>
                                                        LinearGradient(
                                                      colors: [
                                                        Colors.greenAccent,
                                                        Colors.green
                                                      ],
                                                      begin: Alignment.topLeft,
                                                      end:
                                                          Alignment.bottomRight,
                                                    ).createShader(bounds),
                                                    child: Text(
                                                      "Gratuite",
                                                      style: TextStyle(
                                                        color: Colors
                                                            .white, // remplacé par le shader
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16,
                                                        shadows: [
                                                          Shadow(
                                                            color: Colors
                                                                .greenAccent
                                                                .withOpacity(
                                                                    0.7),
                                                            blurRadius: 6,
                                                            offset:
                                                                Offset(0, 0),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    if (store.has_discounted_item)
                                      if (store.has_discounted_item)
                                        Positioned(
                                          top: 12,
                                          right: -20,
                                          child: Transform.rotate(
                                            angle: 0.6, // slanted ribbon
                                            child: Container(
                                              width: 140,
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 6),
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  colors: [
                                                    Colors.red,
                                                    Colors.red
                                                  ],
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomRight,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black26,
                                                    blurRadius: 4,
                                                    offset: Offset(2, 2),
                                                  ),
                                                ],
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.local_offer,
                                                    color: Colors.yellowAccent,
                                                    size: 18,
                                                  ),
                                                  SizedBox(width: 6),
                                                  Text(
                                                    "PROMO  ",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16,
                                                      letterSpacing: 1,
                                                      shadows: [
                                                        Shadow(
                                                          blurRadius: 2,
                                                          color: Colors.black45,
                                                          offset: Offset(1, 1),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
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
                    },
                  );
                }),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 20)),
            ],
          );
        }),
      ),
    );
  }
}

// class _CategoryHeaderDelegate extends SliverPersistentHeaderDelegate {
//   final Widget child;

//   _CategoryHeaderDelegate({required this.child});

//   @override
//   double get minExtent => 100;
//   @override
//   double get maxExtent => 100;

//   @override
//   Widget build(
//     BuildContext context,
//     double shrinkOffset,
//     bool overlapsContent,
//   ) {
//     return child;
//   }

//   @override
//   bool shouldRebuild(covariant _CategoryHeaderDelegate oldDelegate) {
//     return true;
//   }
// }

// class _CategoryChip extends StatelessWidget {
//   final String label;
//   final IconData icon;
//   final bool selected;
//   final VoidCallback onTap;

//   const _CategoryChip({
//     required this.label,
//     required this.icon,
//     required this.selected,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(right: 12), // مساحة خارجية بين الشرائح
//       child: Material(
//         color: selected ? Colors.white : null,
//         borderRadius: BorderRadius.circular(16),
//         child: InkWell(
//           borderRadius: BorderRadius.circular(16),
//           onTap: onTap,
//           child: AnimatedContainer(
//             duration: const Duration(milliseconds: 250),
//             width: 75,
//             padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
//             decoration: BoxDecoration(
//               gradient: selected
//                   ? null
//                   : const LinearGradient(
//                       colors: [Color(0xFFFFA726), Color(0xFFFF7043)],
//                       begin: Alignment.topLeft,
//                       end: Alignment.bottomRight,
//                     ),
//               color: selected ? Colors.white : null,
//               borderRadius: BorderRadius.circular(16),
//               border: Border.all(color: Colors.deepOrangeAccent),
//               boxShadow: selected
//                   ? [
//                       BoxShadow(
//                         color: Colors.orange.withOpacity(0.25),
//                         blurRadius: 8,
//                         offset: const Offset(0, 3),
//                       )
//                     ]
//                   : [],
//             ),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Icon(
//                   icon,
//                   size: 24,
//                   color: selected ? Colors.deepOrange : Colors.white,
//                 ),
//                 const SizedBox(height: 6),
//                 Text(
//                   label,
//                   textAlign: TextAlign.center,
//                   maxLines: 1,
//                   style: TextStyle(
//                     fontSize: 12,
//                     fontWeight: FontWeight.w600,
//                     color: selected ? Colors.deepOrange : Colors.white,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

class FoodCardRecom extends StatelessWidget {
  final String name;
  final String description;
  final double price;
  final double rating;
  final String storeName;
  final Item item;
  final Store store;
  final int displayMode;

  const FoodCardRecom({
    required this.name,
    required this.description,
    required this.price,
    required this.rating,
    required this.storeName,
    required this.item,
    required this.store,
    required this.displayMode,
  });

  @override
  Widget build(BuildContext context) {
    final CartController cartController = Get.put(CartController());

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => FoodDetailPage(item: item)),
        );
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(16)),
                  child: CachedNetworkImage(
                    imageUrl: item.fullImageUrl,
                    height: 130,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        height: 130,
                        width: double.infinity,
                        color: Colors.grey[300],
                      ),
                    ),
                  ),
                ),
                if (displayMode == 3)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '-${item.percentage_discount.round()}%',
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                if (displayMode != 2)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: CircleAvatar(
                      backgroundColor: store.available
                          ? Colors.orange.shade600
                          : Colors.grey,
                      child: IconButton(
                        icon: const Icon(Icons.add,
                            color: Colors.white, size: 20),
                        onPressed: store.available
                            ? () => _handleCartAction(context, cartController)
                            : null,
                      ),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.storefront,
                          color: Colors.grey.shade600, size: 16),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          storeName,
                          style: TextStyle(
                              color: Colors.grey.shade600, fontSize: 13),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                          const SizedBox(width: 4),
                          Text(rating.toStringAsFixed(1),
                              style:
                                  const TextStyle(fontWeight: FontWeight.w500)),
                        ],
                      ),
                      Text(
                        '${price.toStringAsFixed(2)} DT',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ],
                  ),
                  if (displayMode == 2)
                    const SizedBox(
                      height: 10,
                    ),
                  if (displayMode == 2)
                    GestureDetector(
                      onTap: store.available
                          ? () => _handleCartAction(context, cartController)
                          : null,
                      child: Container(
                        height: 40,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: store.available
                              ? Colors.orange.shade600
                              : Colors.grey,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          "Ajouter au panier",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
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

  void _handleCartAction(BuildContext context, CartController cartController) {
    if (!store.available || !item.available) {
      _showOutOfStockDialog(context);
      return;
    }

    bool isDifferentStore = cartController.cart.isNotEmpty &&
        cartController.cart.first['item'].store != store.id;

    if (isDifferentStore) {
      _showStoreChangeDialog(context, store);
    } else {
      _handleAddToCart(context, cartController, store);
    }
  }

  void _showOutOfStockDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Stock en rupture"),
          content: Text("Cet article est en rupture de stock."),
          actions: <Widget>[
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showStoreChangeDialog(BuildContext context, Store store) {
    final CartController cartController = Get.put(CartController());
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Supprimer l\'ancienne sélection'),
          content: Text(
              'Vous avez des articles d\'un autre magasin dans votre panier. Voulez-vous les supprimer et ajouter les articles de ce magasin ?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Non'),
            ),
            TextButton(
              onPressed: () {
                cartController.clearCart();
                Navigator.pop(context);
                _handleAddToCart(context, cartController, store);
              },
              child: Text('Oui'),
            ),
          ],
        );
      },
    );
  }

  // void _handleAddToCart(
  //   BuildContext context,
  //   Store store,
  // ) {
  //   final CartController cartController = Get.put(CartController());

  //   if (item.personalized) {
  //     showModalBottomSheet(
  //       isScrollControlled: true,
  //       backgroundColor: Colors.white,
  //       context: context,
  //       builder: (context) {
  //         List<Suppliment> selectedSupplements = [];
  //         var supplementsByCategory = <String, List<Suppliment>>{};

  //         for (var supplement in item.suppliments) {
  //           if (!supplementsByCategory.containsKey(supplement.category)) {
  //             supplementsByCategory[supplement.category] = [];
  //           }
  //           supplementsByCategory[supplement.category]!.add(supplement);
  //         }

  //         double totalPrice = item.price;

  //         return StatefulBuilder(
  //           builder: (BuildContext context, StateSetter setState) {
  //             return Container(
  //               height: MediaQuery.of(context).size.height * 0.6,
  //               child: Column(
  //                 children: [
  //                   Padding(
  //                     padding: const EdgeInsets.all(8.0),
  //                     child: Stack(
  //                       children: [
  //                         Row(
  //                           children: [
  //                             CircleAvatar(
  //                               radius: 65,
  //                               backgroundColor: Colors.white,
  //                               child: CircleAvatar(
  //                                 radius: 60,
  //                                 backgroundImage: CachedNetworkImageProvider(
  //                                   item.fullImageUrl,
  //                                 ),
  //                               ),
  //                             ),
  //                             Padding(
  //                               padding: const EdgeInsets.all(8.0),
  //                               child: Column(
  //                                 crossAxisAlignment: CrossAxisAlignment.start,
  //                                 children: [
  //                                   Text(
  //                                     item.name,
  //                                     style: TextStyle(
  //                                       fontWeight: FontWeight.bold,
  //                                       fontSize: 20,
  //                                     ),
  //                                   ),
  //                                   Text(store.name),
  //                                   SizedBox(height: 5),
  //                                   RatingBar.builder(
  //                                     initialRating: item.average_rating,
  //                                     minRating: 1,
  //                                     direction: Axis.horizontal,
  //                                     allowHalfRating: false,
  //                                     itemCount: 5,
  //                                     itemSize: 20,
  //                                     itemPadding:
  //                                         EdgeInsets.symmetric(horizontal: 1.0),
  //                                     itemBuilder: (context, _) => Icon(
  //                                       Icons.star,
  //                                       color: Colors.amber,
  //                                     ),
  //                                     onRatingUpdate: (newRating) {
  //                                       cartController.sendFeedbackRating(
  //                                           item.id, newRating);
  //                                       Get.forceAppUpdate();
  //                                     },
  //                                   ),
  //                                 ],
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                         Positioned(
  //                           right: 0,
  //                           child: CircleAvatar(
  //                             backgroundColor: Colors.orange.shade400,
  //                             radius: 40,
  //                             child: Text(
  //                               '${item.price} dt',
  //                               style: TextStyle(
  //                                 color: Colors.white,
  //                                 fontWeight: FontWeight.bold,
  //                               ),
  //                             ),
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                   Expanded(
  //                     child: ListView(
  //                       children: supplementsByCategory.entries.expand((entry) {
  //                         var category = entry.key;
  //                         var supplements = entry.value;
  //                         var selectedCategorySupplement = selectedSupplements
  //                             .firstWhereOrNull((supplement) =>
  //                                 supplement.category == category);

  //                         return [
  //                           Padding(
  //                             padding: const EdgeInsets.symmetric(
  //                                 vertical: 8.0, horizontal: 8.0),
  //                             child: Text(
  //                               category,
  //                               style: TextStyle(
  //                                 fontSize: 16,
  //                                 fontWeight: FontWeight.bold,
  //                               ),
  //                             ),
  //                           ),
  //                           ...supplements.map((supplement) {
  //                             return store.category == 1
  //                                 ? CheckboxListTile(
  //                                     title: Text(supplement.title),
  //                                     subtitle: Text('${supplement.price} dt'),
  //                                     value: selectedSupplements
  //                                         .contains(supplement),
  //                                     onChanged: (bool? value) {
  //                                       setState(() {
  //                                         if (value == true) {
  //                                           selectedSupplements.add(supplement);
  //                                           totalPrice += supplement.price;
  //                                         } else {
  //                                           selectedSupplements
  //                                               .remove(supplement);
  //                                           totalPrice -= supplement.price;
  //                                         }
  //                                       });
  //                                     },
  //                                   )
  //                                 : RadioListTile(
  //                                     title: Text(supplement.title),
  //                                     groupValue: selectedCategorySupplement,
  //                                     value: supplement,
  //                                     onChanged: (selectedSupplement) {
  //                                       setState(() {
  //                                         selectedSupplements.removeWhere(
  //                                             (sup) =>
  //                                                 sup.category == category);
  //                                         selectedSupplements
  //                                             .add(selectedSupplement!);
  //                                         totalPrice = item.price +
  //                                             selectedSupplement.price;
  //                                       });
  //                                     },
  //                                   );
  //                           }).toList(),
  //                         ];
  //                       }).toList(),
  //                     ),
  //                   ),
  //                   Padding(
  //                     padding: const EdgeInsets.only(
  //                         bottom: 30, right: 50, left: 50),
  //                     child: GestureDetector(
  //                       onTap: () {
  //                         cartController.addToCart(item, 1,
  //                             selectedSuppliments: selectedSupplements);
  //                         Get.forceAppUpdate();
  //                         Navigator.pop(context);
  //                         // ScaffoldMessenger.of(context).showSnackBar(
  //                         //   SnackBar(
  //                         //     content: Text(
  //                         //         '${item.name} with supplements added to cart'),
  //                         //   ),
  //                         // );

  //                         Get.snackbar(
  //                           'Ajouté au panier',
  //                           '${item.name} a été ajouté avec succès !',
  //                           snackPosition: SnackPosition.TOP,
  //                           backgroundColor: Colors.green.shade100,
  //                           colorText: Colors.black,
  //                         );
  //                       },
  //                       child: Container(
  //                         padding: EdgeInsets.symmetric(
  //                             horizontal: 20, vertical: 10),
  //                         decoration: BoxDecoration(
  //                           gradient: LinearGradient(
  //                             colors: [
  //                               Colors.orange.shade400,
  //                               Colors.orange.shade400
  //                             ],
  //                             begin: Alignment.topLeft,
  //                             end: Alignment.bottomRight,
  //                           ),
  //                           borderRadius: BorderRadius.circular(10),
  //                         ),
  //                         child: Row(
  //                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                           children: [
  //                             Text(
  //                               ' Add To Cart',
  //                               style: TextStyle(
  //                                 color: Colors.white,
  //                                 fontSize: 16,
  //                               ),
  //                             ),
  //                             Text(
  //                               '${totalPrice.toStringAsFixed(2)} dt',
  //                               style: TextStyle(
  //                                 color: Colors.white,
  //                                 fontSize: 16,
  //                                 fontWeight: FontWeight.bold,
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             );
  //           },
  //         );
  //       },
  //     );
  //   } else {
  //     cartController.addToCart(item, 1);
  //     Get.snackbar(
  //       'Ajouté au panier',
  //       '${item.name} a été ajouté avec succès !',
  //       snackPosition: SnackPosition.TOP,
  //       backgroundColor: Colors.green.shade100,
  //       colorText: Colors.black,
  //     );
  //     Get.forceAppUpdate();
  //   }
  // }

  void _handleAddToCart(
    BuildContext context,
    CartController cartController,
    Store store,
  ) {
    int quantity = 1;

    if (item.personalized) {
      showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.white,
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        builder: (context) {
          List<Suppliment> selectedSupplements = [];
          var supplementsByCategory = <String, List<Suppliment>>{};

          for (var supplement in item.suppliments) {
            supplementsByCategory.putIfAbsent(supplement.category, () => []);
            supplementsByCategory[supplement.category]!.add(supplement);
          }

          double totalPrice = item.price;

          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                height: MediaQuery.of(context).size.height * 0.75,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 🔝 Barre de titre + prix
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Center(
                              child: Hero(
                                tag: 'item_${item.id}',
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: CachedNetworkImage(
                                    imageUrl: item.fullImageUrl,
                                    height: 80,
                                    width: 80,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 12),
                            Column(
                              children: [
                                Text(item.name,
                                    style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold)),
                                Row(
                                  children: [
                                    RatingBar.builder(
                                      initialRating: item.average_rating,
                                      minRating: 1,
                                      direction: Axis.horizontal,
                                      allowHalfRating: false,
                                      itemCount: 5,
                                      itemSize: 20,
                                      itemPadding:
                                          EdgeInsets.symmetric(horizontal: 2.0),
                                      itemBuilder: (context, _) =>
                                          Icon(Icons.star, color: Colors.amber),
                                      onRatingUpdate: (newRating) {
                                        cartController.sendFeedbackRating(
                                            item.id, newRating);
                                        Get.forceAppUpdate();
                                      },
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                        item.average_rating.toStringAsFixed(1)),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.orange.shade400,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${item.price.toStringAsFixed(2)} dt',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 12),

                    // 🔧 Suppléments (si item personnalisé)
                    if (item.suppliments.isNotEmpty)
                      Expanded(
                        child: ListView(
                          children:
                              supplementsByCategory.entries.expand((entry) {
                            var category = entry.key;
                            var supplements = entry.value;
                            var selectedCategorySupplement =
                                selectedSupplements.firstWhereOrNull(
                                    (s) => s.category == category);

                            return [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 6.0),
                                child: Text(
                                  category,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              ...supplements.map((supplement) {
                                return store.category == 1
                                    ? CheckboxListTile(
                                        title: Text(supplement.title),
                                        subtitle:
                                            Text('${supplement.price} dt'),
                                        value: selectedSupplements
                                            .contains(supplement),
                                        onChanged: (bool? value) {
                                          setState(() {
                                            if (value == true) {
                                              selectedSupplements
                                                  .add(supplement);
                                              totalPrice += supplement.price;
                                            } else {
                                              selectedSupplements
                                                  .remove(supplement);
                                              totalPrice -= supplement.price;
                                            }
                                          });
                                        },
                                      )
                                    : RadioListTile(
                                        title: Text(supplement.title),
                                        groupValue: selectedCategorySupplement,
                                        value: supplement,
                                        onChanged: (selectedSupplement) {
                                          setState(() {
                                            selectedSupplements.removeWhere(
                                                (s) => s.category == category);
                                            selectedSupplements
                                                .add(selectedSupplement!);
                                            totalPrice = item.price +
                                                selectedSupplement.price;
                                          });
                                        },
                                      );
                              }).toList(),
                            ];
                          }).toList(),
                        ),
                      ),

                    // 🔢 Compteur de quantité + Ajouter au panier
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.grey.shade200,
                          ),
                          child: Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  if (quantity > 1) setState(() => quantity--);
                                },
                                icon: Icon(Icons.remove),
                              ),
                              Text('$quantity',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                              IconButton(
                                onPressed: () {
                                  setState(() => quantity++);
                                },
                                icon: Icon(Icons.add),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              cartController.addToCart(
                                item,
                                quantity,
                                selectedSuppliments: selectedSupplements,
                              );
                              Get.forceAppUpdate();
                              Navigator.pop(context);
                              Get.snackbar(
                                'Ajouté au panier',
                                '${item.name} a été ajouté avec succès !',
                                snackPosition: SnackPosition.TOP,
                                backgroundColor: Colors.green.shade100,
                                colorText: Colors.black,
                              );
                            },
                            child: Container(
                              height: 50,
                              margin: EdgeInsets.only(left: 16),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.orange.shade400,
                                    Colors.deepOrange.shade400
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                '${(totalPrice * quantity).toStringAsFixed(2)} dt - Ajouter au panier',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                  ],
                ),
              );
            },
          );
        },
      );
    } else {
      // Items non personnalisés
      showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                height: 150,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    
                    // 🔢 Compteur
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(12)),
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              if (quantity > 1) setState(() => quantity--);
                            },
                            icon: Icon(Icons.remove),
                          ),
                          Text('$quantity',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          IconButton(
                            onPressed: () {
                              setState(() => quantity++);
                            },
                            icon: Icon(Icons.add),
                          ),
                        ],
                      ),
                    ),
                    // Bouton Ajouter au panier
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          cartController.addToCart(item, quantity);
                          Get.forceAppUpdate();
                          Navigator.pop(context);
                          Get.snackbar(
                            'Ajouté au panier',
                            '${item.name} a été ajouté avec succès !',
                            snackPosition: SnackPosition.TOP,
                            backgroundColor: Colors.green.shade100,
                            colorText: Colors.black,
                          );
                        },
                        child: Container(
                          height: 50,
                          margin: EdgeInsets.only(left: 16),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.orange.shade400,
                                Colors.deepOrange.shade400
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '${(item.price * quantity).toStringAsFixed(2)} dt - Ajouter au panier',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      );
    }
  }
}

class BannerClipper extends CustomClipper<ui.Path> {
  @override
  ui.Path getClip(Size size) {
    final path = ui.Path();
    path.moveTo(10, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(10, size.height);
    path.lineTo(0, size.height / 2);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<ui.Path> oldClipper) => false;
}

class GlowingFreeDelivery extends StatefulWidget {
  @override
  _GlowingFreeDeliveryState createState() => _GlowingFreeDeliveryState();
}

class _GlowingFreeDeliveryState extends State<GlowingFreeDelivery>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
      upperBound: 1.0,
    )..repeat(reverse: true);

    _glowAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _glowAnimation,
      builder: (context, child) {
        double glowValue = _glowAnimation.value * 10;
        return ShaderMask(
          shaderCallback: (bounds) {
            return RadialGradient(
              colors: [
                const Color.fromARGB(255, 6, 168, 11).withOpacity(0.5),
                const Color.fromARGB(255, 145, 220, 148).withOpacity(0)
              ],
              stops: [0.2, 1.0],
              radius: glowValue,
              center: Alignment.center,
            ).createShader(bounds);
          },
          child: const Text(
            'Livraison Gratuite',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        );
      },
    );
  }
}

class SimpleLivraisonBanner extends StatelessWidget {
  const SimpleLivraisonBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CoursierOrderScreen(),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const ui.Color.fromARGB(255, 4, 140, 148),
              const ui.Color.fromARGB(255, 4, 140, 148),
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color:
                  const ui.Color.fromARGB(255, 37, 150, 190).withOpacity(0.3),
              blurRadius: 6,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: const Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              radius: 24,
              child: Icon(
                Icons.delivery_dining_rounded,
                color: Colors.deepOrangeAccent,
                size: 28,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Livraison de Colis',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Envoie tes colis rapidement et en toute sécurité',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.white,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

class LanguageSelectionDialog extends StatefulWidget {
  @override
  _LanguageSelectionDialogState createState() =>
      _LanguageSelectionDialogState();
}

class _LanguageSelectionDialogState extends State<LanguageSelectionDialog> {
  // Get the localeController instance
  final LocaleController localeController = Get.find<LocaleController>();

  // Track the selected language locally within the dialog
  String? selectedLanguage;

  @override
  void initState() {
    super.initState();
    // Initialize selectedLanguage with the current language from the controller
    selectedLanguage = localeController.language?.languageCode ?? 'en';
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Select Language'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RadioListTile<String>(
            title: const Text('English'),
            value: 'en',
            groupValue: selectedLanguage,
            onChanged: (value) {
              setState(() {
                selectedLanguage = value;
              });
            },
          ),
          RadioListTile<String>(
            title: const Text('Français'),
            value: 'fr',
            groupValue: selectedLanguage,
            onChanged: (value) {
              setState(() {
                selectedLanguage = value;
              });
            },
          ),
          RadioListTile<String>(
            title: const Text('العربية'),
            value: 'ar',
            groupValue: selectedLanguage,
            onChanged: (value) {
              setState(() {
                selectedLanguage = value;
              });
            },
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          child: Text('CANCEL'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text('OK'),
          onPressed: () {
            // Update the language using localeController when 'OK' is pressed
            localeController.changeLange(selectedLanguage!);
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}

class PublicityPreviewScreen extends StatelessWidget {
  final Publicity pub;
  final Store? matchedStore;
  final LocationController locationController = Get.put(LocationController());

  PublicityPreviewScreen({required this.pub, this.matchedStore, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const ui.Color.fromARGB(255, 255, 255, 255),
      body: Stack(
        children: [
          // --- Background image ---
          Positioned.fill(
            child: CachedNetworkImage(
              imageUrl: pub.image,
              fit: BoxFit.contain,
              placeholder: (context, url) =>
                  Center(child: CircularProgressIndicator()),
            ),
          ),

          // --- Gradient Overlay ---
          // Positioned.fill(
          //   child: Container(
          //     decoration: BoxDecoration(
          //       gradient: LinearGradient(
          //         colors: [Colors.transparent, const ui.Color.fromARGB(255, 128, 128, 128).withOpacity(0.7)],
          //         begin: Alignment.topCenter,
          //         end: Alignment.bottomCenter,
          //       ),
          //     ),
          //   ),
          // ),

          // --- Button / Message ---
          Positioned(
            bottom: 40,
            left: 20,
            right: 20,
            child: matchedStore != null
                ? ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      Get.to(
                        () => StoreDetailScreen(storeId: matchedStore!.id),
                      );
                    },
                    icon: Icon(Icons.store),
                    label: Text('Aller au restaurant'),
                  )
                : Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        'Aucun restaurant associé',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: CircleAvatar(
                  backgroundColor: Colors.black54,
                  child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Get.back()),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
