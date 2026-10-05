import 'package:cloud_firestore/cloud_firestore.dart';

class CartItem {
  final String id;
  final String productId;
  int quantity;

  CartItem({
    required this.id,
    required this.productId,
    required this.quantity,
  });

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'quantity': quantity,
    };
  }

  factory CartItem.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return CartItem(
      id: doc.id,
      productId: data['productId'] ?? '',
      quantity: (data['quantity'] as num?)?.toInt() ?? 1,
    );
  }

  factory CartItem.fromMap(Map<String, dynamic> map, String id) {
    return CartItem(
      id: id,
      productId: map['productId'] ?? '',
      quantity: (map['quantity'] as num?)?.toInt() ?? 1,
    );
  }
}
