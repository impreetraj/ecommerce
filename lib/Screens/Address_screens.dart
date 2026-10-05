import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_ecommerce/controllers/order_controller.dart';
import 'package:getx_ecommerce/models/order.dart';

class AddressScreens extends StatelessWidget {
  final double totalAmount;
  final bool isFromCart;
  final List<OrderItem> items;
  
  const AddressScreens({super.key, required this.totalAmount, required this.items, this.isFromCart = true});

  @override
  Widget build(BuildContext context) {
    final orderController = Get.put(OrderController());
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leadingWidth: 80,
        leading: Center(
          child: GestureDetector(
            onTap: () => Get.back(),
            child: const Text(
              'CANCEL',
              style: TextStyle(
                color: Colors.black87,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        title: const Text(
          'Your Addresses',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFC1F1E8), Color(0xFFC7F3EA), Color(0xFFD3F9EB)], // Custom light gradient similar to image
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: Colors.grey.shade300,
            height: 1.0,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Fill the  address',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 20),
              
            
              
              _buildInputField('Full Name', 'Preet Raj', orderController.nameController, hintMode: true),
              const SizedBox(height: 16),
              
              _buildInputField('Phone number', '6203740446', orderController.phoneController, hintMode: true),
              const SizedBox(height: 16),
              
              _buildInputField('Postcode', 'Enter your area postcode', orderController.postcodeController, hintMode: true),
              const SizedBox(height: 16),
              
              _buildInputField('Address Line 1 (or Company Name)', 'Start typing your address to get suggestions', orderController.address1Controller, hintMode: true),
              const SizedBox(height: 16),
              
              _buildInputField('Address Line 2', '', orderController.address2Controller, hintMode: true),
              const SizedBox(height: 16),
              
              _buildInputField('Town/City', '', orderController.townCityController, hintMode: true),
              const SizedBox(height: 16),
              
              _buildInputField('County (if applicable)', '', orderController.countyController, hintMode: true),
              const SizedBox(height: 30),
              
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                   orderController.placeOrder(totalAmount: totalAmount, items: items, isFromCart: isFromCart);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFB641B), // Flipkart Orange
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Place Order',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(String label, String placeholder, TextEditingController controller, {bool hintMode = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hintMode ? placeholder : null,
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(4)),
              borderSide: BorderSide(color: Color(0xFF2874F0), width: 2), // Flipkart Blue for focus
            ),
          ),
        ),
      ],
    );
  }
}
