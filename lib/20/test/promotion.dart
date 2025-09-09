import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spooding_exp_ios/20/test/category.dart';
import 'package:spooding_exp_ios/20/test/testController.dart';
import 'package:spooding_exp_ios/20/view/order.dart';
import 'package:spooding_exp_ios/controller.dart';
import 'package:spooding_exp_ios/model.dart';

class PromotionScreen extends StatelessWidget {
  final categoryController = Get.find<CategoryController>();
  final homeController = Get.find<ToutController>();
  final locationController = Get.find<LocationController>();
  final CartController cartController = Get.put(CartController());

  @override
  Widget build(BuildContext context) {
    final discountedItems = homeController.discountedItems.where((item) {
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
          free_delivery: false, firstItemImage: '',has_discounted_item: false,
        ),
      );

      if (locationController.currentPosition == null) return false;

      final distance = locationController.calculateDistance(
        locationController.currentPosition.value!.latitude,
        locationController.currentPosition.value!.longitude,
        store.latitude,
        store.longitude,
      );

      return distance <= locationController.maxDistance;
    }).toList();

    return Scaffold(
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
      appBar: AppBar(
        title: const Text(
          "Tous les articles en promotion",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.deepOrangeAccent,
      ),
      body: discountedItems.isEmpty
          ? const Center(child: Text("Aucune promotion disponible."))
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: discountedItems.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 5,
                childAspectRatio: 0.75,
              ),
              itemBuilder: (context, index) {
                final item = discountedItems[index];
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
                    free_delivery: false, firstItemImage: '',has_discounted_item: false,
                  ),
                );

                return FoodCardRecom(
                  name: item.name,
                  description: item.description,
                  price: item.price,
                  rating: item.average_rating,
                  storeName: store.name,
                  item: item,
                  store: store,
                  displayMode: 3,
                );
              },
            ),
    );
  }
}
