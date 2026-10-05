import 'package:flutter/material.dart';
import 'dart:io';
import 'package:get/get.dart';
import 'package:getx_ecommerce/controllers/order_controller.dart';
import 'package:getx_ecommerce/Screens/order_details_page.dart';

class Order_screens extends StatelessWidget {
  const Order_screens({super.key});

  @override
  Widget build(BuildContext context) {
    final orderController = Get.put(OrderController());

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text(
          "My Orders",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        backgroundColor: const Color(0xFFFF4B2B),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: Obx(() {
          if (orderController.orders.isEmpty) {
            return const Center(
              child: Text(
                'No orders placed yet.',
                style: TextStyle(fontSize: 16, color: Colors.grey, fontWeight: FontWeight.w500),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: orderController.orders.length,
            itemBuilder: (context, index) {
              final order = orderController.orders[index];
              final firstItem = order.items.isNotEmpty ? order.items.first : null;
              final firstProduct = firstItem != null ? orderController.getProduct(firstItem.productId) : null;

              return GestureDetector(
                onTap: () {
                  Get.to(() => OrderDetailsPage(order: order));
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(16),
                  color: Colors.white,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product Image
                      if (firstProduct != null)
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade200),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              File(firstProduct.imagePath),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      const SizedBox(width: 16),
                      
                      
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              firstProduct?.name ?? 'Unknown Product',
                              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                           
                            const SizedBox(height: 8),
                            Text(
                              'Delivery expected by ${order.date.add(const Duration(days: 4)).day.toString().padLeft(2, '0')}/${order.date.add(const Duration(days: 4)).month.toString().padLeft(2, '0')}',
                              style: const TextStyle(color: Colors.green, fontSize: 13, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                      
                      
                      const Padding(
                        padding: EdgeInsets.only(top: 28.0),
                        child: Icon(Icons.chevron_right, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}