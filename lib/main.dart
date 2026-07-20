import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_ecommerce/Screens/homepage.dart';
import 'package:getx_ecommerce/Screens/splashpage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: Splashpage(),
    );
  }
}