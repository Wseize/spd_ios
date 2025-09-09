// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:spooding_exp_ios/20/express.dart';
import 'package:spooding_exp_ios/20/test/testController.dart';
import 'package:spooding_exp_ios/20/view/background.dart';
import 'package:spooding_exp_ios/20/view/coupon.dart';
import 'package:spooding_exp_ios/20/view/loginScreen.dart';
import 'package:spooding_exp_ios/20/view/signUpScreen.dart';
import 'package:spooding_exp_ios/20/view/wallet/controller.dart';
import 'package:spooding_exp_ios/controller.dart';
import 'package:spooding_exp_ios/model.dart';

class AddCartScreen extends StatelessWidget {
  final CategoryController categoryController = Get.put(CategoryController());
  final CartController cartController = Get.put(CartController());
  final WalletController walletController = Get.put(WalletController());
  final LocationController locationController = Get.put(LocationController());
  final TextEditingController senderNameController = TextEditingController();
  final TextEditingController senderMobileController = TextEditingController();
  final TextEditingController senderEmailController = TextEditingController();
  final TextEditingController senderAdressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final total = cartController.cart.fold<double>(0, (previousValue, item) {
      final food = item['item'] as Item;
      final quantity = item['quantity'] as int;
      final suppliments = item['suppliments'] as List<Suppliment>;

      final totalSupplimentsPrice = suppliments.fold<double>(
        0.0,
        (sum, suppliment) => sum + suppliment.price,
      );
      return previousValue + (food.price + totalSupplimentsPrice) * quantity;
    });

    final foundStore = categoryController.stores.firstWhereOrNull(
      (s) =>
          s.id ==
          (cartController.cart.isNotEmpty
              ? (cartController.cart.first['item'] as Item).store
              : 0),
    );

    // في حالة ما لقيتش store، ممكن تعرض صفحة فارغة أو رسالة مناسبة
    if (foundStore == null && cartController.cart.isNotEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text('Panier')),
        body: Center(child: Text('Magasin non trouvé')),
      );
    }
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: GestureDetector(
          onTap: () {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => MenuScreen(),
              ),
              (Route<dynamic> route) => false,
            );
          },
          child: Image.asset('images/logo2.png', height: 125, width: 125),
        ),
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            const Background(),
            Column(
              children: [
                SizedBox(height: 30),
                Expanded(
                  child: cartController.cart.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Lottie.asset(
                                'images/empty.json',
                                width: 250,
                                height: 250,
                                fit: BoxFit.contain,
                              ),
                              Text(
                                'Your cart is empty',
                                style: TextStyle(fontSize: 25),
                              ),
                            ],
                          ),
                        )
                      : Column(
                          children: [
                            Expanded(
                              child: ListView.builder(
                                itemCount: cartController.cart.length,
                                itemBuilder: (context, index) {
                                  final item = cartController.cart[index];
                                  final food = item['item'] as Item;
                                  final quantity = item['quantity'] as int;
                                  final suppliments =
                                      item['suppliments'] as List<Suppliment>;

                                  // Calculate the total price
                                  final totalSupplimentsPrice =
                                      suppliments.fold<double>(
                                    0.0,
                                    (sum, suppliment) => sum + suppliment.price,
                                  );
                                  final totalPrice =
                                      (food.price + totalSupplimentsPrice) *
                                          quantity;

                                  return Container(
                                    margin: EdgeInsets.symmetric(
                                      vertical: 5.0,
                                      horizontal: 10.0,
                                    ),
                                    // padding: EdgeInsets.all(10.0),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.grey,
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Row(
                                          children: [
                                            CircleAvatar(
                                              radius: 60,
                                              backgroundImage:
                                                  CachedNetworkImageProvider(
                                                food.fullImageUrl,
                                              ),
                                            ),
                                            SizedBox(width: 15),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  Text(
                                                    food.name,
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  // SizedBox(height: 10),
                                                  // Text(
                                                  //   '${totalPrice.toStringAsFixed(2)} dt',
                                                  //   style: TextStyle(
                                                  //     fontWeight: FontWeight.w600,
                                                  //     fontSize: 16,
                                                  //   ),
                                                  // ),
                                                  Container(
                                                    height: 90,
                                                    child: ListView.builder(
                                                      shrinkWrap: true,
                                                      physics:
                                                          NeverScrollableScrollPhysics(),
                                                      itemCount:
                                                          suppliments.length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        return Text(
                                                          '${suppliments[index].title} - ${suppliments[index].price} dt',
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            color: Colors.grey,
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                Container(
                                                  color: Colors.black,
                                                  width: 1,
                                                  height: 140,
                                                ),
                                                Column(
                                                  children: [
                                                    IconButton(
                                                      icon: Icon(Icons.add),
                                                      onPressed: () {
                                                        cartController
                                                            .increaseQuantity(
                                                          index,
                                                        );
                                                        Get.forceAppUpdate();
                                                      },
                                                    ),
                                                    Container(
                                                      color: Colors.black,
                                                      height: 1,
                                                      width: 50,
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                        vertical: 10,
                                                      ),
                                                      child: Text(
                                                        '$quantity',
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      color: Colors.black,
                                                      height: 1,
                                                      width: 50,
                                                    ),
                                                    quantity == 1
                                                        ? IconButton(
                                                            icon: Icon(
                                                              Icons.delete,
                                                              color: Colors.red,
                                                            ),
                                                            onPressed: () {
                                                              showDialog(
                                                                context:
                                                                    context,
                                                                builder: (
                                                                  BuildContext
                                                                      context,
                                                                ) {
                                                                  return AlertDialog(
                                                                    title: Text(
                                                                      "Remove",
                                                                    ),
                                                                    content:
                                                                        Text(
                                                                      "Are you sure you want to remove this item from the cart?",
                                                                    ),
                                                                    actions: [
                                                                      TextButton(
                                                                        child:
                                                                            Text(
                                                                          "Cancel",
                                                                        ),
                                                                        onPressed:
                                                                            () {
                                                                          Navigator
                                                                              .of(
                                                                            context,
                                                                          ).pop();
                                                                        },
                                                                      ),
                                                                      TextButton(
                                                                        child:
                                                                            Text(
                                                                          "Remove",
                                                                        ),
                                                                        onPressed:
                                                                            () {
                                                                          cartController
                                                                              .removeFromCart(
                                                                            index,
                                                                          );
                                                                          Get.forceAppUpdate();
                                                                          Navigator
                                                                              .of(
                                                                            context,
                                                                          ).pop();
                                                                        },
                                                                      ),
                                                                    ],
                                                                  );
                                                                },
                                                              );
                                                            },
                                                          )
                                                        : IconButton(
                                                            icon: Icon(
                                                              Icons.remove,
                                                            ),
                                                            onPressed: () {
                                                              cartController
                                                                  .decreaseQuantity(
                                                                index,
                                                              );
                                                              Get.forceAppUpdate();
                                                            },
                                                          ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text(
                                          'Total Price:',
                                          style: TextStyle(fontSize: 20),
                                        ),
                                        Text(
                                          '${total.toStringAsFixed(2)} dt',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 12),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Text('Clear Cart'),
                                                  content: Text(
                                                    'Are you sure you want to clear the cart?',
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(
                                                          context,
                                                        ).pop();
                                                      },
                                                      child: Text('Cancel'),
                                                    ),
                                                    TextButton(
                                                      onPressed: () {
                                                        cartController
                                                            .clearCart();
                                                        Get.forceAppUpdate();
                                                        Navigator.of(
                                                          context,
                                                        ).pop();
                                                      },
                                                      child: Text('Yes'),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 20,
                                              vertical: 10,
                                            ),
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [
                                                  Colors.red,
                                                  Colors.orange,
                                                ],
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.clear,
                                                  color: Colors.white,
                                                ),
                                                SizedBox(width: 8),
                                                Text(
                                                  'Clear Cart',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        foundStore!.available
                                            ? GestureDetector(
                                                onTap: () {
                                                  Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          OrderCart(
                                                        total: total,
                                                        senderNameController:
                                                            senderNameController,
                                                        senderMobileController:
                                                            senderEmailController,
                                                        senderAdressController:
                                                            senderAdressController,
                                                      ),
                                                    ),
                                                  );
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: 20,
                                                    vertical: 10,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    gradient: LinearGradient(
                                                      colors: [
                                                        Color.fromARGB(
                                                          255,
                                                          72,
                                                          154,
                                                          112,
                                                        ),
                                                        Colors.greenAccent,
                                                      ],
                                                      begin: Alignment.topLeft,
                                                      end:
                                                          Alignment.bottomRight,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      10,
                                                    ),
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons.send,
                                                        color: Colors.white,
                                                      ),
                                                      SizedBox(width: 8),
                                                      Text(
                                                        'Order',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              )
                                            : Container(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 20,
                                                  vertical: 10,
                                                ),
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                    colors: [
                                                      Color.fromARGB(
                                                        255,
                                                        154,
                                                        72,
                                                        72,
                                                      ),
                                                      const Color.fromARGB(
                                                        255,
                                                        240,
                                                        105,
                                                        105,
                                                      ),
                                                    ],
                                                    begin: Alignment.topLeft,
                                                    end: Alignment.bottomRight,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.store,
                                                      color: Colors.white,
                                                    ),
                                                    SizedBox(width: 8),
                                                    Text(
                                                      'Closed Store',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class OrderCart extends StatefulWidget {
  final double total;
  final TextEditingController? senderNameController;
  final TextEditingController? senderMobileController;
  final TextEditingController? senderAdressController;

  OrderCart({
    Key? key,
    required this.total,
    required this.senderNameController,
    required this.senderMobileController,
    required this.senderAdressController,
  }) : super(key: key);

  @override
  _OrderCartState createState() => _OrderCartState();
}

class _OrderCartState extends State<OrderCart> {
  final CartController cartController = Get.put(CartController());
  final LoginController loginController = Get.put(LoginController());
  final LocationController homeController = Get.put(LocationController());
  final CategoryController categoryController = Get.put(CategoryController());
  final CouponController couponController = Get.put(CouponController());
  final LocationController locationController = Get.put(LocationController());

  final WalletController walletController = Get.put(WalletController());
  final TextEditingController usePointsController = TextEditingController();
  final TextEditingController commentController = TextEditingController();
  bool _isLoading = false;

  double calculateDeliveryCost(double distance) {
    double cost;

    if (distance <= 1) {
      cost = 2;
    } else if (distance <= 2) {
      cost = 2.5;
    } else if (distance <= 3) {
      cost = 3;
    } else if (distance <= 4) {
      cost = 3.5;
    } else {
      cost = 4.0 + (distance - 4) * 0.5;
    }

    return (cost * 2).round() / 2;
  }

  bool isNighttime() {
    DateTime now = DateTime.now();
    int hour = now.hour;
    return hour >= 20 || hour < 6;
  }

  @override
  Widget build(BuildContext context) {
    final WalletController walletController = Get.find<WalletController>();
    final total = cartController.cart.fold<double>(0, (previousValue, item) {
      final food = item['item'] as Item;
      final quantity = item['quantity'] as int;
      final suppliments = item['suppliments'] as List<Suppliment>;

      final totalSupplimentsPrice = suppliments.fold<double>(
        0.0,
        (sum, suppliment) => sum + suppliment.price,
      );
      return previousValue + (food.price + totalSupplimentsPrice) * quantity;
    });

    // var itemId = cartController.cart[0]['item'].id;
    // var foundStore = homeController.findStoreByItemId(
    //   itemId,
    //   categoryController,
    // );
    final item = cartController.cart[0]['item'] as Item;
    final foundStore = categoryController.stores.firstWhere(
      (store) => store.id == item.store,
      orElse: () => Store(
        id: 0,
        name: '',
        category: 0,
        image: '',
        available: false,
        country: '',
        governorate: '',
        latitude: 0.0,
        longitude: 0.0,
        free_delivery: false,
        average_rating: 0,
        firstItemImage: '',
        items: [],
        phoneNumber: '',
        ratings: [],
        favorited_by: [],has_discounted_item: false,
      ),
    );

    // double distance = homeController.calculateDistance(
    //   homeController.currentPosition!.latitude,
    //   homeController.currentPosition!.longitude,
    //   store.latitude,
    //   store.longitude,
    // );

    double distance = 2.5; // fallback default distance

    try {
      if (homeController.currentPosition.value != null &&
          foundStore.latitude != null &&
          foundStore.longitude != null &&
          foundStore.latitude != 0 &&
          foundStore.longitude != 0) {
        distance = homeController.calculateDistance(
          homeController.currentPosition.value!.latitude,
          homeController.currentPosition.value!.longitude,
          foundStore.latitude,
          foundStore.longitude,
        );

        // Check distance sanity
        if (distance.isNaN ||
            distance.isInfinite ||
            distance <= 0 ||
            distance > 50) {
          print("⚠️ Distance invalid (${distance}), fallback to 1.0 km");
          distance = 2.5;
        }
      } else {
        print("⚠️ Missing location data, fallback to 1.0 km");
      }
    } catch (e) {
      print("❌ Error calculating distance: $e");
      distance = 2.5;
    }

    double deliveryCost;

    try {
      if (foundStore.free_delivery == true) {
        deliveryCost = 0.0;
      } else {
        deliveryCost = calculateDeliveryCost(distance);

        if (isNighttime()) {
          deliveryCost += 0.75;
        }

        // Safety cap
        if (deliveryCost > 20 || deliveryCost.isNaN || deliveryCost < 0) {
          print(
            "⚠️ Delivery cost abnormal (${deliveryCost}), fallback to 3.0 dt",
          );
          deliveryCost = 3.0;
        }
      }

      if (cartController.currentStatus != 'Delivery') {
        deliveryCost = 0.0;
      }
    } catch (e) {
      print("❌ Error in delivery cost calculation: $e");
      deliveryCost = 3.0;
    }

    int estimatedTime = ((distance).ceil() * 5) + 10;
    DateTime now = DateTime.now();
    DateTime estimatedArrival = now.add(Duration(minutes: estimatedTime));
    DateTime estimatedArrivalWithBuffer = estimatedArrival.add(
      Duration(minutes: 10),
    );
    DateTime estimatedOnTheSpot = estimatedArrival.subtract(
      Duration(minutes: 10),
    );
    String currentStatus = cartController.currentStatus;
    // double deliveryCost;
    if (foundStore.free_delivery) {
      deliveryCost = 0.0;
    } else {
      deliveryCost = calculateDeliveryCost(distance);
      if (isNighttime() && currentStatus == 'Delivery') {
        double nighttimeSurcharge = 0.75;
        deliveryCost += nighttimeSurcharge;
      }
    }

    if (currentStatus != 'Delivery') {
      deliveryCost = 0.0;
    }
    double totalWithDelivery = total + deliveryCost;
    double totalWithDeliveryRounded =
        double.parse(totalWithDelivery.toStringAsFixed(3));

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cart',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.orange.shade400,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  foundStore.category == 1
                      ? SizedBox(
                          height: 50,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: List.generate(
                              cartController.eatList.length,
                              (index) {
                                String status = cartController.eatList[index];
                                return Padding(
                                  padding: const EdgeInsets.only(right: 10.0),
                                  child: FilterChip(
                                    label: Text(status),
                                    selected:
                                        cartController.currentStatus == status,
                                    onSelected: (selected) {
                                      if (selected) {
                                        setState(() {
                                          cartController.currentStatus = status;
                                        });
                                      }
                                    },
                                    selectedColor: Colors.orange.shade400,
                                    backgroundColor: Colors.grey,
                                    checkmarkColor: Colors.white,
                                  ),
                                );
                              },
                            ),
                          ),
                        )
                      : Container(),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.timer_outlined,
                                  color: Colors.orange.shade400,
                                ),
                                SizedBox(width: 5),
                                Text(
                                  currentStatus == 'Delivery'
                                      ? 'Estimated Arrival:'
                                      : 'Estimated Preparing:',
                                ),
                              ],
                            ),
                            Text(
                              currentStatus == 'Delivery'
                                  ? '${estimatedArrival.hour}:${estimatedArrival.minute.toString().padLeft(2, '0')} - ${estimatedArrivalWithBuffer.hour}:${estimatedArrivalWithBuffer.minute.toString().padLeft(2, '0')}'
                                  : '${estimatedOnTheSpot.hour}:${estimatedOnTheSpot.minute.toString().padLeft(2, '0')} - ${estimatedArrival.hour}:${estimatedArrival.minute.toString().padLeft(2, '0')}',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Invoice',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: cartController.cart.length,
                          itemBuilder: (context, index) {
                            final item = cartController.cart[index];
                            final food = item['item'] as Item;
                            final quantity = item['quantity'] as int;
                            final suppliments =
                                item['suppliments'] as List<Suppliment>;

                            final totalSupplimentsPrice =
                                suppliments.fold<double>(
                              0.0,
                              (sum, suppliment) => sum + suppliment.price,
                            );
                            final subtotal =
                                (food.price + totalSupplimentsPrice) * quantity;

                            return ListTile(
                              title: Text(food.name),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Quantity: $quantity'),
                                  ...suppliments.map((suppliment) {
                                    return Text(
                                      '${suppliment.title} - ${suppliment.price} dt',
                                    );
                                  }).toList(),
                                ],
                              ),
                              trailing: Text(
                                '${subtotal.toStringAsFixed(2)} dt',
                              ),
                            );
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            foundStore.free_delivery == false
                                ? Row(
                                    children: [
                                      Text(
                                        'Delivery Cost:',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(width: 5),
                                      isNighttime()
                                          ? currentStatus == 'Delivery'
                                              ? Text(
                                                  '${(deliveryCost - 0.75).toStringAsFixed(2)} dt',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                )
                                              : Text(
                                                  '${(deliveryCost).toStringAsFixed(2)} dt',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                )
                                          : Text(
                                              '${deliveryCost.toStringAsFixed(2)} dt',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                    ],
                                  )
                                : Text(
                                    'Livraison Gratuite',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.green,
                                    ),
                                  ),
                          ],
                        ),
                        SizedBox(height: 8),
                        isNighttime() &&
                                currentStatus == 'Delivery' &&
                                foundStore.free_delivery == false
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    'frais de nuit:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    '0.75 dt',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              )
                            : Container(),
                        SizedBox(height: 8),
                        Divider(),
                        categoryController.userProfile.value.id != 0
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '** Mobile:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    categoryController
                                        .userProfile.value.username,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              )
                            : Container(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Location:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on_outlined,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 5),
                                homeController.currentPosition != null
                                    ? Text(
                                        '${homeController.locationNameCountry} / ${homeController.locationName} ',
                                        style: TextStyle(fontSize: 16),
                                      )
                                    : Text(
                                        'location...',
                                        style: TextStyle(fontSize: 16),
                                      ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '${totalWithDelivery.toStringAsFixed(2)} dt',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 5),
                  buildCouponAndPointsCard(
                    commentController,
                    usePointsController,
                    walletController,
                    total,
                    couponController,
                    distance,
                    foundStore,
                  ),
                  SizedBox(height: 20),
                  Obx(() {
                    if (loginController.isAuthenticated.value) {
                      return GestureDetector(
                        onTap: () async {
                          if (!categoryController
                              .userProfile.value.isNotBlocked) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Error'),
                                  content: Text(
                                    'You are blocked and cannot place an order. Please contact Spooding Agency to unblock your account.',
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('OK'),
                                    ),
                                  ],
                                );
                              },
                            );
                            return;
                          }

                          final int availablePoints =
                              walletController.wallet.value?.points ?? 0;
                          const int spdPerTnd = 40; // معدل النقاط مقابل 1 دينار
                          final int maxAllowedPoints =
                              ((total * 0.10) * spdPerTnd).floor();

                          // تحدد أقل قيمة بين النقاط المتاحة والحد الأقصى المسموح
                          final int maxUsablePoints =
                              availablePoints < maxAllowedPoints
                                  ? availablePoints
                                  : maxAllowedPoints;

                          final int amount =
                              int.tryParse(usePointsController.text.trim()) ??
                                  0;

                          if (amount > maxUsablePoints) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'يمكنك استخدام حتى $maxUsablePoints نقطة فقط.',
                                ),
                                backgroundColor: Colors.red,
                                duration: Duration(seconds: 3),
                              ),
                            );
                            setState(() {
                              _isLoading = false;
                            });
                            return; // توقف تنفيذ الطلب
                          }

                          setState(() {
                            _isLoading = true;
                          });

                          await loginController.loadToken();

                          if (couponController.percent.value) {
                            if (couponController.discount.value == 0) {
                              totalWithDelivery -= deliveryCost;
                              deliveryCost = 0;
                            }
                            totalWithDelivery =
                                ((totalWithDelivery - deliveryCost) *
                                        (1 -
                                            (couponController.discount.value /
                                                100))) +
                                    deliveryCost;
                          } else {
                            totalWithDelivery = (totalWithDelivery -
                                    deliveryCost -
                                    couponController.discount.value) +
                                deliveryCost;
                          }

                          final order = await cartController.createOrder(
                            '${homeController.locationNameCountry} / ${homeController.locationName}',
                            // totalWithDelivery,
                            totalWithDeliveryRounded,
                            deliveryCost,
                            amount,
                            commentController.text,
                          );
                          couponController.discount.value = 0.0;
                          couponController.couponCode.value = '';
                          couponController.percent.value = false;

                          if (order != null) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Order Placed'),
                                  content: Text(
                                    'Your order has been successfully placed.',
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        cartController.clearCart();
                                        commentController.clear();
                                        cartController.fetchUserOrders();
                                        Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => MenuScreen(),
                                          ),
                                          (Route<dynamic> route) => false,
                                        );
                                      },
                                      child: Text('OK'),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.orange.shade400,
                                Colors.orange.shade300,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.send, color: Colors.white),
                              SizedBox(width: 8),
                              Text(
                                'Order',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    } else {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      // PhoneInputScreenOrder(),
                                      SignUpOrder(),
                                ),
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.orange.shade400,
                                    Colors.orange.shade200,
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.app_registration,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Sign Up',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => LoginOrderScreen(),
                                ),
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.orange.shade400,
                                    Colors.orange.shade200,
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.login, color: Colors.white),
                                  SizedBox(width: 8),
                                  Text(
                                    'Login',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                  }),
                ],
              ),
            ),
          ),
          if (_isLoading) Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }

  String _calculateDiscountedPrice(double distance, Store store) {
    // Function to calculate delivery cost based on distance
    double calculateDeliveryCost(double distance) {
      double cost;
      if (distance <= 1) {
        cost = 2;
      } else if (distance <= 2) {
        cost = 2.5;
      } else if (distance <= 3) {
        cost = 3;
      } else if (distance <= 4) {
        cost = 3.5;
      } else {
        cost = 4.0 + (distance - 4) * 0.5;
      }

      return (cost * 2).round() / 2;
    }

    // Check if it's nighttime (20:00 - 06:00)
    bool isNighttime() {
      DateTime now = DateTime.now();
      int hour = now.hour;
      return hour >= 20 || hour < 6;
    }

    double originalPrice = widget.total;
    double deliveryCost = calculateDeliveryCost(distance);

    // Add nighttime surcharge if applicable
    if (isNighttime()) {
      double nighttimeSurcharge = 0.75;
      deliveryCost += nighttimeSurcharge;
    }

    // If is_percent is true and discount is exactly 0, set delivery cost to 0
    if ((couponController.percent.value &&
            couponController.discount.value == 0) ||
        store.free_delivery) {
      deliveryCost = 0;
    }

    double finalPrice;

    if (couponController.percent.value) {
      finalPrice =
          (originalPrice * (1 - (couponController.discount.value / 100)) +
              deliveryCost);
    } else {
      finalPrice =
          (originalPrice - couponController.discount.value + deliveryCost);
    }

    return "${finalPrice.clamp(0, double.infinity).toStringAsFixed(2)}";
  }

  Widget buildCouponAndPointsCard(
    TextEditingController commentController,
    TextEditingController usePointsController, // تحكم في خانة نقاط الاستخدام
    WalletController walletController, // تحكم في المحفظة (النقاط المتوفرة)
    double totalPrice, // السعر الإجمالي للطلب
    CouponController couponController, // تحكم في الكوبونات
    double distance, // المسافة (للحسابات)
    Store store, // معلومات المتجر
  ) {
    final RxInt selectedSuggestion =
        (-1).obs; // رقم الاقتراح المختار (-1 يعني لا شيء)
    final RxString discountText = ''.obs; // نص عرض الخصم الناتج من النقاط

    // إذا لم يتم تعيين أي قيمة في خانة النقاط، أضف مستمع لتحديث النص تلقائياً
    if (usePointsController.text.isEmpty) {
      usePointsController.addListener(() {
        final input = usePointsController.text.trim();
        final int points = int.tryParse(input) ?? 0;
        if (points > 0) {
          final discount = (points * 0.025).toStringAsFixed(2);
          discountText.value = 'خصم: $discount دينار تونسي';
        } else {
          discountText.value = '';
        }
      });
    }

    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // عرض عدد النقاط المكتسبة من الطلب الحالي
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.orange.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.orange.shade300),
            ),
            child: Text(
              'عند إكمال هذا الطلب، ستحصل على ${totalPrice.toInt()} نقاط!',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.orange.shade800,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          SizedBox(height: 20),

          // قسم استخدام النقاط مع الاقتراحات وحقل الإدخال
          Obx(() {
            final int availablePoints =
                walletController.wallet.value?.points ?? 0;

            const int spdPerTnd = 40; // معدل النقاط مقابل 1 دينار
            const int minPointStep = 20; // أقل خطوة للنقاط
            const int maxSuggestions = 3; // عدد الاقتراحات

            // أقصى نقاط يمكن استخدامها (10% من السعر مضروبة في معدل النقاط)
            final int maxUsablePoints = (totalPrice * 0.10 * spdPerTnd).floor();

            final int suggestionCap = availablePoints >= maxUsablePoints
                ? maxUsablePoints
                : availablePoints;

            List<Map<String, dynamic>> suggestions = [];

            // اقتراحات نقاط مختلفة يمكن استخدامها
            for (int i = maxSuggestions; i >= 1; i--) {
              final int stepPoints = i * minPointStep;
              if (stepPoints <= suggestionCap) {
                final double discount = (stepPoints / spdPerTnd);
                suggestions.add({
                  'label':
                      'استخدم $stepPoints نقطة مقابل خصم ${discount.toStringAsFixed(2)} دينار',
                  'points': stepPoints,
                });
              }
            }

            if (suggestions.isEmpty && availablePoints > 0) {
              final double discount = (suggestionCap / spdPerTnd);
              suggestions.add({
                'label':
                    'استخدم $suggestionCap نقطة مقابل خصم ${discount.toStringAsFixed(2)} دينار',
                'points': suggestionCap,
              });
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (suggestions.isNotEmpty) ...[
                  Text(
                    'استخدم نقاطك',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.orange.shade800,
                    ),
                  ),
                  SizedBox(height: 8),
                  ...List.generate(suggestions.length, (index) {
                    final suggestion = suggestions[index];
                    return Obx(
                      () => CheckboxListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(suggestion['label']),
                        activeColor: Colors.orange,
                        value: selectedSuggestion.value == index,
                        onChanged: (_) {
                          selectedSuggestion.value =
                              selectedSuggestion.value == index ? -1 : index;
                          usePointsController.text =
                              selectedSuggestion.value == -1
                                  ? ''
                                  : suggestion['points'].toString();
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                    );
                  }),
                  SizedBox(height: 10),
                ],
                // حقل إدخال النقاط يدوياً
                TextField(
                  controller: usePointsController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'النقاط التي تريد استخدامها',
                    prefixIcon: Icon(
                      Icons.remove_circle_outline,
                      color: Colors.orange,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.orange),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                Obx(
                  () => discountText.value.isEmpty
                      ? SizedBox.shrink()
                      : Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            discountText.value,
                            style: TextStyle(
                              color: Colors.green.shade700,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                ),
              ],
            );
          }),

          Divider(height: 32, thickness: 1, color: Colors.grey.shade300),

          // قسم إدخال الكوبون الترويجي
          Text(
            "رمز الخصم (Coupon)",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  onChanged: (value) =>
                      couponController.couponCode.value = value,
                  decoration: InputDecoration(
                    hintText: "أدخل رمز الخصم",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    prefixIcon: Icon(Icons.discount, color: Colors.orange),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.orange),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 14),
              ElevatedButton(
                onPressed: () async {
                  await couponController.applyCoupon();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                ),
                child: Text(
                  "Apply",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),

          // عرض نتيجة تطبيق الكوبون
          Obx(() {
            if (couponController.percent.value &&
                couponController.discount.value == 0) {
              return Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "تم تطبيق توصيل مجاني",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade700,
                      ),
                    ),
                    Icon(Icons.directions_bike_outlined, color: Colors.blue),
                  ],
                ),
              );
            } else if (couponController.discount.value > 0) {
              return Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "تم تطبيق خصم: ${couponController.discount.value}${couponController.percent.value ? '%' : ' دينار'}",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade700,
                      ),
                    ),
                    Icon(Icons.check_circle, color: Colors.green),
                  ],
                ),
              );
            } else {
              return SizedBox.shrink();
            }
          }),

          Divider(),
          TextField(
            controller: commentController,
            maxLength: 100,
            decoration: InputDecoration(
              hintText:
                  'zid commentaire \nEx : bzayed mayonaise , frite 3la jnab ...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.orange.shade400),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.orange.shade400),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.orange.shade400, width: 2),
              ),

              // counterText: '',
            ),
            textInputAction: TextInputAction.done,
            keyboardType: TextInputType.text,
            maxLines: 3,
          ),
        ],
      ),
    );
  }
}
