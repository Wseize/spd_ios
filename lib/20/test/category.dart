import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:spooding_exp_ios/20/test/testController.dart';
import 'package:spooding_exp_ios/20/view/itemsPage.dart';
import 'package:spooding_exp_ios/20/view/order.dart';
import 'package:spooding_exp_ios/controller.dart';
import 'package:spooding_exp_ios/model.dart';

class SubCategoryDetailScreen extends StatefulWidget {
  final int subCategoryId;

  const SubCategoryDetailScreen({super.key, required this.subCategoryId});

  @override
  State<SubCategoryDetailScreen> createState() =>
      _SubCategoryDetailScreenState();
}

class _SubCategoryDetailScreenState extends State<SubCategoryDetailScreen> {
  final CategoryController categoryController = Get.put(CategoryController());
  final LocationController locationController = Get.put(LocationController());
  final CartController cartController = Get.put(CartController());

  String selectedFilter = 'highRated';

  // لتخزين الكاتيجوري المحددة حاليا
  late int currentSubCategoryId;

  @override
  void initState() {
    super.initState();
    currentSubCategoryId = widget.subCategoryId;
    categoryController.fetchItemsBySubCategory(currentSubCategoryId);
  }

  List<Item> _filterAndSortItems(List<Item> items) {
    List<Item> filteredItems = List.from(items);

    // فلترة التوصيل المجاني فقط (تصفية لا ترتيب)
    if (selectedFilter == 'freeDelivery') {
      filteredItems = filteredItems.where((item) {
        final store = categoryController.stores.firstWhereOrNull(
          (s) => s.id == item.store,
        );
        return store?.free_delivery ?? false;
      }).toList();
    }

    // بناء على الفلتر نعمل ترتيب واحد فقط حسب المطلوب:
    switch (selectedFilter) {
      case 'priceAsc':
        filteredItems.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'priceDesc':
        filteredItems.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'highRated':
        // ترتيب حسب تقييم الـ item فقط (product rating)
        filteredItems.sort(
          (a, b) => b.average_rating.compareTo(a.average_rating),
        );
        break;
      case 'shortestDistance':
        final pos = locationController.currentPosition.value;
        if (pos != null) {
          filteredItems.sort((a, b) {
            final storeA = categoryController.stores.firstWhereOrNull(
              (s) => s.id == a.store,
            );
            final storeB = categoryController.stores.firstWhereOrNull(
              (s) => s.id == b.store,
            );

            if (storeA == null || storeB == null) return 0;

            final distA = locationController.calculateDistance(
              pos.latitude,
              pos.longitude,
              storeA.latitude,
              storeA.longitude,
            );
            final distB = locationController.calculateDistance(
              pos.latitude,
              pos.longitude,
              storeB.latitude,
              storeB.longitude,
            );

            return distA.compareTo(distB);
          });
        }
        break;

      // لو حبيت فلتر خاص بـ availability (المتاجر المتاحة) ممكن تعمله هنا:
      case 'availableOnly':
        filteredItems = filteredItems.where((item) {
          final store = categoryController.stores.firstWhereOrNull(
            (s) => s.id == item.store,
          );
          return store?.available ?? false;
        }).toList();
        break;

      // غير ذلك، لا ترتيب إضافي
      default:
        break;
    }

    return filteredItems;
  }

  // لما تختار كاتيجوري جديد
  void _onSubCategorySelected(int subCatId) {
    setState(() {
      currentSubCategoryId = subCatId;
    });
    categoryController.fetchItemsBySubCategory(subCatId);
  }

  @override
  Widget build(BuildContext context) {
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
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 4,
        iconTheme: IconThemeData(color: Colors.white),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.orange.shade900, Colors.orange.shade600],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Text(
          "Produits",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 22,
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.filter_list, color: Colors.white),
            onSelected: (value) {
              setState(() => selectedFilter = value);
            },
            itemBuilder: (context) => [
              PopupMenuItem(value: 'highRated', child: Text('Meilleure note')),
              PopupMenuItem(value: 'priceAsc', child: Text('Prix croissant')),
              PopupMenuItem(
                value: 'priceDesc',
                child: Text('Prix décroissant'),
              ),
              PopupMenuItem(
                value: 'freeDelivery',
                child: Text('Livraison gratuite'),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Subcategory horizontal list
          Container(
            height: 60,
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Obx(() {
              if (categoryController.subCategories.isEmpty) {
                return Center(child: Text("Aucune catégorie"));
              }
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categoryController.subCategories.length,
                itemBuilder: (context, index) {
                  final subCat = categoryController.subCategories[index];
                  final isSelected = subCat.id == currentSubCategoryId;
                  return GestureDetector(
                    onTap: () => _onSubCategorySelected(subCat.id),
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 250),
                      margin: EdgeInsets.symmetric(horizontal: 6, vertical: 10),
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.orange : Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: Colors.orange.shade200,
                                  blurRadius: 6,
                                  offset: Offset(0, 2),
                                ),
                              ]
                            : [],
                        border: Border.all(
                          color: Colors.orange.shade300,
                          width: isSelected ? 0 : 1.5,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          subCat.name,
                          style: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : Colors.orange.shade900,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
          ),

          // Product Grid
          Expanded(
            child: Obx(() {
              if (categoryController.isLoadingItems.value) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset("images/bike.png", height: 180),
                      SizedBox(height: 16),
                      CircularProgressIndicator(color: Colors.orange),
                    ],
                  ),
                );
              }

              final filteredItems = _filterAndSortItems(
                categoryController.items,
              );

              if (filteredItems.isEmpty) {
                return Center(child: Text("Aucun produit trouvé."));
              }

              return GridView.builder(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                itemCount: filteredItems.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.8,
                ),
                itemBuilder: (context, index) {
                  final item = filteredItems[index];
                  final store = categoryController.stores.firstWhereOrNull(
                    (s) => s.id == item.store,
                  );

                  if (store == null) return SizedBox();

                  return FoodCardRecom(
                    name: item.name,
                    description: item.description,
                    price: item.price,
                    rating: item.average_rating,
                    storeName: store.name,
                    item: item,
                    store: store,
                    displayMode: 1,
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}

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
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: item.fullImageUrl,
                    height: 100,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        height: 100,
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
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '-${item.percentage_discount.round()}%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
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
                        icon: const Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 20,
                        ),
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
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.storefront,
                        color: Colors.grey.shade600,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          storeName,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 13,
                          ),
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
                          Text(
                            rating.toStringAsFixed(1),
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      Text(
                        '${price.toStringAsFixed(2)} DT',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  if (displayMode == 2) const SizedBox(height: 10),
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
