import 'package:get/get.dart';
import 'package:realm/realm.dart';
import 'package:getx_ecommerce/models/product.dart';
import 'package:flutter/material.dart';
import 'package:getx_ecommerce/controllers/product_controller.dart';

class CartController extends GetxController {
  final cartItems = <CartItem>[].obs;
  late Realm realm;
  
  @override
  void onInit() {
    super.onInit();
    final config = Configuration.local([Product.schema, CartItem.schema]);
    realm = Realm(config);
    fetchCartItems();
  }
  
  void fetchCartItems() {
    cartItems.assignAll(realm.all<CartItem>());
  }

  double get totalPrice {
    final productController = Get.find<ProductController>();
    return cartItems.fold(0.0, (sum, item) {
      final product = productController.products.firstWhereOrNull((p) => p.id == item.productId);
      return sum + ((product?.price ?? 0.0) * item.quantity);
    });
  }

  void addToCart(Product product) {
    
    final index = cartItems.indexWhere((item) => item.productId == product.id);
    
    realm.write(() {
      if (index != -1) {
        
        cartItems[index].quantity++;
      } else {
        
        final newItem = CartItem(ObjectId(), product.id, 1);
        realm.add(newItem);
        cartItems.add(newItem); 
      }
    });
    
    cartItems.refresh(); 
    
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
    realm.write(() {
      realm.delete(item);
    });
    cartItems.remove(item);
  }

  void increaseQuantity(CartItem item) {
    realm.write(() {
      item.quantity++;
    });
    cartItems.refresh();
  }

  void decreaseQuantity(CartItem item) {
    if (item.quantity > 1) {
      realm.write(() {
        item.quantity--;
      });
      cartItems.refresh();
    } else {
      removeFromCart(item);
    }
  }
  
  @override
  void onClose() {
    realm.close();
    super.onClose();
  }
}
