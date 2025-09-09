class TypeCategory {
  final int id;
  final String name;
  final String image;
  final List<Store> stores;

  TypeCategory({
    required this.id,
    required this.name,
    required this.image,
    required this.stores,
  });

  factory TypeCategory.fromJson(Map<String, dynamic> json) {
    return TypeCategory(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      stores: (json['stores'] as List<dynamic>?)
              ?.map((store) => Store.fromJson(store))
              .toList() ??
          [],
    );
  }
}

class Category {
  final int id;
  final String name;
  final String image;
  final List<Item> items;

  Category(
      {required this.id,
      required this.name,
      required this.image,
      required this.items});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      items: (json['items'] as List<dynamic>?)
              ?.map((item) => Item.fromJson(item))
              .toList() ??
          [],
    );
  }
}

class Item {
  final int id;
  final String name;
  final String? sub_category_name;
  final String description;
  final int store;
  final double price;
  final String image;
  final double average_rating;
  final bool personalized;
  final List<Suppliment> suppliments;
  final bool available;
  final int category;
  final double percentage_discount;
  final DateTime createdAt;
  final List<RatingItem> ratings;

  Item(
      {required this.id,
      required this.name,
      this.sub_category_name,
      required this.description,
      required this.price,
      required this.store,
      required this.image,
      required this.average_rating,
      required this.personalized,
      required this.suppliments,
      required this.available,
      required this.category,
      required this.percentage_discount,
      required this.createdAt,
      required this.ratings});

  String get fullImageUrl {
    if (image.startsWith('http')) {
      return image;
    }
    return 'https://sdingserver.xyz$image';
  }

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'],
      name: json['name'],
      store: json['store'],
      sub_category_name: json['sub_category_name'],
      description: json['description'],
      price: double.parse(json['price'].toString()),
      image: json['image'] ?? '',
      average_rating: double.parse(json['average_rating'].toString()),
      personalized: json['personalized'] ?? false,
      suppliments: (json['suppliments'] as List<dynamic>?)
              ?.map((suppliment) => Suppliment.fromJson(suppliment))
              .toList() ??
          [],
      available: json['available'] ?? true,
      category: json['category'],
      percentage_discount: double.parse(json['percentage_discount'].toString()),
      createdAt: DateTime.parse(json['created_at']),
      ratings: (json['ratings'] as List<dynamic>?)
              ?.map((rate) => RatingItem.fromJson(rate))
              .toList() ??
          [],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'sub_category_name': sub_category_name,
      'description': description,
      'price': price,
      'store': store,
      'image': image,
      'average_rating': average_rating,
      'personalized': personalized,
      'suppliments': suppliments.map((s) => s.toJson()).toList(),
      'available': available,
      'category': category,
      'percentage_discount': percentage_discount,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

class Suppliment {
  final int id;
  final String title;
  final double price;
  final String category;

  Suppliment({
    required this.id,
    required this.title,
    required this.price,
    required this.category,
  });
  factory Suppliment.fromJson(Map<String, dynamic> json) {
    return Suppliment(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      price: double.parse(json['price'].toString()),
      category: json['sup_category_name'] ?? '',
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'category': category,
    };
  }
}

class OrderCourier {
  final int id;
  final int user;
  final String status;
  final DateTime createdAt;
  final String objectSent;
  final String pickupAddress;
  final double pickupLatitude;
  final double pickupLongitude;
  final String deliveryAddress;
  final double deliveryLatitude;
  final double deliveryLongitude;
  final DateTime deliveryTime;
  final String recipientPhone;
  final String price;

  OrderCourier(
      {required this.id,
      required this.user,
      required this.status,
      required this.createdAt,
      required this.objectSent,
      required this.pickupAddress,
      required this.pickupLatitude,
      required this.pickupLongitude,
      required this.deliveryAddress,
      required this.deliveryLatitude,
      required this.deliveryLongitude,
      required this.deliveryTime,
      required this.recipientPhone,
      required this.price});

  factory OrderCourier.fromJson(Map<String, dynamic> json) {
    return OrderCourier(
      id: json['id'],
      user: json['user'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      objectSent: json['objectSent'],
      pickupAddress: json['pickup_address'],
      pickupLatitude: json['pickup_latitude'],
      pickupLongitude: json['pickup_longitude'],
      deliveryAddress: json['delivery_address'],
      deliveryLatitude: json['delivery_latitude'],
      deliveryLongitude: json['delivery_longitude'],
      deliveryTime: DateTime.parse(json['delivery_time']),
      recipientPhone: json['recipient_phone'],
      price: json['price'],
    );
  }
}

class Order {
  final int id;
  final String status;
  final String location;
  final int user;
  final DateTime createdAt;
  final List<OrderItem> items;
  final String total_price;
  final double total_price_float;
  final int order_id_returned;

  Order(
      {required this.id,
      required this.order_id_returned,
      required this.status,
      required this.user,
      required this.createdAt,
      required this.location,
      required this.items,
      required this.total_price,
      required this.total_price_float});

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      status: json['status'],
      location: json['location'],
      createdAt: DateTime.parse(json['created_at']),
      user: json['user'],
      items: (json['items'] as List<dynamic>?)
              ?.map((item) => OrderItem.fromJson(item))
              .toList() ??
          [],
      total_price: json['total_price'],
      order_id_returned: json['order_id_returned'],
      total_price_float: double.parse(json['total_price_float'].toString()),
    );
  }
}

class OrderItem {
  final int id;
  final String itemName;
  final int quantity;
  final List<String> suppliments;
  final String storeName;

  OrderItem({
    required this.id,
    required this.itemName,
    required this.quantity,
    required this.suppliments,
    required this.storeName,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'],
      itemName: json['item_name'],
      quantity: json['quantity'],
      suppliments: List<String>.from(json['suppliments']),
      storeName: json['store_name'],
    );
  }
}

class CartItem {
  final Item food;
  int quantity;

  CartItem({
    required this.food,
    this.quantity = 1,
  });
}

class Publicity {
  final int id;
  final String title;
  final String image;
  final double latitude;
  final double longitude;

  Publicity({
    required this.id,
    required this.title,
    required this.image,
    required this.latitude,
    required this.longitude,
  });

  factory Publicity.fromJson(Map<String, dynamic> json) {
    return Publicity(
      id: json['id'],
      title: json['title'],
      image: json['image'] ?? '',
      latitude: json['latitude'] ?? 0.0,
      longitude: json['longitude'] ?? 0.0,
    );
  }
}

// class Store {
//   final int id;
//   final String name;
//   final String image;
//   final int category;
//   final String phoneNumber;
//   final String country;
//   final String governorate;
//   final bool available;
//   final List<Item> items;
//   final double latitude;
//   final double longitude;
//   final List<RatingStore> ratings;
//   final double average_rating;
//   final List<User> favorited_by;
//   final bool free_delivery;

//   Store(
//       {required this.id,
//       required this.name,
//       required this.image,
//       required this.category,
//       required this.phoneNumber,
//       required this.country,
//       required this.governorate,
//       required this.available,
//       required this.items,
//       required this.latitude,
//       required this.longitude,
//       required this.ratings,
//       required this.average_rating,
//       required this.favorited_by,
//       required this.free_delivery});

//   factory Store.fromJson(Map<String, dynamic> json) {
//     return Store(
//       id: json['id'],
//       name: json['name'],
//       image: json['image'] ?? '',
//       category: json['category'],
//       phoneNumber: json['phone_number'] ?? '',
//       country: json['country'],
//       governorate: json['governorate'],
//       available: json['available'] ?? true,
//       items: (json['items'] as List<dynamic>?)
//               ?.map((item) => Item.fromJson(item))
//               .toList() ??
//           [],
//       latitude: json['latitude'].toDouble() ?? 0.0,
//       longitude: json['longitude'].toDouble() ?? 0.0,
//       ratings: (json['ratings'] as List<dynamic>?)
//               ?.map((rate) => RatingStore.fromJson(rate))
//               .toList() ??
//           [],
//       average_rating: double.parse(json['average_rating'].toString()),
//       favorited_by: (json['favorited_by'] as List<dynamic>?)
//               ?.map((item) => User.fromJson(item))
//               .toList() ??
//           [],
//       free_delivery: json['free_delivery'] ?? false,
//     );
//   }
// }
class Store {
  final int id;
  final String name;
  final String image;
  final int category;
  final String phoneNumber;
  final String country;
  final String governorate;
  final bool available;
  final List<Item> items;
  final double latitude;
  final double longitude;
  final List<RatingStore> ratings;
  final double average_rating;
  final List<User> favorited_by;
  final bool free_delivery;
  final String firstItemImage;
  final bool has_discounted_item;

  Store({
    required this.id,
    required this.name,
    required this.image,
    required this.category,
    required this.phoneNumber,
    required this.country,
    required this.governorate,
    required this.available,
    required this.items,
    required this.latitude,
    required this.longitude,
    required this.ratings,
    required this.average_rating,
    required this.favorited_by,
    required this.free_delivery,
    required this.firstItemImage,
    required this.has_discounted_item,
  });

  factory Store.fromJson(Map<String, dynamic> json) {
    return Store(
      id: json['id'],
      name: json['name'],
      image: json['image'] ?? '',
      category: json['category'],
      phoneNumber: json['phone_number'] ?? '',
      country: json['country'],
      governorate: json['governorate'],
      available: json['available'] ?? true,
      items: (json['items'] as List<dynamic>?)
              ?.map((item) => Item.fromJson(item))
              .toList() ??
          [],
      latitude: json['latitude'].toDouble() ?? 0.0,
      longitude: json['longitude'].toDouble() ?? 0.0,
      ratings: (json['ratings'] as List<dynamic>?)
              ?.map((rate) => RatingStore.fromJson(rate))
              .toList() ??
          [],
      average_rating: double.parse(json['average_rating'].toString()),
      favorited_by: (json['favorited_by'] as List<dynamic>?)
              ?.map((item) => User.fromJson(item))
              .toList() ??
          [],
      free_delivery: json['free_delivery'] ?? false,
      firstItemImage: json['first_item'] ?? '',
      has_discounted_item: json['has_discounted_item'] ?? false,
    );
  }
}

class Notice {
  final int id;
  final User user;
  final int store;
  final String notice;

  Notice({
    required this.id,
    required this.user,
    required this.store,
    required this.notice,
  });

  // Factory constructor to create a Notice from JSON
  factory Notice.fromJson(Map<String, dynamic> json) {
    return Notice(
      id: json['id'],
      user: User.fromJson(json['user']),
      store: json['store'],
      notice: json['notice'],
    );
  }
}

// class Rating {
//   final int id;
//   final User user;
//   final int item;
//   final int store;
//   final int rating;

//   Rating({
//     required this.id,
//     required this.user,
//     required this.item,
//     required this.store,
//     required this.rating,
//   });

//   factory Rating.fromJson(Map<String, dynamic> json) {
//     return Rating(
//       id: json['id'],
//       user: User.fromJson(json['user']),
//       item: json['item'],
//       store: json['store'],
//       rating: json['rating'],
//     );
//   }
// }

class RatingStore {
  int id;
  User user;
  int store;
  int rating;

  RatingStore({
    required this.id,
    required this.user,
    required this.store,
    required this.rating,
  });

  factory RatingStore.fromJson(Map<String, dynamic> json) {
    return RatingStore(
      id: json['id'],
      user: User.fromJson(json['user']),
      store: json['store'],
      rating: json['rating'],
    );
  }
}

class RatingItem {
  int id;
  User user;
  int item;
  int rating;

  RatingItem({
    required this.id,
    required this.user,
    required this.item,
    required this.rating,
  });

  factory RatingItem.fromJson(Map<String, dynamic> json) {
    return RatingItem(
      id: json['id'],
      user: User.fromJson(json['user']),
      item: json['item'],
      rating: json['rating'],
    );
  }
}

class DeliveryPerson {
  final int id;
  final String name;
  final String phoneNumber;
  final String vehicleNumber;

  DeliveryPerson({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.vehicleNumber,
  });

  factory DeliveryPerson.fromJson(Map<String, dynamic> json) {
    return DeliveryPerson(
      id: json['id'],
      name: json['name'],
      phoneNumber: json['phone_number'],
      vehicleNumber: json['vehicle_number'],
    );
  }
}

class User {
  final int id;
  final String username;
  // final String mobile;
  final bool isNotBlocked;

  User(
      {required this.id,
      required this.username,
      // required this.mobile,
      required this.isNotBlocked});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      // mobile: json['mobile'],
      isNotBlocked: json['is_not_blocked'],
    );
  }
}

class SubCategory {
  final int id;
  final String name;

  SubCategory({required this.id, required this.name});

  factory SubCategory.fromJson(Map<String, dynamic> json) {
    return SubCategory(id: json['id'], name: json['name']);
  }
}
