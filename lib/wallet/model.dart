// class Wallet {
//   final int points;
//   final String referralCode;
//   final bool isFirstTime;

//   Wallet({
//     required this.points,
//     required this.referralCode,
//     required this.isFirstTime,
//   });

//   factory Wallet.fromJson(Map<String, dynamic> json) {
//     return Wallet(
//       points: json['points'],
//       referralCode: json['referral_code'] ?? '',
//       isFirstTime: json['is_first_time'] ?? false,
//     );
//   }
// }

// class WalletTransaction {
//   final int id;
//   final int change;
//   final String description;
//   final DateTime createdAt;

//   WalletTransaction({
//     required this.id,
//     required this.change,
//     required this.description,
//     required this.createdAt,
//   });

//   factory WalletTransaction.fromJson(Map<String, dynamic> json) {
//     return WalletTransaction(
//       id: json['id'],
//       change: json['change'],
//       description: json['description'],
//       createdAt: DateTime.parse(json['created_at']),
//     );
//   }
// }

// class Carnet {
//   final String token;
//   final int usageLimit;
//   final int usageCount;
//   final bool canUseToday;
//   final bool isActive;
//   final DateTime createdAt;
//   final String type; // Added type field

//   Carnet({
//     required this.token,
//     required this.usageLimit,
//     required this.usageCount,
//     required this.canUseToday,
//     required this.isActive,
//     required this.createdAt,
//     required this.type, // Include in constructor
//   });

//   factory Carnet.fromJson(Map<String, dynamic> json) {
//     return Carnet(
//       token: json['token'],
//       usageLimit: json['usage_limit'],
//       usageCount: json['usage_count'],
//       canUseToday: json['can_use_today'],
//       isActive: json['is_active'],
//       createdAt: DateTime.parse(json['created_at']),
//       type: json['type'] ?? 'Unknown', // Safely parse type, default if missing
//     );
//   }
// }
