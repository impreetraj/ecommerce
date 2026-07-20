import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_ecommerce/controllers/product_controller.dart';

class Addproduct extends StatelessWidget {
  const Addproduct({super.key});

  @override
  Widget build(BuildContext context) {
    final productController = Get.put(ProductController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Add Product'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              const SizedBox(height: 30),
              GestureDetector(
                onTap: productController.pickImage,
                child: Container(
                  width: MediaQuery.of(context).size.width / 1.1,
                  height: 140,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Obx(() => productController.imagePath.value.isEmpty
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.add_a_photo,
                                size: 60, color: Colors.black),
                            Text(
                              'Add Product Image',
                              style: TextStyle(
                                  color: Colors.black, fontSize: 16),
                            )
                          ],
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.file(
                            File(productController.imagePath.value),
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        )),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: productController.nameController,
                decoration: const InputDecoration(
                  hintText: 'Product Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: productController.priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: 'Product Price',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: productController.descriptionController,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText: 'Product Description',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: productController.saveProduct,
                  child: const Text(
                    'Add Product',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}