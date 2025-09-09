import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'package:spooding_exp_ios/20/express.dart';
import 'package:spooding_exp_ios/20/test/testController.dart';
import 'package:spooding_exp_ios/20/view/loginScreen.dart';
import 'package:spooding_exp_ios/20/view/signUpScreen.dart';
import 'package:spooding_exp_ios/controller.dart';

class CoursierOrderScreen extends StatefulWidget {
  @override
  _CoursierOrderScreenState createState() => _CoursierOrderScreenState();
}

class _CoursierOrderScreenState extends State<CoursierOrderScreen> {
  final _formKey = GlobalKey<FormState>();
  final LoginController loginController = Get.put(LoginController());
  final CartController cartController = Get.put(CartController());
  final CategoryController categoryController = Get.put(CategoryController());
  final LocationController locationController = Get.put(LocationController());
  bool _isLoading = false;
  LatLng? _pickedLocation;
  MapController _mapController = MapController();
  LatLng? pickupLocation;
  LatLng? dropOffLocation;
  bool _loadingCurrentLocation = true;
  String pickupAddress = '16'.tr;
  String dropOffAddress = '20'.tr;
  String _deliveryTime = "22".tr;
  DateTime? _selectedDeliveryDateTime;
  final TextEditingController _receivedNumberController =
      TextEditingController();
  final TextEditingController _objectController = TextEditingController();
  final TextEditingController _pickUpExactController = TextEditingController();
  final TextEditingController _dropOffExactController = TextEditingController();
  final double _estimatedDeliveryCost = 3.250;
  double _serviceCost = 0.0;

  @override
  void initState() {
    super.initState();
    _getCurrentPosition();
    _calculateServiceCost();
  }

  void _calculateServiceCost() {
    final now = DateTime.now();
    final currentHour = now.hour;

    if (currentHour >= 20 || currentHour < 6) {
      // Between 20:00 (8 PM) and 06:00 (6 AM)
      setState(() {
        _serviceCost = 0.75;
      });
    } else {
      // Between 06:00 (6 AM) and 20:00 (8 PM)
      setState(() {
        _serviceCost = 0.0;
      });
    }
  }

  Future<void> _getCurrentPosition() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      await Geolocator.requestPermission();
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _pickedLocation = LatLng(position.latitude, position.longitude);
        _loadingCurrentLocation = false;
        _mapController.move(_pickedLocation!, 13.0);
      });
    } catch (e) {
      setState(() {
        _pickedLocation = LatLng(35.167494, 8.833903);
        _loadingCurrentLocation = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Create Coursier Order',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.orange.shade400,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: '13'.tr,
                          border: OutlineInputBorder(),
                          hintText: '14'.tr,
                        ),
                        maxLines: 3, // Allow up to 3 lines of text
                        controller: _objectController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'This field is required';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 120,
                        width: MediaQuery.of(context).size.width,
                        child: _pickedLocation == null
                            ? Center(
                                child: CircularProgressIndicator(),
                              ) // Show a loader while location is being fetched
                            : FlutterMap(
                                mapController: _mapController,
                                options: MapOptions(
                                  initialCenter: _pickedLocation!,
                                  initialZoom: 13.0,
                                  interactionOptions: InteractionOptions(
                                    flags: InteractiveFlag.none,
                                  ),
                                ),
                                children: [
                                  TileLayer(
                                    urlTemplate:
                                        "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                                  ),
                                ],
                              ),
                      ),
                    ),
                    // Pickup location picker
                    GestureDetector(
                      onTap: () async {
                        LatLng? result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LocationPickerMap(),
                          ),
                        );
                        if (result != null) {
                          setState(() {
                            pickupLocation = result;
                          });
                          // Get the address from the picked location
                          await _getAddressFromCoordinates(
                            result,
                            isPickup: true,
                          );
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 15,
                          horizontal: 20,
                        ),
                        margin: EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: LinearGradient(
                            colors: [Colors.orangeAccent, Colors.deepOrange],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '15'.tr,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Icon(Icons.location_on, color: Colors.white),
                          ],
                        ),
                      ),
                    ),
                    // Display selected pickup address
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        pickupLocation != null ? '$pickupAddress' : '16'.tr,
                        style: TextStyle(fontSize: 16, color: Colors.black54),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: '17'.tr,
                          border: OutlineInputBorder(),
                          hintText: '18'.tr,
                        ),
                        controller: _pickUpExactController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'This field is required';
                          }
                          return null;
                        },
                      ),
                    ),
                    // Drop-off location picker
                    GestureDetector(
                      onTap: () async {
                        LatLng? result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LocationPickerMap(),
                          ),
                        );
                        if (result != null) {
                          setState(() {
                            dropOffLocation = result;
                          });
                          // Get the address from the picked location
                          await _getAddressFromCoordinates(
                            result,
                            isPickup: false,
                          );
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 15,
                          horizontal: 20,
                        ),
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: const LinearGradient(
                            colors: [Colors.blueAccent, Colors.lightBlue],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '19'.tr,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Icon(Icons.map, color: Colors.white),
                          ],
                        ),
                      ),
                    ),

                    // SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        dropOffAddress != null ? '$dropOffAddress' : '20'.tr,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: '20'.tr,
                          border: OutlineInputBorder(),
                          hintText: '21'.tr,
                        ),
                        controller: _dropOffExactController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'This field is required';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _deliveryTime = '22'.tr;
                            });
                          },
                          child: Container(
                            height: 80,
                            width: MediaQuery.of(context).size.width / 2.3,
                            padding: const EdgeInsets.symmetric(
                              vertical: 15,
                              horizontal: 20,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              gradient: const LinearGradient(
                                colors: [Colors.greenAccent, Colors.green],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 5,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                '22'.tr,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            // Show date picker
                            DateTime? selectedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2101),
                            );
                            if (selectedDate != null) {
                              // Show time picker if date is selected
                              TimeOfDay? selectedTime = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              );
                              if (selectedTime != null) {
                                // Combine selected date and time
                                final dateTime = DateTime(
                                  selectedDate.year,
                                  selectedDate.month,
                                  selectedDate.day,
                                  selectedTime.hour,
                                  selectedTime.minute,
                                );
                                setState(() {
                                  _selectedDeliveryDateTime =
                                      dateTime; // Store the selected date and time
                                  _deliveryTime =
                                      "Scheduled for: ${dateTime.toLocal()}"; // Display to the user
                                });
                              }
                            }
                          },
                          child: Container(
                            height: 80,
                            width: MediaQuery.of(context).size.width / 2.3,
                            padding: const EdgeInsets.symmetric(
                              vertical: 15,
                              horizontal: 20,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              gradient: const LinearGradient(
                                colors: [Colors.blueAccent, Colors.lightBlue],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 5,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                '23'.tr,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Display the selected date/time or default option
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Text(
                        _deliveryTime,
                        style: TextStyle(fontSize: 16, color: Colors.black54),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: TextFormField(
                        controller: _receivedNumberController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: '24'.tr,
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.phone),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'This field is required';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Row(
                        children: [
                          Icon(Icons.phone_in_talk),
                          SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '25'.tr,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black54,
                                ),
                              ),
                              Text(
                                '26'.tr,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Container(
                        padding: EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '27'.tr,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('28'.tr, style: TextStyle(fontSize: 16)),
                                Text(
                                  '${_estimatedDeliveryCost.toStringAsFixed(2)} DT',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('29'.tr, style: TextStyle(fontSize: 16)),
                                Text(
                                  '${_serviceCost.toStringAsFixed(2)} DT',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '30'.tr,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '${(_estimatedDeliveryCost + _serviceCost).toStringAsFixed(2)} DT',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height / 9),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: loginController.isAuthenticated.value
                ? GestureDetector(
                    onTap: () async {
                      // Validate the form
                      if (_formKey.currentState!.validate()) {
                        // Proceed with logic if the form is valid

                        if (!categoryController
                            .userProfile
                            .value
                            .isNotBlocked) {
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

                        // Set loading state to true
                        setState(() {
                          _isLoading = true;
                        });

                        // Load token and create order
                        await loginController.loadToken();
                        final order = await cartController.createOrderCourier(
                          _objectController.text,
                          '$pickupAddress, ${_pickUpExactController.text}',
                          pickupLocation?.latitude ?? 0.0,
                          pickupLocation?.longitude ?? 0.0,
                          '$dropOffAddress, ${_dropOffExactController.text}',
                          dropOffLocation?.latitude ?? 0.0,
                          dropOffLocation?.longitude ?? 0.0,
                          _receivedNumberController.text,
                          'pending',
                          _selectedDeliveryDateTime ?? DateTime.now(),
                        );

                        // Optionally re-enable loading state here if needed
                        // setState(() {
                        //   _isLoading = false;
                        // });

                        // Show success dialog if order is successfully placed
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
                                      Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => MenuScreen(
                                          
                                          ),
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
                      } else {
                        // If the form is invalid, show error messages
                        print("Form is invalid");
                      }
                    },
                    child: Container(
                      height: 60,
                      width: MediaQuery.of(context).size.width / 2,
                      padding: EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 20,
                      ),
                      margin: EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.orange,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          "Confirm Order",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  )
                : Container(
                    height: 100,
                    child: Row(
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
                                colors: [Colors.orange, Colors.orange],
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
                        SizedBox(width: 10),
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
                                colors: [Colors.blue, Colors.blue],
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
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  // void _submitOrder() {
  //   if (pickupLocation != null && dropOffLocation != null) {
  //     print('Pickup: $pickupLocation, Drop-Off: $dropOffLocation');
  //   } else {
  //     print('Please select both locations');
  //   }
  // }

  Future<void> _getAddressFromCoordinates(
    LatLng coordinates, {
    required bool isPickup,
  }) async {
    final url =
        'https://nominatim.openstreetmap.org/reverse?lat=${coordinates.latitude}&lon=${coordinates.longitude}&format=json';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final address = jsonResponse['address'];

        String placeName = address['road'] ?? '';
        placeName += address['suburb'] != null ? ', ${address['suburb']}' : '';
        placeName += address['city'] != null ? ', ${address['city']}' : '';
        placeName += address['state'] != null ? ', ${address['state']}' : '';
        placeName += address['country'] != null
            ? ', ${address['country']}'
            : '';

        setState(() {
          if (isPickup) {
            pickupAddress = '$placeName';
          } else {
            dropOffAddress = '$placeName';
          }
        });
      } else {
        print('Failed to get address from coordinates.');
      }
    } catch (e) {
      print("Error occurred while getting address: $e");
    }
  }
}

class LocationPickerMap extends StatefulWidget {
  @override
  _LocationPickerMapState createState() => _LocationPickerMapState();
}

class _LocationPickerMapState extends State<LocationPickerMap> {
  LatLng? _pickedLocation; // Make nullable to accommodate initial null state
  TextEditingController _searchController = TextEditingController();
  MapController _mapController = MapController();
  bool _loadingCurrentLocation = true;

  @override
  void initState() {
    super.initState();
    _getCurrentPosition();
  }

  Future<void> _getCurrentPosition() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      await Geolocator.requestPermission();
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _pickedLocation = LatLng(position.latitude, position.longitude);
        _loadingCurrentLocation = false;
        _mapController.move(_pickedLocation!, 13.0); // Move to current location
      });
    } catch (e) {
      setState(() {
        _pickedLocation = LatLng(35.167494, 8.833903); // Fallback to default
        _loadingCurrentLocation = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pick Location',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.orange.shade400,
      ),
      body: _loadingCurrentLocation
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Enter location name',
                      suffixIcon: IconButton(
                        icon: Icon(Icons.search),
                        onPressed: _searchLocation,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 2.0),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 1.0),
                      ),
                    ),
                    onSubmitted: (_) => _searchLocation(),
                  ),
                ),
                Expanded(
                  child: FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(
                      initialCenter: _pickedLocation!,
                      initialZoom: 13.0,
                      onTap: (tapPosition, latLng) {
                        setState(() {
                          _pickedLocation = latLng;
                        });
                      },
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                      ),
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: _pickedLocation!,
                            width: 40.0,
                            height: 40.0,
                            child: Icon(
                              Icons.location_pin,
                              color: Colors.red,
                              size: 40.0,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.check),
        onPressed: () {
          Navigator.pop(context, _pickedLocation);
        },
      ),
    );
  }

  // Function to search for location by name
  Future<void> _searchLocation() async {
    String location = _searchController.text;
    if (location.isEmpty) return;

    String url =
        'https://nominatim.openstreetmap.org/search?q=$location&format=json&limit=1';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      if (data.isNotEmpty) {
        double lat = double.parse(data[0]['lat']);
        double lon = double.parse(data[0]['lon']);
        LatLng newPosition = LatLng(lat, lon);

        setState(() {
          _pickedLocation = newPosition;
          _mapController.move(
            newPosition,
            13.0,
          ); // Center map on searched location
        });
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Location not found")));
      }
    } else {
      throw Exception("Failed to load location data");
    }
  }
}
