// ignore_for_file: prefer_const_constructors, avoid_print, use_key_in_widget_constructors, library_private_types_in_public_api, prefer_const_literals_to_create_immutables, unused_field

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:photo_view/photo_view.dart';
import 'package:spooding_exp_ios/20/test/testController.dart';
import 'package:spooding_exp_ios/20/test/testStore.dart';
import 'package:spooding_exp_ios/20/view/order.dart';
import 'package:spooding_exp_ios/controller.dart';
import 'package:spooding_exp_ios/model.dart';
// class FoodsPage extends StatelessWidget {
//   final Store store;
//   final CartController cartController = Get.put(CartController());
//   final HomeController homeController = Get.put(HomeController());
//   final CategoryController categoryController = Get.put(CategoryController());

//   FoodsPage({required this.store});

//   Map<String, List<Item>> getItemsBySubcategory() {
//     Map<String, List<Item>> itemsBySubcategory = {};

//     for (var item in store.items) {
//       String subcategory = item.sub_category_name!;
//       if (!itemsBySubcategory.containsKey(subcategory)) {
//         itemsBySubcategory[subcategory] = [];
//       }
//       itemsBySubcategory[subcategory]!.add(item);
//     }

//     return itemsBySubcategory;
//   }

//   @override
//   Widget build(BuildContext context) {
//     categoryController.fetchNoticeStores();
//     Map<String, List<Item>> itemsBySubcategory = getItemsBySubcategory();

//     bool isStoreAvailable = store.available;

//     return DefaultTabController(
//       length: itemsBySubcategory.keys.length,
//       child: Scaffold(
//         floatingActionButton: cartController.cart.isNotEmpty
//             ? Stack(
//                 children: [
//                   FloatingActionButton(
//                     onPressed: () {
//                       Navigator.pushAndRemoveUntil(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => MainHomePage(initialIndex: 1),
//                         ),
//                         (Route<dynamic> route) => false,
//                       );
//                     },
//                     child: Icon(
//                       Icons.shopping_basket_outlined,
//                       size: 30,
//                       color: Colors.orange.shade400,
//                     ),
//                   ),
//                   Positioned(
//                     right: 0,
//                     top: 0,
//                     child: CircleAvatar(
//                       backgroundColor: Colors.red,
//                       radius: 12,
//                       child: Text(
//                         '${cartController.cart.length}',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 12,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               )
//             : null,
//         body: SafeArea(
//           child: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Column(
//               children: [
//                 Column(
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         Column(
//                           children: [
//                             SizedBox(
//                               height: 15,
//                             ),
//                             CircleAvatar(
//                               backgroundImage:
//                                   CachedNetworkImageProvider(store.image),
//                               radius: 65,
//                             ),
//                           ],
//                         ),
//                         Column(
//                           children: [
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 SizedBox(width: 150),
//                                 Obx(() {
//                                   return GestureDetector(
//                                     onTap: () async {
//                                       bool isFavorite = categoryController
//                                           .isFavorite(store.id);
//                                       categoryController.fetchFavoriteVendors();
//                                       categoryController.fetchStores();

//                                       if (isFavorite) {
//                                         await categoryController
//                                             .removeFavoritestore(store.id);
//                                       } else {
//                                         await categoryController
//                                             .addFavoritestore(store.id);
//                                       }
//                                       Get.forceAppUpdate();
//                                     },
//                                     child: Icon(
//                                       categoryController.isFavorite(store.id)
//                                           ? Icons.favorite
//                                           : Icons.favorite_border,
//                                       color: categoryController
//                                               .isFavorite(store.id)
//                                           ? Colors.red
//                                           : null,
//                                       size: 30,
//                                     ),
//                                   );
//                                 }),
//                               ],
//                             ),
//                             SizedBox(
//                               height: 15,
//                             ),
//                             Column(
//                               children: [
//                                 Text(
//                                   store.name,
//                                   style: TextStyle(
//                                       fontSize: 25,
//                                       fontWeight: FontWeight.bold),
//                                 ),
//                                 Divider(),
//                                 RatingBar.builder(
//                                     initialRating: store.average_rating,
//                                     minRating: 1,
//                                     direction: Axis.horizontal,
//                                     allowHalfRating: false,
//                                     itemCount: 5,
//                                     itemSize: 30,
//                                     itemPadding:
//                                         EdgeInsets.symmetric(horizontal: 2.0),
//                                     itemBuilder: (context, _) => Icon(
//                                           Icons.star,
//                                           color: Colors.amber,
//                                         ),
//                                     onRatingUpdate: (newRating) {
//                                       cartController.sendFeedbackRatingStore(
//                                           store.id, newRating);
//                                       categoryController.fetchStores();
//                                       Get.forceAppUpdate();
//                                     }),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                     SizedBox(
//                       height: 15,
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         Row(
//                           children: [
//                             Text(
//                               '${store.average_rating.toStringAsFixed(2)}',
//                             ),
//                             SizedBox(
//                               width: 5,
//                             ),
//                             Icon(
//                               Icons.star,
//                               color: Colors.orange.shade400,
//                             ),
//                           ],
//                         ),
//                         Row(
//                           children: [
//                             Text(
//                               '${store.favorited_by.length}',
//                             ),
//                             SizedBox(
//                               width: 5,
//                             ),
//                             Icon(
//                               Icons.favorite_border,
//                               color: Colors.red,
//                             ),
//                           ],
//                         ),
//                         Row(
//                           children: [
//                             Text(
//                               '${categoryController.notices.where((notice) => notice.store == store.id).length}',
//                             ),
//                             SizedBox(
//                               width: 5,
//                             ),
//                             GestureDetector(
//                               onTap: () {
//                                 categoryController.fetchNoticeStores();
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) => NoticePage(
//                                       storeId: store.id,
//                                     ),
//                                   ),
//                                 );
//                               },
//                               child: Icon(
//                                 Icons.messenger_outline_rounded,
//                                 color: Colors.red,
//                               ),
//                             ),
//                           ],
//                         ),
//                         Row(
//                           children: [
//                             homeController.currentPosition != null
//                                 ? Text(
//                                     '${homeController.calculateDistance(homeController.currentPosition!.latitude, homeController.currentPosition!.longitude, store.latitude, store.longitude).toStringAsFixed(2)} km',
//                                   )
//                                 : Text(
//                                     'not available',
//                                     style: TextStyle(color: Colors.red),
//                                   ),
//                             SizedBox(
//                               width: 5,
//                             ),
//                             Icon(
//                               Icons.directions_bike,
//                               color: Colors.grey.shade600,
//                             ),
//                           ],
//                         ),
//                       ],
//                     )
//                   ],
//                 ),
//                 Divider(),
//                 TabBar(
//                   isScrollable: true,
//                   tabs: itemsBySubcategory.keys.map((subcategory) {
//                     return Tab(text: subcategory);
//                   }).toList(),
//                 ),
//                 Expanded(
//                   child: Stack(
//                     children: [
//                       TabBarView(
//                         children: itemsBySubcategory.entries.map((entry) {
//                           List<Item> items = entry.value;

//                           return GridView.builder(
//                             padding: const EdgeInsets.all(8.0),
//                             itemCount: items.length,
//                             gridDelegate:
//                                 SliverGridDelegateWithFixedCrossAxisCount(
//                               crossAxisCount: 2,
//                               crossAxisSpacing: 8.0,
//                               mainAxisSpacing: 8.0,
//                               childAspectRatio: 0.8,
//                             ),
//                             itemBuilder: (context, index) {
//                               var item = items[index];
//                               return GestureDetector(
//                                 onTap: isStoreAvailable && item.available
//                                     ? () {
//                                         Navigator.push(
//                                           context,
//                                           MaterialPageRoute(
//                                             builder: (context) =>
//                                                 FoodDetailPage(item: item),
//                                           ),
//                                         );
//                                       }
//                                     : null,
//                                 child: Container(
//                                   decoration: BoxDecoration(
//                                     border: Border.all(
//                                       color: Colors.grey,
//                                       width: 1.0,
//                                     ),
//                                     borderRadius: BorderRadius.circular(10.0),
//                                   ),
//                                   child: Center(
//                                     child: Stack(
//                                       children: [
//                                         Column(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.center,
//                                           children: [
//                                             SizedBox(height: 15),
//                                             CircleAvatar(
//                                               radius: 65,
//                                               backgroundImage:
//                                                   CachedNetworkImageProvider(
//                                                       item.image),
//                                             ),
//                                             SizedBox(height: 5),
//                                             Column(
//                                               crossAxisAlignment:
//                                                   CrossAxisAlignment.start,
//                                               children: [
//                                                 Text(
//                                                   item.name,
//                                                   style:
//                                                       TextStyle(fontSize: 15),
//                                                 ),
//                                                 SizedBox(height: 3),
//                                                 Text(
//                                                   '${item.price} dt',
//                                                   style: TextStyle(
//                                                       fontSize: 12,
//                                                       color: Colors.grey),
//                                                 ),
//                                               ],
//                                             )
//                                           ],
//                                         ),
//                                         if (!item.available)
//                                           Container(
//                                             decoration: BoxDecoration(
//                                               borderRadius:
//                                                   BorderRadius.circular(10.0),
//                                               color:
//                                                   Colors.grey.withOpacity(0.4),
//                                             ),
//                                             child: Center(
//                                               child: Text(
//                                                 'Stock en rupture',
//                                                 style: TextStyle(
//                                                   color: Colors.red.shade900,
//                                                   fontSize: 16,
//                                                   fontWeight: FontWeight.bold,
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               );
//                             },
//                           );
//                         }).toList(),
//                       ),
//                       if (!isStoreAvailable)
//                         Container(
//                           color: Colors.white.withOpacity(0.6),
//                           child: Center(
//                             child: Text(
//                               'Store Closed\nCannot send delivery now',
//                               textAlign: TextAlign.center,
//                               style: TextStyle(
//                                 color: Colors.red.shade900,
//                                 fontSize: 24,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                         ),
//                     ],
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

class FoodDetailPage extends StatelessWidget {
  final Item item;

  FoodDetailPage({required this.item});

  final CartController cartController = Get.put(CartController());
  final CategoryController categoryController = Get.put(CategoryController());
  final LocationController locationController = Get.put(LocationController());

  @override
  Widget build(BuildContext context) {
    final Store? store = categoryController.stores.firstWhereOrNull(
      (s) => s.id == item.store,
    );

    return Scaffold(
      backgroundColor: Colors.orange.shade400,
      floatingActionButton: cartController.cart.isNotEmpty
          ? Stack(
              children: [
                FloatingActionButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => AddCartScreen()),
                    );
                  },
                  child: Icon(
                    Icons.shopping_basket_outlined,
                    size: 30,
                    color: Colors.orange.shade400,
                  ),
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: CircleAvatar(
                    backgroundColor: Colors.red,
                    radius: 12,
                    child: Text(
                      '${cartController.cart.length}',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
              ],
            )
          : null,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          item.name,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: store == null
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: _buildOtherCategoryContent(context, store),
            ),
    );
  }

  Widget _buildOtherCategoryContent(BuildContext context, Store store) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            Container(height: MediaQuery.of(context).size.height),
            Positioned(
              bottom: 0,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.6,
                width: MediaQuery.of(context).size.width,
                color: Colors.white,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 120),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: _buildRatingSection(),
                      ),
                      _buildDescriptionSection(context, store),
                      _buildPriceAndCartSection(context, store),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              left: 0,
              child: _buildOtherImageSection(),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildOtherImageSection() {
    return Stack(
      children: [
        Hero(
          tag: 'item_${item.id}',
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
            child: CachedNetworkImage(
              imageUrl: item.fullImageUrl,
              fit: BoxFit.cover,
              height: 420,
              width: double.infinity,
            ),
          ),
        ),
        Container(
          height: 300,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.7),
                Colors.black.withOpacity(0.0),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRatingSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text('${item.average_rating.toStringAsFixed(2)}'),
              Icon(Icons.star, color: Colors.orange.shade400),
            ],
          ),
          RatingBar.builder(
            initialRating: item.average_rating,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: false,
            itemCount: 5,
            itemSize: 30,
            itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
            itemBuilder: (context, index) {
              return Icon(
                Icons.star,
                color: categoryController.userProfile.value.id != 0
                    ? Colors.amber
                    : Color.fromARGB(255, 146, 125, 125),
              );
            },
            onRatingUpdate: (newRating) {
              if (categoryController.userProfile.value.id != 0) {
                cartController.sendFeedbackRating(item.id, newRating);
                Get.forceAppUpdate();
              } else {
                Get.defaultDialog(
                  title: 'Veuillez vous connecter',
                  middleText:
                      'Vous devez être connecté pour noter cet article.',
                  textConfirm: 'Se connecter',
                  onConfirm: () {
                    Get.back();
                    // Get.to(LoginScreen());
                  },
                  textCancel: 'Annuler',
                  onCancel: () {},
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionSection(BuildContext context, Store store) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              Get.to(() => StoreDetailScreen(storeId: store.id));
            },
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: CachedNetworkImageProvider(store.image),
                  radius: 30,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            store.name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                            ),
                          ),
                          SizedBox(width: 15),
                        ],
                      ),
                      Row(
                        children: [
                          Text('${store.average_rating}'),
                          Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Icon(
                              Icons.star,
                              color: Colors.orange.shade400,
                            ),
                          ),
                          Text('(${store.ratings.length})'),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Description',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w400,
              color: Colors.black54,
            ),
          ),
          SizedBox(height: 8),
          Padding(
            padding: EdgeInsets.only(left: 10),
            child: Text(
              item.description,
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
          ),
          SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildPriceAndCartSection(BuildContext context, Store store) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
            onTap: store.available
                ? () {
                    if (!item.available) {
                      _showOutOfStockDialog(context);
                    } else {
                      bool isDifferentStore = cartController.cart.isNotEmpty &&
                          cartController.cart.first['item'].store != store.id;

                      if (isDifferentStore) {
                        _showStoreChangeDialog(context, cartController, store);
                      } else {
                        _handleAddToCart(context, cartController, store);
                      }
                    }
                  }
                : null,
            child: store.available
                ? Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.orange.shade400,
                          Colors.orange.shade400,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'Ajouter au panier',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  )
                : Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.red, Colors.orange.shade400],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'Restaurant fermé',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
          ),
          item.percentage_discount != 0.0
              ? Column(
                  children: [
                    Text(
                      '${item.price.toStringAsFixed(2)} dt',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${(item.price / (1 - item.percentage_discount / 100)).toStringAsFixed(2)} dt',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  ],
                )
              : Text(
                  '${item.price.toStringAsFixed(2)} dt',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
        ],
      ),
    );
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

  void _showStoreChangeDialog(
    BuildContext context,
    CartController cartController,
    Store store,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Supprimer l\'ancienne sélection'),
          content: Text(
            'Vous avez des articles d\'un autre magasin dans votre panier. Voulez-vous les supprimer et ajouter les articles de ce magasin ?',
          ),
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

class NoticePage extends StatelessWidget {
  final CategoryController categoryController = Get.put(CategoryController());
  final int storeId;

  NoticePage({Key? key, required this.storeId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController noticeController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Image.asset('images/logo2.png', height: 125, width: 125),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: noticeController,
                    decoration: InputDecoration(
                      labelText: 'Enter notice',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  String noticeText = noticeController.text.trim();
                  if (noticeText.isNotEmpty) {
                    categoryController.createNotice(noticeText, storeId);
                    noticeController.clear();
                  }
                },
                icon: Icon(Icons.send),
              ),
            ],
          ),
          SizedBox(height: 16), // Spacer
          Obx(() {
            if (categoryController.isLoading.value) {
              return Center(child: CircularProgressIndicator());
            } else {
              var filteredNotices = categoryController.notices
                  .where((notice) => notice.store == storeId)
                  .toList();

              if (filteredNotices.isEmpty) {
                return Center(child: Text('No notices found for store'));
              } else {
                return Expanded(
                  child: ListView.builder(
                    itemCount: filteredNotices.length,
                    itemBuilder: (context, index) {
                      var notice = filteredNotices.reversed.toList()[index];
                      String username = notice.user.username;
                      String maskedUsername;

                      if (username.length > 3) {
                        String maskedPart = '*' * (username.length - 3);
                        String lastThreeDigits = username.substring(
                          username.length - 3,
                        );
                        maskedUsername = maskedPart + lastThreeDigits;
                      } else {
                        maskedUsername = username;
                      }
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          title: Text(notice.notice),
                          subtitle: Text(maskedUsername),
                          trailing: notice.user.username ==
                                  categoryController.userProfile.value.username
                              ? IconButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text("Confirm Deletion"),
                                          content: Text(
                                            "Are you sure you want to delete this notice?",
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text("Cancel"),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                categoryController.deleteNotice(
                                                  notice.id,
                                                );
                                                categoryController
                                                    .fetchNoticeStores();
                                                Navigator.of(context).pop();
                                              },
                                              child: Text("Delete"),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  icon: Icon(Icons.delete, color: Colors.red),
                                )
                              : null,
                        ),
                      );
                    },
                  ),
                );
              }
            }
          }),
        ],
      ),
    );
  }
}

class CategoryFoodsPage extends StatelessWidget {
  final List<Item> items;
  final String categoryName;
  final CartController cartController = Get.put(CartController());
  final CategoryController categoryController = Get.put(CategoryController());

  CategoryFoodsPage({required this.items, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          categoryName,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.orange.shade400,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) {
            var food = items[index];
            var store = LocationController().findStoreByItemId(
              food.id,
              categoryController,
            );
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FoodDetailPage(item: food),
                  ),
                );
              },
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 1.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    width: MediaQuery.of(context).size.width / 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 15),
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: CachedNetworkImageProvider(
                            food.fullImageUrl,
                          ),
                        ),
                        SizedBox(height: 5),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(food.name, style: TextStyle(fontSize: 15)),
                            SizedBox(height: 3),
                            Text(
                              '${food.price} dt',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  store.available
                      ? Positioned(
                          top: 10,
                          right: 10,
                          child: CircleAvatar(
                            backgroundColor: Colors.green,
                            radius: 20,
                            child: IconButton(
                              onPressed: () {
                                // if (food.personalized) {
                                //   showModalBottomSheet(
                                //     context: context,
                                //     builder: (context) {
                                //       List<Suppliment> selectedSupplements = [];
                                //       var supplementsByCategory =
                                //           <String, List<Suppliment>>{};

                                //       // Group supplements by category
                                //       for (var supplement in food.suppliments) {
                                //         if (!supplementsByCategory
                                //             .containsKey(supplement.category)) {
                                //           supplementsByCategory[
                                //               supplement.category] = [];
                                //         }
                                //         supplementsByCategory[
                                //                 supplement.category]!
                                //             .add(supplement);
                                //       }

                                //       return StatefulBuilder(
                                //         builder: (BuildContext context,
                                //             StateSetter setState) {
                                //           return Column(
                                //             mainAxisSize: MainAxisSize.min,
                                //             children: [
                                //               Expanded(
                                //                 child: ListView(
                                //                   children:
                                //                       supplementsByCategory
                                //                           .entries
                                //                           .expand((entry) {
                                //                     var category = entry.key;
                                //                     var supplements =
                                //                         entry.value;
                                //                     return [
                                //                       Padding(
                                //                         padding:
                                //                             const EdgeInsets
                                //                                 .symmetric(
                                //                                 vertical: 8.0,
                                //                                 horizontal:
                                //                                     16.0),
                                //                         child: Text(
                                //                           category,
                                //                           style: TextStyle(
                                //                               fontSize: 16,
                                //                               fontWeight:
                                //                                   FontWeight
                                //                                       .bold),
                                //                         ),
                                //                       ),
                                //                       ...supplements
                                //                           .map((supplement) {
                                //                         return CheckboxListTile(
                                //                           title: Text(
                                //                               supplement.title),
                                //                           subtitle: Text(
                                //                               '${supplement.price} dt'),
                                //                           value:
                                //                               selectedSupplements
                                //                                   .contains(
                                //                                       supplement),
                                //                           onChanged:
                                //                               (bool? value) {
                                //                             setState(() {
                                //                               if (value ==
                                //                                   true) {
                                //                                 selectedSupplements
                                //                                     .add(
                                //                                         supplement);
                                //                               } else {
                                //                                 selectedSupplements
                                //                                     .remove(
                                //                                         supplement);
                                //                               }
                                //                             });
                                //                           },
                                //                         );
                                //                       }).toList()
                                //                     ];
                                //                   }).toList(),
                                //                 ),
                                //               ),
                                //               ElevatedButton(
                                //                 onPressed: () {
                                //                   cartController.addToCart(
                                //                       food, 1,
                                //                       selectedSuppliments:
                                //                           selectedSupplements);
                                //                   Navigator.pop(context);
                                //                   ScaffoldMessenger.of(context)
                                //                       .showSnackBar(
                                //                     SnackBar(
                                //                       content: Text(
                                //                           '${food.name} with supplements added to cart'),
                                //                     ),
                                //                   );
                                //                 },
                                //                 child: Text('Add to Cart'),
                                //               ),
                                //             ],
                                //           );
                                //         },
                                //       );
                                //     },
                                //   );
                                // } else {
                                //   cartController.addToCart(food, 1);
                                //   ScaffoldMessenger.of(context).showSnackBar(
                                //     SnackBar(
                                //       content:
                                //           Text('${food.name} added to cart'),
                                //     ),
                                //   );
                                // }
                                bool isDifferentStore = cartController
                                        .cart.isNotEmpty &&
                                    cartController.cart.first['item'].store !=
                                        store.id;

                                if (isDifferentStore) {
                                  _showStoreChangeDialog(context, store, food);
                                } else {
                                  _handleAddToCart(context, store, food);
                                }
                              },
                              icon: Icon(Icons.add_shopping_cart, size: 16),
                            ),
                          ),
                        )
                      : Positioned(
                          top: 10,
                          right: 10,
                          child: CircleAvatar(
                            backgroundColor: Colors.red,
                            child: Icon(
                              Icons.night_shelter_sharp,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _showStoreChangeDialog(BuildContext context, Store store, Item item) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Supprimer l\'ancienne sélection'),
          content: Text(
            'Vous avez des articles d\'un autre magasin dans votre panier. Voulez-vous les supprimer et ajouter les articles de ce magasin ?',
          ),
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
                _handleAddToCart(context, store, item);
              },
              child: Text('Oui'),
            ),
          ],
        );
      },
    );
  }

  void _handleAddToCart(BuildContext context, Store store, Item item) {
    if (item.personalized) {
      showModalBottomSheet(
        context: context,
        builder: (context) {
          List<Suppliment> selectedSupplements = [];
          var supplementsByCategory = <String, List<Suppliment>>{};

          // Group supplements by category
          for (var supplement in item.suppliments) {
            if (!supplementsByCategory.containsKey(supplement.category)) {
              supplementsByCategory[supplement.category] = [];
            }
            supplementsByCategory[supplement.category]!.add(supplement);
          }

          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: ListView(
                      children: supplementsByCategory.entries.expand((entry) {
                        var category = entry.key;
                        var supplements = entry.value;
                        return [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 8.0,
                              horizontal: 16.0,
                            ),
                            child: Text(
                              category,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          ...supplements.map((supplement) {
                            return CheckboxListTile(
                              title: Text(supplement.title),
                              subtitle: Text('${supplement.price} dt'),
                              value: selectedSupplements.contains(supplement),
                              onChanged: (bool? value) {
                                setState(() {
                                  if (value == true) {
                                    selectedSupplements.add(supplement);
                                  } else {
                                    selectedSupplements.remove(supplement);
                                  }
                                });
                              },
                            );
                          }).toList(),
                        ];
                      }).toList(),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      cartController.addToCart(
                        item,
                        1,
                        selectedSuppliments: selectedSupplements,
                      );
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            '${item.name} with supplements added to cart',
                          ),
                        ),
                      );
                    },
                    child: Text('Add to Cart'),
                  ),
                ],
              );
            },
          );
        },
      );
    } else {
      cartController.addToCart(item, 1);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('${item.name} added to cart')));
    }
  }
}

class FullScreenImageScreen extends StatelessWidget {
  final String imageUrl;
  final Store? store;

  FullScreenImageScreen({required this.imageUrl, this.store});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: GestureDetector(
        onTap: () {
          if (store != null && store!.id != 0) {
            Get.to(() => StoreDetailScreen(storeId: store!.id));
          }
        },
        child: Container(
          child: PhotoView(imageProvider: NetworkImage(imageUrl)),
        ),
      ),
    );
  }
}
