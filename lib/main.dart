import 'package:flutter/material.dart';
import 'package:otp_login_page/home.dart';
import 'package:otp_login_page/login_page.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: 'login',
    debugShowCheckedModeBanner: false,
    routes: {
      'login': (context) => const LoginPage(),
      'home': (context) => const MyHome(),
    },
  ));
}
