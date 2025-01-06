import 'package:cloud_firestore_crud_todo/auth/login_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashPage extends StatelessWidget {
  SplashPage({super.key}) {
    Future.delayed(const Duration(seconds: 3), () => Get.to(const LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    var textstyle = Theme.of(context).textTheme;
    return Scaffold(
        body: Center(
      child: Text(
        "Welcome to chating App",
        style: textstyle.headlineLarge,
      ),
    ));
  }
}
