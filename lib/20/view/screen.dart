import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:spooding_exp_ios/20/test/testController.dart';
import 'package:spooding_exp_ios/20/view/itemsPage.dart';
import 'package:spooding_exp_ios/20/view/loginScreen.dart';
import 'package:spooding_exp_ios/controller.dart';
import 'package:spooding_exp_ios/model.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:spooding_exp_ios/20/view/itemsPage.dart';
import 'package:spooding_exp_ios/20/view/loginScreen.dart';
import 'package:spooding_exp_ios/controller.dart';
import 'package:spooding_exp_ios/model.dart';

class StoreScreen extends StatelessWidget {
  final CategoryController categoryController = Get.find<CategoryController>();
  final LocationController homeController = Get.put(LocationController());
  final CartController cartController = Get.put(CartController());
  final Store store;

  // Reactive ratings
  final RxDouble averageRating = 0.0.obs;
  final RxDouble userRating = 0.0.obs;

  StoreScreen({required this.store}) {
    averageRating.value = store.average_rating;
    userRating.value = 0.0; // initial rating for user
  }

  @override
  Widget build(BuildContext context) {
    categoryController.fetchUserProfile();
    categoryController.searchController.clear();
    Map<String, List<Item>> itemsBySubcategory = getItemsBySubcategory();

    double distance = homeController.calculateDistance(
      homeController.currentPosition.value!.latitude,
      homeController.currentPosition.value!.longitude,
      store.latitude,
      store.longitude,
    );

    int estimatedTime = ((distance).ceil() * 5) + 10;

    return DefaultTabController(
      length: itemsBySubcategory.length,
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              background(),
              CustomScrollView(
                slivers: [
                  SliverAppBar(
                    backgroundColor: const Color.fromARGB(129, 255, 224, 178),
                    pinned: true,
                    expandedHeight: 200,
                    flexibleSpace: FlexibleSpaceBar(
                      titlePadding: EdgeInsets.only(
                        bottom: 110,
                        left: MediaQuery.of(context).size.width * 0.1,
                      ),
                      title: Text(
                        store.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.grey.shade500,
                        ),
                      ),
                      background: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                  SizedBox(height: 65),
                                  Column(
                                    children: [
                                      Divider(),
                                      Obx(() => RatingBar.builder(
                                            initialRating: userRating.value,
                                            minRating: 1,
                                            direction: Axis.horizontal,
                                            allowHalfRating: false,
                                            itemCount: 5,
                                            itemSize: 30,
                                            itemBuilder: (context, index) {
                                              return Icon(
                                                Icons.star,
                                                color: categoryController
                                                            .userProfile
                                                            .value
                                                            .id !=
                                                        0
                                                    ? Colors.amber
                                                    : Color.fromARGB(
                                                        255, 146, 125, 125),
                                              );
                                            },
                                            onRatingUpdate: (newRating) async {
                                              if (categoryController
                                                      .userProfile.value.id !=
                                                  0) {
                                                // Update UI immediately
                                                userRating.value = newRating;
                                                averageRating.value = newRating;

                                                await cartController
                                                    .sendFeedbackRatingStore(
                                                        store.id, newRating);

                                                Get.snackbar(
                                                  "Thank you!",
                                                  "Your rating has been recorded.",
                                                  snackPosition:
                                                      SnackPosition.TOP,
                                                  backgroundColor: Colors.green
                                                      .withOpacity(0.8),
                                                  colorText: Colors.white,
                                                  duration:
                                                      Duration(seconds: 2),
                                                );
                                              } else {
                                                Get.defaultDialog(
                                                  title: 'Please Login',
                                                  middleText:
                                                      'You need to be logged in to rate this store.',
                                                  textConfirm: 'Login',
                                                  onConfirm: () {
                                                    Get.back();
                                                    Get.to(LoginScreen());
                                                  },
                                                  textCancel: 'Cancel',
                                                );
                                              }
                                            },
                                          ))
                                    ],
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  SizedBox(height: 15),
                                  Stack(
                                    children: [
                                      CircleAvatar(
                                        backgroundImage:
                                            CachedNetworkImageProvider(
                                                store.image),
                                        radius: 65,
                                      ),
                                      Positioned(
                                        top: 0,
                                        right: 0,
                                        child: Obx(() {
                                          bool isFavorite = categoryController
                                              .isFavorite(store.id);
                                          return GestureDetector(
                                            onTap: () async {
                                              if (categoryController
                                                      .userProfile.value.id !=
                                                  0) {
                                                if (isFavorite) {
                                                  await categoryController
                                                      .removeFavoritestore(
                                                          store.id);
                                                } else {
                                                  await categoryController
                                                      .addFavoritestore(
                                                          store.id);
                                                }
                                              } else {
                                                Get.defaultDialog(
                                                  title: 'Please Login',
                                                  middleText:
                                                      'You need to be logged in to add stores to your favorites.',
                                                  textConfirm: 'Login',
                                                  onConfirm: () {
                                                    Get.back();
                                                    Get.to(LoginScreen());
                                                  },
                                                  textCancel: 'Cancel',
                                                );
                                              }
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: isFavorite
                                                      ? Colors.orange.shade500
                                                      : Colors.white,
                                                  width: 2,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                              ),
                                              child: Icon(
                                                isFavorite
                                                    ? Icons.favorite
                                                    : Icons.favorite_border,
                                                color: isFavorite
                                                    ? Colors.red
                                                    : Colors.white,
                                                size: 50,
                                              ),
                                            ),
                                          );
                                        }),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 15),
                          Obx(() => Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                          '${store.average_rating.toStringAsFixed(2)}'),
                                      SizedBox(width: 5),
                                      Icon(
                                        Icons.star,
                                        color: Colors.orange.shade400,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text('${store.favorited_by.length}'),
                                      SizedBox(width: 5),
                                      Icon(
                                        Icons.favorite_border,
                                        color: Colors.red,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        '${categoryController.notices.where((notice) => notice.store == store.id).length}',
                                      ),
                                      SizedBox(width: 5),
                                      GestureDetector(
                                        onTap: () {
                                          categoryController
                                              .fetchNoticeStores();
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  NoticePage(storeId: store.id),
                                            ),
                                          );
                                        },
                                        child: Icon(
                                          Icons.messenger_outline_rounded,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      homeController.currentPosition != null
                                          ? Text("${estimatedTime} min ")
                                          : Text(
                                              'not available',
                                              style: TextStyle(
                                                fontSize: 10,
                                                color: Colors.red,
                                              ),
                                            ),
                                      Icon(
                                        Icons.timer_outlined,
                                        color: Colors.orange.shade400,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      homeController.currentPosition != null
                                          ? Text(
                                              '${homeController.calculateDistance(homeController.currentPosition.value!.latitude, homeController.currentPosition.value!.longitude, store.latitude, store.longitude).toStringAsFixed(2)} km',
                                            )
                                          : Text(
                                              'not available',
                                              style: TextStyle(
                                                color: Colors.red,
                                              ),
                                            ),
                                      SizedBox(width: 5),
                                      Icon(
                                        Icons.directions_bike,
                                        color: Colors.grey.shade600,
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Builder(
                      builder: (context) {
                        final promoItems = store.items
                            .where((i) => i.percentage_discount != 0.0)
                            .toList();
                        if (promoItems.isEmpty) {
                          return SizedBox.shrink(); // ne rien afficher
                        }
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Container(
                            height: 220,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: promoItems.length,
                              itemBuilder: (context, index) {
                                final item = promoItems[index];
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
                                  child: Container(
                                    width: 160,
                                    margin: EdgeInsets.only(
                                        left: index == 0 ? 16 : 8, right: 8),
                                    child: Card(
                                      elevation: 6,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                      clipBehavior: Clip.antiAlias,
                                      child: Stack(
                                        fit: StackFit.expand,
                                        children: [
                                          CachedNetworkImage(
                                            imageUrl: item.image,
                                            fit: BoxFit.cover,
                                          ),
                                          Positioned(
                                            bottom: 0,
                                            left: 0,
                                            right: 0,
                                            child: Container(
                                              padding: EdgeInsets.all(8),
                                              color:
                                                  Colors.black.withOpacity(0.6),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    item.name,
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  // Row(
                                                  //   children: [

                                                  //   ],
                                                  // ),
                                                  Text(
                                                    '${item.price.toStringAsFixed(2)} dt',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 18),
                                                  ),
                                                  Text(
                                                    '${(item.price * 100 / (100 - item.percentage_discount)).toStringAsFixed(2)} dt',
                                                    style: TextStyle(
                                                      color: Colors.redAccent,
                                                      decoration: TextDecoration
                                                          .lineThrough,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            top: 0,
                                            left: 0,
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 8, vertical: 4),
                                              decoration: BoxDecoration(
                                                color: Colors.redAccent,
                                                borderRadius: BorderRadius.only(
                                                  bottomRight:
                                                      Radius.circular(12),
                                                ),
                                              ),
                                              child: Text(
                                                '${item.percentage_discount.toInt()}% OFF',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: TabBar(
                      labelColor: Colors.orange.shade500,
                      indicatorColor: Colors.orange.shade400,
                      isScrollable: true,
                      tabs: itemsBySubcategory.keys
                          .map((subcategory) => Tab(text: subcategory))
                          .toList(),
                    ),
                  ),
                  SliverFillRemaining(
                    child: TabBarView(
                      children: itemsBySubcategory.keys.map((subcategory) {
                        List<Item> items =
                            itemsBySubcategory[subcategory] ?? [];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              childAspectRatio: 3 / 4,
                            ),
                            itemCount: items.length,
                            itemBuilder: (context, index) {
                              final item = items[index];
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
                                child: Card(
                                  elevation: 10,
                                  clipBehavior: Clip.antiAlias,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      Hero(
                                        tag: 'item_${item.id}',
                                        child: CachedNetworkImage(
                                          imageUrl: item.image,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Positioned(
                                        right: 5,
                                        left: 5,
                                        bottom: 5,
                                        child: buildPriceProducts(
                                          title: item.name,
                                          price: item.price.toStringAsFixed(1),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget background() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomLeft,
          colors: [
            Colors.orange.withOpacity(0.5),
            Colors.grey.withOpacity(0.3),
            Colors.transparent,
          ],
        ),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(color: Colors.grey.shade200.withOpacity(0.3)),
      ),
    );
  }

  Widget buildPriceProducts({required String title, required String price}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.hardEdge,
      color: Colors.transparent,
      child: Container(
        padding: EdgeInsets.all(12),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.3),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: TextStyle(
                    color: Colors.white70,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
            Text('$price dt',
                style: TextStyle(
                    color: Colors.white70,
                    fontWeight: FontWeight.bold,
                    fontSize: 14)),
          ],
        ),
      ),
    );
  }

  Map<String, List<Item>> getItemsBySubcategory() {
    Map<String, List<Item>> itemsBySubcategory = {};
    for (var item in store.items) {
      String subcategory = item.sub_category_name ?? 'Other';
      itemsBySubcategory.putIfAbsent(subcategory, () => []);
      itemsBySubcategory[subcategory]!.add(item);
    }
    itemsBySubcategory.forEach((key, list) {
      list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    });
    return itemsBySubcategory;
  }
}
