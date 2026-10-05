import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_ecommerce/Screens/Address_screens.dart';
import 'package:getx_ecommerce/controllers/cart_controller.dart';
import 'package:getx_ecommerce/controllers/product_controller.dart';
import 'package:getx_ecommerce/models/order.dart';

class Cartpage extends StatelessWidget {
  const Cartpage({super.key});

  @override
  Widget build(BuildContext context) {
    final cartController = Get.put(CartController());
    Get.put(ProductController());

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text('My Cart', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        backgroundColor: const Color(0xFFFF4B2B),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Obx(() {
        if (cartController.cartItems.isEmpty) {
          return const Center(
            child: Text(
              'Your cart is empty',
              style: TextStyle(fontSize: 16, color: Colors.grey, fontWeight: FontWeight.w500),
            ),
          );
        }

        return SafeArea(
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.only(top: 8, bottom: 8),
                  itemCount: cartController.cartItems.length,
                  itemBuilder: (context, index) {
                    final cartItem = cartController.cartItems[index];
                    final product = cartController.getProduct(cartItem.productId);
          
                    if (product == null) {
                      return const SizedBox.shrink(); 
                    }
          
                    return Container(
                      color: Colors.white,
                      margin: const EdgeInsets.only(bottom: 8),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              
                              Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Image.file(
                                      File(product.imagePath),
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey.shade300),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              cartController.decreaseQuantity(cartItem);
                                            },
                                            child: const Padding(
                                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                              child: Icon(Icons.remove, size: 18, color: Colors.black87),
                                            ),
                                          ),
                                          Container(
                                            color: Colors.grey.shade100,
                                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                            child: Text(
                                              '${cartItem.quantity}',
                                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              cartController.increaseQuantity(cartItem);
                                            },
                                            child: const Padding(
                                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                              child: Icon(Icons.add, size: 18, color: Colors.black87),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                ],
                              ),
                          
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(5, 12, 12, 12),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product.name,
                                        style: const TextStyle(fontSize: 16, color: Colors.black87),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      const Text('Seller: Premium Retail', style: TextStyle(color: Colors.grey, fontSize: 12)),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          Text(
                                            '₹${(product.price * 1.43).toStringAsFixed(0)}',
                                            style: const TextStyle(color: Colors.grey, fontSize: 12, decoration: TextDecoration.lineThrough),
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            '₹${product.price.toStringAsFixed(0)}',
                                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                          ),
                                          const SizedBox(width: 8),
                                          const Text('43% Off', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 12)),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      const Text('Free Delivery', style: TextStyle(color: Colors.green, fontSize: 12)),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Divider(height: 1, thickness: 1, color: Color(0xFFEEEEEE)),
                          Row(
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    // Save for later logic (dummy)
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    alignment: Alignment.center,
                                    child: const Text('Save for later', style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w500)),
                                  ),
                                ),
                              ),
                              Container(width: 1, height: 40, color: const Color(0xFFEEEEEE)),
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    cartController.removeFromCart(cartItem);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    alignment: Alignment.center,
                                    child: const Text('Remove', style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w500)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              
              // Fixed Bottom Bar for Checkout
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      spreadRadius: 1,
                      blurRadius: 10,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '₹${cartController.totalPrice.toStringAsFixed(0)}',
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
                          ),
                          const Text(
                            'View price details',
                            style: TextStyle(color: Color(0xFFFF4B2B), fontSize: 12, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF4B2B), 
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4), 
                        ),
                        elevation: 0,
                      ),
                      onPressed: () {
                        final items = cartController.cartItems.map((cartItem) {
                          return OrderItem(
                            id: cartItem.id,
                            productId: cartItem.productId,
                            quantity: cartItem.quantity,
                          );
                        }).toList();
                        
                        Get.to(() => AddressScreens(
                          totalAmount: cartController.totalPrice,
                          items: items,
                          isFromCart: true,
                        ));
                      },
                      child: const Text(
                        'Place Order',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}