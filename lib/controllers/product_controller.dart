import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:realm/realm.dart';
import 'package:getx_ecommerce/models/product.dart';
import 'package:flutter/material.dart';

class ProductController extends GetxController {
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final descriptionController = TextEditingController();
  
  final imagePath = ''.obs;
  
  final products = <Product>[].obs;
  
  late Realm realm;
  
  @override
  void onInit() {
    super.onInit();
    final config = Configuration.local([Product.schema, CartItem.schema]);
    realm = Realm(config);
    fetchProducts();
  }

  void fetchProducts() {
    products.assignAll(realm.all<Product>());
  }

  @override
  void onClose() {
    nameController.dispose();
    priceController.dispose();
    descriptionController.dispose();
    realm.close();
    super.onClose();
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      imagePath.value = pickedFile.path;
    }
  }

  void saveProduct() {
    if (nameController.text.isEmpty ||
        priceController.text.isEmpty ||
        descriptionController.text.isEmpty ||
        imagePath.value.isEmpty) {
      Get.snackbar(
        'Error',
        'All fields and image are required!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    final price = double.tryParse(priceController.text) ?? 0.0;
    
    final product = Product(
      ObjectId(),
      nameController.text.trim(),
      price,
      descriptionController.text.trim(),
      imagePath.value,
    );

    realm.write(() {
      realm.add(product);
    });

    Get.snackbar(
      'Success',
      'Product added successfully!',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );

    // clear fields
    nameController.clear();
    priceController.clear();
    descriptionController.clear();
    imagePath.value = '';
    
    fetchProducts();
  }
}
