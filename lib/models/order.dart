import 'package:cloud_firestore/cloud_firestore.dart';

class OrderItem {
  final String id;
  final String productId;
  final int quantity;

  OrderItem({
    required this.id,
    required this.productId,
    required this.quantity,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'productId': productId,
      'quantity': quantity,
    };
  }

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      id: map['id'] ?? '',
      productId: map['productId'] ?? '',
      quantity: (map['quantity'] as num?)?.toInt() ?? 1,
    );
  }
}

class OrderModel {
  final String id;
  final String fullName;
  final String phone;
  final String postcode;
  final String addressLine1;
  final String addressLine2;
  final String townCity;
  final String county;
  final double totalAmount;
  final DateTime date;
  final List<OrderItem> items;

  OrderModel({
    required this.id,
    required this.fullName,
    required this.phone,
    required this.postcode,
    required this.addressLine1,
    required this.addressLine2,
    required this.townCity,
    required this.county,
    required this.totalAmount,
    required this.date,
    required this.items,
  });

  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'phone': phone,
      'postcode': postcode,
      'addressLine1': addressLine1,
      'addressLine2': addressLine2,
      'townCity': townCity,
      'county': county,
      'totalAmount': totalAmount,
      'date': Timestamp.fromDate(date),
      'items': items.map((item) => item.toMap()).toList(),
    };
  }

  factory OrderModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    
    DateTime parsedDate;
    if (data['date'] is Timestamp) {
      parsedDate = (data['date'] as Timestamp).toDate();
    } else if (data['date'] is String) {
      parsedDate = DateTime.tryParse(data['date']) ?? DateTime.now();
    } else {
      parsedDate = DateTime.now();
    }

    final rawItems = data['items'] as List<dynamic>? ?? [];
    final itemsList = rawItems
        .map((item) => OrderItem.fromMap(Map<String, dynamic>.from(item as Map)))
        .toList();

    return OrderModel(
      id: doc.id,
      fullName: data['fullName'] ?? '',
      phone: data['phone'] ?? '',
      postcode: data['postcode'] ?? '',
      addressLine1: data['addressLine1'] ?? '',
      addressLine2: data['addressLine2'] ?? '',
      townCity: data['townCity'] ?? '',
      county: data['county'] ?? '',
      totalAmount: (data['totalAmount'] as num?)?.toDouble() ?? 0.0,
      date: parsedDate,
      items: itemsList,
    );
  }
}
