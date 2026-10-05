import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:getx_ecommerce/models/product.dart';

class ProductController extends GetxController {
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final descriptionController = TextEditingController();

  final imagePath = ''.obs;
  final products = <Product>[].obs;
  final searchQuery = ''.obs;
  final isLoading = false.obs;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Product> get filteredProducts {
    if (searchQuery.value.isEmpty) {
      return products;
    }
    return products
        .where((product) =>
            product.name.toLowerCase().contains(searchQuery.value.toLowerCase()))
        .toList();
  }

  Product? getProduct(String id) {
    return products.firstWhereOrNull((p) => p.id == id);
  }

  @override
  void onInit() {
    super.onInit();
    bindProductsStream();
  }

  void bindProductsStream() {
    _firestore.collection('products').snapshots().listen((snapshot) {
      products.value = snapshot.docs.map((doc) {
        return Product.fromFirestore(doc);
      }).toList();
    }, onError: (e) {
      debugPrint("Error fetching products from Firestore: $e");
    });
  }

  @override
  void onClose() {
    nameController.dispose();
    priceController.dispose();
    descriptionController.dispose();
    super.onClose();
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final appDir = await getApplicationDocumentsDirectory();
      final fileName =
          '${DateTime.now().millisecondsSinceEpoch}_${pickedFile.name}';
      final savedImage =
          await File(pickedFile.path).copy('${appDir.path}/$fileName');
      imagePath.value = savedImage.path;
    }
  }

  Future<void> saveProduct() async {
    if (nameController.text.isEmpty ||
        priceController.text.isEmpty ||
        descriptionController.text.isEmpty ||
        imagePath.value.isEmpty) {
      if (Get.isSnackbarOpen) {
        Get.closeAllSnackbars();
      }
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

    try {
      isLoading.value = true;
      await _firestore.collection('products').add({
        'name': nameController.text.trim(),
        'price': price,
        'description': descriptionController.text.trim(),
        'imagePath': imagePath.value,
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (Get.isSnackbarOpen) {
        Get.closeAllSnackbars();
      }
      Get.snackbar(
        'Success',
        'Product added successfully to Firebase!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      nameController.clear();
      priceController.clear();
      descriptionController.clear();
      imagePath.value = '';

      Get.back();
    } catch (e) {
      if (Get.isSnackbarOpen) {
        Get.closeAllSnackbars();
      }
      Get.snackbar(
        'Error',
        'Failed to save product: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
