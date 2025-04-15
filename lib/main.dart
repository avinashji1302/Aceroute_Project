import 'package:ace_routes/controller/background/location_service.dart';
import 'package:ace_routes/controller/connectivity/dependecy_injection.dart';
import 'package:ace_routes/view/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller/fontSizeController.dart';

void main() async {
  Get.put(FontSizeController());
  runApp(const MyApp());
  DependecyInjection.init();
  // await NotificationService.init();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: LoginScreen(),
      // home:  HomeScreen(),
    );
  }
}
