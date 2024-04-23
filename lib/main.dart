import 'package:flutter/material.dart';
import 'package:otp_login_page/home.dart';
import 'package:otp_login_page/login_page.dart';
// import 'package:otp_login_page/get_otp.dart';
// import 'package:otp_login_page/login.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: 'login',
    debugShowCheckedModeBanner: false,
    routes: {
      // 'phone': (context) => const MyPhone(),
      // 'verify': (context) => const MyOtp(),
      'login': (context) => const LoginPage(),
      'home': (context) => const MyHome(),
    },
  ));
}
