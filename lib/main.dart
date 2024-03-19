import 'package:flutter/material.dart';
import 'package:otp_login_page/home.dart';
import 'package:otp_login_page/phone.dart';
import 'package:otp_login_page/otp.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: 'phone',
    debugShowCheckedModeBanner: false,
    routes: {
      'phone': (context) => const MyPhone(),
      'verify': (context) => const MyOtp(),
      'home' :(context) =>  const MyHome(),
    },
  ));
}
