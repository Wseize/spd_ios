// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, use_build_context_synchronously, no_leading_underscores_for_local_identifiers, unused_field

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:spooding_exp_ios/20/express.dart';
import 'package:spooding_exp_ios/20/test/testController.dart';
import 'package:spooding_exp_ios/20/view/loginScreen.dart';
import 'package:spooding_exp_ios/controller.dart';
import 'package:spooding_exp_ios/model.dart';

class OrderTrackingPage extends StatefulWidget {
  final Order order;

  const OrderTrackingPage({Key? key, required this.order}) : super(key: key);

  @override
  _OrderTrackingPageState createState() => _OrderTrackingPageState();
}

class _OrderTrackingPageState extends State<OrderTrackingPage>
    with SingleTickerProviderStateMixin {
  final LocationController homeController = Get.put(LocationController());
  final CartController orderController = Get.put(CartController());
  final CategoryController categoryController = Get.put(CategoryController());
  bool isLoading = false;
  late AnimationController _animationController;
  late Animation<double> _animation;
  Timer? _countdownTimer;
  bool _timeUp = false;
  Duration _timeLeft = Duration(hours: 24);

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController.reset();
      }
    });
    fetchOrderStatus();
    _startCountdown();
  }

  void fetchOrderStatus() {
    setState(() {
      isLoading = true;
    });
    orderController.fetchOrderStatus(widget.order.id).then((_) {
      setState(() {
        isLoading = false;
      });
      if (orderController.order.value.status == 'complete') {
        _animationController.forward();
      }
    }).catchError((error) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching order status: $error');
    });
  }

  void _startCountdown() {
    DateTime orderCreationTime = widget.order.createdAt;
    DateTime endTime = orderCreationTime.add(Duration(hours: 24));
    Duration initialTimeLeft = endTime.difference(DateTime.now());

    if (initialTimeLeft.isNegative) {
      // If the countdown has already ended
      _timeLeft = Duration.zero;
      setState(() {
        _timeUp = true;
      });
    } else {
      _timeLeft = initialTimeLeft;
      _countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
        setState(() {
          if (_timeLeft.inSeconds > 0) {
            _timeLeft = _timeLeft - Duration(seconds: 1);
          } else {
            _countdownTimer?.cancel();
            _timeLeft = Duration.zero;
            _timeUp = true;
          }
        });
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _countdownTimer?.cancel();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String hours = twoDigits(duration.inHours);
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$hours:$minutes:$seconds";
  }

  // Store? findStoreById(int storeId) {
  //   return categoryController.stores.firstWhere((store) => store.id == storeId);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Image.asset('images/logo2.png', height: 125, width: 125),
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Obx(() {
                            if (orderController.isLoading.value) {
                              return Center(child: CircularProgressIndicator());
                            } else if (orderController.order.value.id != 0) {
                              var foundStore = homeController.findStoreByItemId(
                                widget.order.items[0].id,
                                categoryController,
                              );
                              return Column(
                                children: [
                                  if (orderController.order.value.status ==
                                          'Complete' &&
                                      foundStore.category == 2)
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          if (_timeLeft != Duration.zero)
                                            Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      'You can change your order before:',
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                    SizedBox(width: 10),
                                                    Text(
                                                      _formatDuration(
                                                        _timeLeft,
                                                      ),
                                                      style: TextStyle(
                                                        color: Colors.red,
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      'if you wanna change:',
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {
                                                        showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return AlertDialog(
                                                              title: Text(
                                                                'Change Order',
                                                              ),
                                                              content: Text(
                                                                'Do you want to change your order?',
                                                              ),
                                                              actions: [
                                                                TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator
                                                                        .of(
                                                                      context,
                                                                    ).pop();
                                                                  },
                                                                  child: Text(
                                                                    'Cancel',
                                                                  ),
                                                                ),
                                                                TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    var foundStore =
                                                                        LocationController()
                                                                            .findStoreByItemId(
                                                                      widget
                                                                          .order
                                                                          .items[
                                                                              0]
                                                                          .id,
                                                                      categoryController,
                                                                    );
                                                                    Navigator
                                                                        .of(
                                                                      context,
                                                                    ).pop();

                                                                    // Navigator.of(
                                                                    //         context)
                                                                    //     .push(
                                                                    //   MaterialPageRoute(
                                                                    //       builder: (context) =>
                                                                    //           StoreReturnScreen(
                                                                    //             store: store,
                                                                    //             totalReturned: double.parse(widget.order.total_price),
                                                                    //             orderId: widget.order.id,
                                                                    //           )),
                                                                    // );
                                                                    orderController
                                                                        .fetchOrderStatus(
                                                                      orderController
                                                                          .order
                                                                          .value
                                                                          .id,
                                                                    );
                                                                  },
                                                                  child: Text(
                                                                    'Yes',
                                                                  ),
                                                                ),
                                                              ],
                                                            );
                                                          },
                                                        );
                                                      },
                                                      child: Text(
                                                        ' Click here',
                                                        style: TextStyle(
                                                          color: Colors.green,
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          if (_timeLeft == Duration.zero)
                                            Container(),
                                        ],
                                      ),
                                    ),
                                  Stack(
                                    children: [
                                      _buildOrderDetails(widget.order),
                                      orderController.order.value.status ==
                                              'Cancelled'
                                          ? Positioned(
                                              right: 50,
                                              top: 80,
                                              child: Transform.rotate(
                                                angle: 0.8,
                                                child: Text(
                                                  'Cancelled',
                                                  style: TextStyle(
                                                    color: Colors.red,
                                                    fontSize: 50,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            )
                                          : orderController
                                                      .order.value.status ==
                                                  'Returned'
                                              ? Positioned(
                                                  right: 50,
                                                  top: 80,
                                                  child: Transform.rotate(
                                                    angle: 0.8,
                                                    child: Text(
                                                      'Returned',
                                                      style: TextStyle(
                                                        color: Colors.blue,
                                                        fontSize: 50,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : Container(),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  _buildStatusCards(
                                    orderController.order.value.status,
                                  ),
                                ],
                              );
                            } else {
                              return SizedBox.shrink();
                            }
                          }),
                        ],
                      ),
                    ),
                    if (orderController.order.value.status == 'complete')
                      Center(
                        child: ScaleTransition(
                          scale: _animation,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Column(
                              children: [
                                SizedBox(height: 20),
                                Text(
                                  'Congratulations !!',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 30,
                                  ),
                                ),
                                Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                  size: 300,
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
      ),
    );
  }

  Widget _buildStatusCards(String currentStatus) {
    bool isCancelled = currentStatus == 'Cancelled';

    return Column(
      children: [
        _buildStatusCard(
          title: 'Received',
          description: 'Your order has been received and is being processed.',
          icon: Icons.assignment_turned_in,
          isActive: currentStatus == 'Received',
          color: isCancelled ? Colors.grey : Colors.green,
        ),
        _buildStatusCard(
          title: 'In Progress',
          description: 'Your order is currently in progress.',
          icon: Icons.access_time,
          isActive: currentStatus == 'In Progress',
          color: isCancelled
              ? Colors.grey
              : currentStatus == 'Received'
                  ? Colors.grey
                  : Colors.green,
        ),
        _buildStatusCard(
          title: 'In Transit',
          description: 'Your order is on its way to you.',
          icon: Icons.local_shipping,
          isActive: currentStatus == 'In Transit',
          color: isCancelled
              ? Colors.grey
              : currentStatus == 'In Progress' || currentStatus == 'Received'
                  ? Colors.grey
                  : Colors.green,
        ),
        _buildStatusCard(
          title: 'Complete',
          description: 'Your order has been completed successfully.',
          icon: Icons.check_circle,
          isActive: currentStatus == 'Complete',
          color: isCancelled
              ? Colors.grey
              : currentStatus == 'In Transit' ||
                      currentStatus == 'In Progress' ||
                      currentStatus == 'Received'
                  ? Colors.grey
                  : Colors.green,
        ),
      ],
    );
  }

  Widget _buildOrderDetails(Order order) {
    var foundStore = homeController.findStoreByItemId(
      order.items[0].id,
      categoryController,
    );
    return Container(
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Details',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
          ),
          SizedBox(height: 10),
          Column(
            children: order.items.map((item) {
              return ListTile(
                title: Text(item.itemName),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.storeName),
                    Text('Quantity: ${item.quantity}'),
                    Row(
                      children: [
                        Text(
                          foundStore.category == 1
                              ? 'Suppliments: '
                              : 'details: ',
                        ),
                        Flexible(
                          child: Wrap(
                            children: item.suppliments.map((suppliment) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Text(suppliment),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Location:', style: TextStyle(fontWeight: FontWeight.bold)),
              Row(
                children: [
                  const Icon(Icons.location_on_outlined, color: Colors.white),
                  const SizedBox(width: 5),
                  Text(order.location, style: TextStyle(fontSize: 16)),
                ],
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(
                '${order.total_price} dt',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard({
    required String title,
    required String description,
    required IconData icon,
    required bool isActive,
    required Color color,
  }) {
    return Card(
      color: color,
      elevation: isActive ? 4 : 0,
      margin: EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: Icon(icon, color: Colors.white),
        title: Text(
          title,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(description, style: TextStyle(color: Colors.white)),
      ),
    );
  }
}

class OrderScreen extends StatelessWidget {
  final CartController cartController = Get.put(CartController());
  final LoginController loginController = Get.put(LoginController());
  OrderScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    cartController.fetchUserOrders();
    return Scaffold(
      // appBar: AppBar(
      //   centerTitle: false,
      //   title: GestureDetector(
      //     onTap: () {
      //       Navigator.of(context).pushAndRemoveUntil(
      //         MaterialPageRoute(builder: (context) => HomeUpdate()),
      //         (Route<dynamic> route) => false,
      //       );
      //     },
      //     child: Image.asset(
      //       'images/logo2.png',
      //       height: 125,
      //       width: 125,
      //     ),
      //   ),
      //   backgroundColor: Colors.white,
      // ),
      body: RefreshIndicator(
        onRefresh: () => cartController.fetchUserOrders(),
        child: loginController.isAuthenticated.value
            ? Obx(() {
                if (cartController.isLoading.value) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: Colors.orange.shade400,
                    ),
                  );
                }
                final sortedOrders = List.from(cartController.orders);
                sortedOrders.sort((a, b) => b.createdAt.compareTo(a.createdAt));

                if (sortedOrders.isEmpty) {
                  return Center(child: Text('There is no order yet'));
                } else {
                  return ListView.builder(
                    itemCount: sortedOrders.length,
                    itemBuilder: (context, index) {
                      Order order = sortedOrders[index];
                      int displayIndex = sortedOrders.length - index;
                      return Card(
                        elevation: 2,
                        margin: EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 16,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Align(
                                alignment: Alignment.topRight,
                                child: Text(
                                  DateFormat(
                                    'HH:mm / dd-MM-yyyy ',
                                  ).format(order.createdAt),
                                ),
                              ),
                              SizedBox(height: 15),
                              order.order_id_returned != 0
                                  ? Text(
                                      'Returned',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: Colors.red,
                                      ),
                                    )
                                  : Container(),
                              SizedBox(height: 5),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Order ${displayIndex == 1 ? 1 : displayIndex}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  Text(
                                    order.status == 'Complete'
                                        ? 'Complete'
                                        : order.status == 'Cancelled'
                                            ? 'Cancelled'
                                            : order.status == 'Returned'
                                                ? 'Returned'
                                                : 'Pending',
                                    style: TextStyle(
                                      color: order.status == 'Complete'
                                          ? Colors.green
                                          : order.status == 'Cancelled'
                                              ? Colors.red
                                              : order.status == 'Returned'
                                                  ? Colors.blue
                                                  : Colors.orange.shade400,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: order.items.map((item) {
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 4.0),
                                    child: Text(
                                      '${item.quantity} ${item.itemName} from ${item.storeName}',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  );
                                }).toList(),
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Total: ${order.total_price} DT',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: 10),
                              Divider(),
                              SizedBox(height: 10),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          OrderTrackingPage(order: order),
                                    ),
                                  );
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Icon(Icons.arrow_forward),
                                    Text(
                                      'View Details',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              })
            : LoginScreen(),
      ),
    );
  }
}

class OrderCourierScreen extends StatelessWidget {
  final CartController cartController = Get.put(CartController());
  final LoginController loginController = Get.put(LoginController());
  OrderCourierScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    cartController.fetchUserOrdersCourier();
    return Scaffold(
      // appBar: AppBar(
      //   centerTitle: false,
      //   title: GestureDetector(
      //     onTap: () {
      //       Navigator.of(context).pushAndRemoveUntil(
      //         MaterialPageRoute(builder: (context) => HomeUpdate()),
      //         (Route<dynamic> route) => false,
      //       );
      //     },
      //     child: Image.asset(
      //       'images/logo2.png',
      //       height: 125,
      //       width: 125,
      //     ),
      //   ),
      //   backgroundColor: Colors.white,
      // ),
      body: RefreshIndicator(
        onRefresh: () => cartController.fetchUserOrdersCourier(),
        child: loginController.isAuthenticated.value
            ? Obx(() {
                if (cartController.isLoading.value) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: Colors.orange.shade400,
                    ),
                  );
                }
                final sortedOrders = List.from(cartController.ordersCourier);
                sortedOrders.sort((a, b) => b.createdAt.compareTo(a.createdAt));

                if (sortedOrders.isEmpty) {
                  return Center(child: Text('There is no order yet'));
                } else {
                  return ListView.builder(
                    itemCount: sortedOrders.length,
                    itemBuilder: (context, index) {
                      OrderCourier order = sortedOrders[index];
                      int displayIndex = sortedOrders.length - index;
                      return Card(
                        elevation: 2,
                        margin: EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 16,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Align(
                                alignment: Alignment.topRight,
                                child: Text(
                                  DateFormat(
                                    'HH:mm / dd-MM-yyyy ',
                                  ).format(order.createdAt),
                                ),
                              ),
                              SizedBox(height: 20),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Order ${displayIndex == 1 ? 1 : displayIndex}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  Text(
                                    order.status == 'Complete'
                                        ? 'Complete'
                                        : order.status == 'Cancelled'
                                            ? 'Cancelled'
                                            : order.status == 'Returned'
                                                ? 'Returned'
                                                : 'Pending',
                                    style: TextStyle(
                                      color: order.status == 'Complete'
                                          ? Colors.green
                                          : order.status == 'Cancelled'
                                              ? Colors.red
                                              : order.status == 'Returned'
                                                  ? Colors.blue
                                                  : Colors.orange.shade400,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Object: ${order.objectSent}',
                                style: TextStyle(fontSize: 16),
                              ),

                              Row(
                                children: [
                                  Text(
                                    'Delivery Time: ',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  Text(
                                    DateFormat(
                                      'HH:mm / dd-MM-yyyy ',
                                    ).format(order.deliveryTime),
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Total: ${order.price} DT',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: 10),
                              ExpansionTile(
                                title: Text(
                                  'Locations',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                children: [
                                  Text(
                                    'From: ${order.pickupAddress}',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  Text(
                                    'To: ${order.deliveryAddress}',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),

                              // Divider(),
                              // SizedBox(height: 10),
                              // GestureDetector(
                              //   onTap: () {
                              //     Navigator.push(
                              //       context,
                              //       MaterialPageRoute(
                              //         builder: (context) =>
                              //             OrderCourierTrackingPage(
                              //           order: order,
                              //         ),
                              //       ),
                              //     );
                              //   },
                              //   child: Row(
                              //     mainAxisAlignment: MainAxisAlignment.end,
                              //     children: [
                              //       Icon(Icons.arrow_forward),
                              //       Text(
                              //         'View Details',
                              //         style: TextStyle(
                              //           fontSize: 16,
                              //           fontWeight: FontWeight.bold,
                              //         ),
                              //       ),
                              //     ],
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              })
            : LoginScreen(),
      ),
    );
  }
}

class OrderTabScreen extends StatelessWidget {
  final LocationController locationController = Get.put(LocationController());
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
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
          bottom: TabBar(
            tabs: [
              Tab(text: 'Orders'),
              Tab(text: 'Courier Orders'),
            ],
          ),
          backgroundColor: Colors.white,
        ),
        body: TabBarView(children: [OrderScreen(), OrderCourierScreen()]),
      ),
    );
  }
}

// class OrderCourierTrackingPage extends StatefulWidget {
//   final OrderCourier order;

//   const OrderCourierTrackingPage({
//     Key? key,
//     required this.order,
//   }) : super(key: key);

//   @override
//   _OrderCourierTrackingPageState createState() =>
//       _OrderCourierTrackingPageState();
// }

// class _OrderCourierTrackingPageState extends State<OrderCourierTrackingPage>
//     with SingleTickerProviderStateMixin {
//   final HomeController homeController = Get.put(HomeController());
//   final CartController orderController = Get.put(CartController());
//   final CategoryController categoryController = Get.put(CategoryController());
//   bool isLoading = false;
//   late AnimationController _animationController;
//   late Animation<double> _animation;
//   Timer? _countdownTimer;
//   bool _timeUp = false;
//   Duration _timeLeft = Duration(hours: 24);

//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       vsync: this,
//       duration: Duration(seconds: 2),
//     );
//     _animation = CurvedAnimation(
//       parent: _animationController,
//       curve: Curves.easeInOut,
//     );
//     _animationController.addStatusListener((status) {
//       if (status == AnimationStatus.completed) {
//         _animationController.reset();
//       }
//     });
//     fetchOrderStatus();
//     _startCountdown();
//   }

//   void fetchOrderStatus() {
//     setState(() {
//       isLoading = true;
//     });
//     orderController.fetchOrderStatus(widget.order.id).then((_) {
//       setState(() {
//         isLoading = false;
//       });
//       if (orderController.order.value.status == 'complete') {
//         _animationController.forward();
//       }
//     }).catchError((error) {
//       setState(() {
//         isLoading = false;
//       });
//       print('Error fetching order status: $error');
//     });
//   }

//   void _startCountdown() {
//     DateTime orderCreationTime = widget.order.createdAt;
//     DateTime endTime = orderCreationTime.add(Duration(hours: 24));
//     Duration initialTimeLeft = endTime.difference(DateTime.now());

//     if (initialTimeLeft.isNegative) {
//       // If the countdown has already ended
//       _timeLeft = Duration.zero;
//       setState(() {
//         _timeUp = true;
//       });
//     } else {
//       _timeLeft = initialTimeLeft;
//       _countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
//         setState(() {
//           if (_timeLeft.inSeconds > 0) {
//             _timeLeft = _timeLeft - Duration(seconds: 1);
//           } else {
//             _countdownTimer?.cancel();
//             _timeLeft = Duration.zero;
//             _timeUp = true;
//           }
//         });
//       });
//     }
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     _countdownTimer?.cancel();
//     super.dispose();
//   }

//   String _formatDuration(Duration duration) {
//     String twoDigits(int n) => n.toString().padLeft(2, '0');
//     String hours = twoDigits(duration.inHours);
//     String minutes = twoDigits(duration.inMinutes.remainder(60));
//     String seconds = twoDigits(duration.inSeconds.remainder(60));
//     return "$hours:$minutes:$seconds";
//   }

//   // Store? findStoreById(int storeId) {
//   //   return categoryController.stores.firstWhere((store) => store.id == storeId);
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: false,
//         title: Image.asset(
//           'images/logo2.png',
//           height: 125,
//           width: 125,
//         ),
//         backgroundColor: Colors.white,
//       ),
//       body: SafeArea(
//         child: Column(
//           children: [
//             SizedBox(height: 20),
//             Expanded(
//               child: SingleChildScrollView(
//                 child: Stack(
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.all(10),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           Obx(() {
//                             if (orderController.isLoading.value) {
//                               return Center(child: CircularProgressIndicator());
//                             } else if (orderController.orderCourier.value.id !=
//                                 0) {
//                               return Column(
//                                 children: [
//                                   Stack(
//                                     children: [
//                                       _buildOrderDetails(widget.order),
//                                       orderController.order.value.status ==
//                                               'Cancelled'
//                                           ? Positioned(
//                                               right: 50,
//                                               top: 80,
//                                               child: Transform.rotate(
//                                                 angle: 0.8,
//                                                 child: Text(
//                                                   'Cancelled',
//                                                   style: TextStyle(
//                                                       color: Colors.red,
//                                                       fontSize: 50,
//                                                       fontWeight:
//                                                           FontWeight.bold),
//                                                 ),
//                                               ),
//                                             )
//                                           : orderController
//                                                       .order.value.status ==
//                                                   'Returned'
//                                               ? Positioned(
//                                                   right: 50,
//                                                   top: 80,
//                                                   child: Transform.rotate(
//                                                     angle: 0.8,
//                                                     child: Text(
//                                                       'Returned',
//                                                       style: TextStyle(
//                                                           color: Colors.blue,
//                                                           fontSize: 50,
//                                                           fontWeight:
//                                                               FontWeight.bold),
//                                                     ),
//                                                   ),
//                                                 )
//                                               : Container()
//                                     ],
//                                   ),
//                                   SizedBox(
//                                     height: 10,
//                                   ),
//                                   _buildStatusCards(
//                                       orderController.order.value.status),
//                                 ],
//                               );
//                             } else {
//                               return SizedBox.shrink();
//                             }
//                           }),
//                         ],
//                       ),
//                     ),
//                     // if (orderController.order.value.status == 'complete')
//                     //   Center(
//                     //     child: ScaleTransition(
//                     //       scale: _animation,
//                     //       child: Container(
//                     //         decoration: BoxDecoration(
//                     //           color: Colors.grey.shade200,
//                     //           borderRadius: BorderRadius.circular(30),
//                     //         ),
//                     //         child: Column(
//                     //           children: [
//                     //             SizedBox(height: 20),
//                     //             Text(
//                     //               'Congratulations !!',
//                     //               style: TextStyle(
//                     //                 fontWeight: FontWeight.bold,
//                     //                 fontSize: 30,
//                     //               ),
//                     //             ),
//                     //             Icon(Icons.check_circle,
//                     //                 color: Colors.green, size: 300),
//                     //           ],
//                     //         ),
//                     //       ),
//                     //     ),
//                     //   ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildStatusCards(String currentStatus) {
//     bool isCancelled = currentStatus == 'Cancelled';

//     return Column(
//       children: [
//         _buildStatusCard(
//           title: 'Received',
//           description: 'Your order has been received and is being processed.',
//           icon: Icons.assignment_turned_in,
//           isActive: currentStatus == 'Received',
//           color: isCancelled ? Colors.grey : Colors.green,
//         ),
//         _buildStatusCard(
//           title: 'In Progress',
//           description: 'Your order is currently in progress.',
//           icon: Icons.access_time,
//           isActive: currentStatus == 'In Progress',
//           color: isCancelled
//               ? Colors.grey
//               : currentStatus == 'Received'
//                   ? Colors.grey
//                   : Colors.green,
//         ),
//         _buildStatusCard(
//           title: 'In Transit',
//           description: 'Your order is on its way to you.',
//           icon: Icons.local_shipping,
//           isActive: currentStatus == 'In Transit',
//           color: isCancelled
//               ? Colors.grey
//               : currentStatus == 'Confirmed' || currentStatus == 'Received'
//                   ? Colors.grey
//                   : Colors.green,
//         ),
//         _buildStatusCard(
//           title: 'Complete',
//           description: 'Your order has been completed successfully.',
//           icon: Icons.check_circle,
//           isActive: currentStatus == 'Complete',
//           color: isCancelled
//               ? Colors.grey
//               : currentStatus == 'In Transit' ||
//                       currentStatus == 'Confirmed' ||
//                       currentStatus == 'Received'
//                   ? Colors.grey
//                   : Colors.green,
//         ),
//       ],
//     );
//   }

//   Widget _buildOrderDetails(OrderCourier order) {
//     return Container(
//       padding: EdgeInsets.all(8.0),
//       decoration: BoxDecoration(
//         border: Border.all(color: Colors.grey),
//         borderRadius: BorderRadius.circular(8.0),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Order Details',
//             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
//           ),
//           SizedBox(height: 10),
//           Divider(),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text('Location:', style: TextStyle(fontWeight: FontWeight.bold)),
//               Row(
//                 children: [
//                   const Icon(
//                     Icons.location_on_outlined,
//                     color: Colors.white,
//                   ),
//                   const SizedBox(width: 5),
//                   Text(order.deliveryAddress, style: TextStyle(fontSize: 16))
//                 ],
//               ),
//             ],
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 'Total:',
//                 style: TextStyle(fontWeight: FontWeight.bold),
//               ),
//               Text(
//                 '${order.price} dt',
//                 style: TextStyle(fontWeight: FontWeight.bold),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildStatusCard({
//     required String title,
//     required String description,
//     required IconData icon,
//     required bool isActive,
//     required Color color,
//   }) {
//     return Card(
//       color: color,
//       elevation: isActive ? 4 : 0,
//       margin: EdgeInsets.symmetric(vertical: 4),
//       child: ListTile(
//         leading: Icon(icon, color: Colors.white),
//         title: Text(
//           title,
//           style: TextStyle(
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         subtitle: Text(description, style: TextStyle(color: Colors.white)),
//       ),
//     );
//   }
// }
