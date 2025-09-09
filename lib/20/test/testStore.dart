import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spooding_exp_ios/20/test/testController.dart';
import 'package:spooding_exp_ios/20/view/screen.dart';
import 'package:spooding_exp_ios/controller.dart';

class StoreDetailScreen extends StatefulWidget {
  final int storeId;

  const StoreDetailScreen({super.key, required this.storeId});

  @override
  State<StoreDetailScreen> createState() => _StoreDetailScreenState();
}

class _StoreDetailScreenState extends State<StoreDetailScreen> {
  final CategoryController categoryController = Get.find<CategoryController>();
  final LocationController homeController = Get.put(LocationController());
  final CartController cartController = Get.put(CartController());

  @override
  void initState() {
    super.initState();
    categoryController.fetchStoreWithItems(widget.storeId);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final store = categoryController.selectedStore.value;

      if (categoryController.isLoadingStoreItems.value || store == null) {
        return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('images/bike.png', height: 200),
                const SizedBox(height: 20),
                Text(
                  "Chargement des produits...",
                  style: TextStyle(color: Colors.orange.shade700, fontSize: 16),
                ),
                const SizedBox(height: 16),
                CircularProgressIndicator(color: Colors.orange),
              ],
            ),
          ),
        );
      }

      return StoreScreen(store: store);
    });
  }
}
