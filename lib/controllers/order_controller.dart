import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_ecommerce/controllers/cart_controller.dart';
import 'package:getx_ecommerce/controllers/product_controller.dart';
import 'package:getx_ecommerce/models/order.dart';
import 'package:getx_ecommerce/models/product.dart';
import 'package:getx_ecommerce/Screens/bottomNavigationBar.dart';

class OrderController extends GetxController {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final postcodeController = TextEditingController();
  final address1Controller = TextEditingController();
  final address2Controller = TextEditingController();
  final townCityController = TextEditingController();
  final countyController = TextEditingController();

  final orders = <OrderModel>[].obs;
  final isLoading = false.obs;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get currentUserId => _auth.currentUser?.uid;

  CollectionReference<Map<String, dynamic>>? get _userOrdersRef {
    final uid = currentUserId;
    if (uid == null) return null;
    return _firestore.collection('users').doc(uid).collection('orders');
  }

  @override
  void onInit() {
    super.onInit();
    bindOrdersStream();
  }

  void bindOrdersStream() {
    final ref = _userOrdersRef;
    if (ref != null) {
      ref.orderBy('date', descending: true).snapshots().listen((snapshot) {
        orders.value = snapshot.docs.map((doc) {
          return OrderModel.fromFirestore(doc);
        }).toList();
      }, onError: (e) {
        debugPrint("Error fetching orders from Firestore: $e");
      });
    }
  }

  Product? getProduct(String productId) {
    if (Get.isRegistered<ProductController>()) {
      return Get.find<ProductController>().getProduct(productId);
    }
    return null;
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    postcodeController.dispose();
    address1Controller.dispose();
    address2Controller.dispose();
    townCityController.dispose();
    countyController.dispose();
    super.onClose();
  }

  Future<void> placeOrder({
    required double totalAmount,
    required List<OrderItem> items,
    bool isFromCart = true,
  }) async {
    if (nameController.text.isEmpty ||
        phoneController.text.isEmpty ||
        address1Controller.text.isEmpty ||
        postcodeController.text.isEmpty) {
      if (Get.isSnackbarOpen) {
        Get.closeAllSnackbars();
      }
      Get.snackbar('Error', 'Please fill in all mandatory address fields.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      return;
    }

    try {
      isLoading.value = true;
      final newOrderData = {
        'fullName': nameController.text.trim(),
        'phone': phoneController.text.trim(),
        'postcode': postcodeController.text.trim(),
        'address1': address1Controller.text.trim(),
        'address2': address2Controller.text.trim(),
        'townCity': townCityController.text.trim(),
        'county': countyController.text.trim(),
        'totalAmount': totalAmount,
        'date': FieldValue.serverTimestamp(),
        'items': items.map((e) => e.toMap()).toList(),
      };

      final ref = _userOrdersRef;
      if (ref != null) {
        await ref.add(newOrderData);
      } else {
        // Fallback for global orders collection
        await _firestore.collection('orders').add(newOrderData);
      }

      if (isFromCart && Get.isRegistered<CartController>()) {
        await Get.find<CartController>().clearCart();
      }

      if (Get.isSnackbarOpen) {
        Get.closeAllSnackbars();
      }

      Get.snackbar(
        'Success',
        'Order placed successfully!',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      nameController.clear();
      phoneController.clear();
      postcodeController.clear();
      address1Controller.clear();
      address2Controller.clear();
      townCityController.clear();
      countyController.clear();

      Get.offAll(() => const BottomNavbar());
    } catch (e) {
      if (Get.isSnackbarOpen) {
        Get.closeAllSnackbars();
      }
      Get.snackbar(
        'Error',
        'Failed to place order: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
