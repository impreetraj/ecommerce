import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_ecommerce/localdatabase/register_db.dart';
import 'package:getx_ecommerce/models/register.dart';
import 'package:getx_ecommerce/Screens/loginpage.dart';
import 'package:getx_ecommerce/Screens/bottomNavigationBar.dart';

class AuthController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  final isPasswordHidden = true.obs;
  final isLoading = false.obs;

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  Future<void> signup() async {
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        phoneController.text.isEmpty ||
        passwordController.text.isEmpty) {
      Get.snackbar('Error', 'All fields are required',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    isLoading.value = true;

    final user = UserModel(
      name: nameController.text.trim(),
      email: emailController.text.trim(),
      phone: phoneController.text.trim(),
      password: passwordController.text.trim(),
    );

    final result = await RegisterDb.instance.registerUser(user);
    
    isLoading.value = false;

    if (result == 'Success') {
      Get.snackbar('Success', 'Registration Successful! Please login.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white);
      
      
      nameController.clear();
      emailController.clear();
      phoneController.clear();
      passwordController.clear();

      Get.off(() => const Loginpage());
    } else {
      Get.snackbar('Error', result,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  }

  Future<void> login() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar('Error', 'Email and Password are required',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    isLoading.value = true;

    final user = await RegisterDb.instance.loginUser(
      emailController.text.trim(),
      passwordController.text.trim(),
    );

    isLoading.value = false;

    if (user != null) {
      Get.snackbar('Success', 'Welcome ${user.name}!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white);
      
    
      emailController.clear();
      passwordController.clear();
      
      
      await RegisterDb.instance.setLoginStatus(true);
      
      Get.offAll(() => const bottomnavbar());
    } else {
      Get.snackbar('Error', 'Invalid Email or Password',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  }

  Future<void> logout() async {
    await RegisterDb.instance.setLoginStatus(false);
    Get.offAll(() => const Loginpage());
  }
}
