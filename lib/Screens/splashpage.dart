import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_ecommerce/Screens/bottomNavigationBar.dart';
import 'package:getx_ecommerce/Screens/homepage.dart';
import 'package:getx_ecommerce/Screens/loginpage.dart';
import 'package:getx_ecommerce/localdatabase/register_db.dart';

class Splashpage extends StatefulWidget {
  const Splashpage({super.key});

  @override
  State<Splashpage> createState() => _SplashpageState();
}

class _SplashpageState extends State<Splashpage> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    await Future.delayed(const Duration(seconds: 3));
    final isLoggedIn = await RegisterDb.instance.getLoginStatus();

    if (isLoggedIn) {
      Get.offAll(() => const bottomnavbar());
    } else {
      Get.offAll(() => const Loginpage());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF4A00E0), Color(0xFF8E2DE2)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Icon(
                Icons.shopping_bag_rounded,
                size: 80,
                color: Color(0xFF6713D2),
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              "E-COMMERCE",
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
                letterSpacing: 2.5,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Your Premium Store",
              style: TextStyle(
                color: Colors.white.withOpacity(0.85),
                fontSize: 16,
                letterSpacing: 1.2,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}