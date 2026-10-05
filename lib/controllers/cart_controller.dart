import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_ecommerce/controllers/product_controller.dart';
import 'package:getx_ecommerce/models/cart_item.dart';
import 'package:getx_ecommerce/models/product.dart';

class CartController extends GetxController {
  final cartItems = <CartItem>[].obs;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get currentUserId => _auth.currentUser?.uid;

  CollectionReference<Map<String, dynamic>>? get _userCartRef {
    final uid = currentUserId;
    if (uid == null) return null;
    return _firestore.collection('users').doc(uid).collection('cart');
  }

  @override
  void onInit() {
    super.onInit();
    bindCartStream();
  }

  void bindCartStream() {
    final ref = _userCartRef;
    if (ref != null) {
      ref.snapshots().listen((snapshot) {
        cartItems.value = snapshot.docs.map((doc) {
          return CartItem.fromFirestore(doc);
        }).toList();
      }, onError: (e) {
        debugPrint("Error fetching cart from Firestore: $e");
      });
    }
  }

  Product? getProduct(String productId) {
    if (Get.isRegistered<ProductController>()) {
      return Get.find<ProductController>().getProduct(productId);
    }
    return null;
  }

  double get totalPrice {
    double total = 0.0;
    for (var item in cartItems) {
      final product = getProduct(item.productId);
      if (product != null) {
        total += product.price * item.quantity;
      }
    }
    return total;
  }

  Future<void> addToCart(Product product) async {
    final existingIndex =
        cartItems.indexWhere((item) => item.productId == product.id);

    final ref = _userCartRef;
    if (ref != null) {
      if (existingIndex != -1) {
        final existingItem = cartItems[existingIndex];
        await ref.doc(existingItem.id).update({
          'quantity': existingItem.quantity + 1,
        });
      } else {
        await ref.add({
          'productId': product.id,
          'quantity': 1,
        });
      }
    } else {
      // In-memory fallback if guest
      if (existingIndex != -1) {
        cartItems[existingIndex].quantity++;
        cartItems.refresh();
      } else {
        cartItems.add(CartItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          productId: product.id,
          quantity: 1,
        ));
      }
    }

    if (Get.isSnackbarOpen) {
      Get.closeAllSnackbars();
    }
    Get.snackbar(
      'Success',
      '${product.name} added to cart',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }

  void removeFromCart(CartItem item) {
    Get.defaultDialog(
      title: 'Remove Item',
      middleText: 'Are you sure you want to remove this item from your cart?',
      textConfirm: 'Confirm',
      textCancel: 'Cancel',
      confirmTextColor: Colors.white,
      buttonColor: const Color(0xFFFF4B2B),
      cancelTextColor: const Color(0xFFFF4B2B),
      onConfirm: () async {
        await _performRemoveFromCart(item);
        Get.back();
      },
    );
  }

  Future<void> _performRemoveFromCart(CartItem item) async {
    final ref = _userCartRef;
    if (ref != null) {
      await ref.doc(item.id).delete();
    } else {
      cartItems.remove(item);
    }
  }

  Future<void> increaseQuantity(CartItem item) async {
    final ref = _userCartRef;
    if (ref != null) {
      await ref.doc(item.id).update({'quantity': item.quantity + 1});
    } else {
      item.quantity++;
      cartItems.refresh();
    }
  }

  Future<void> decreaseQuantity(CartItem item) async {
    if (item.quantity > 1) {
      final ref = _userCartRef;
      if (ref != null) {
        await ref.doc(item.id).update({'quantity': item.quantity - 1});
      } else {
        item.quantity--;
        cartItems.refresh();
      }
    } else {
      removeFromCart(item);
    }
  }

  Future<void> clearCart() async {
    final ref = _userCartRef;
    if (ref != null) {
      final snapshot = await ref.get();
      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }
    } else {
      cartItems.clear();
    }
  }
}
