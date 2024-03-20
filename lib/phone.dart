import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MyPhone extends StatefulWidget {
  const MyPhone({Key? key}) : super(key: key);

  @override
  State<MyPhone> createState() => _MyPhoneState();
}

class _MyPhoneState extends State<MyPhone> {
  TextEditingController countryCodeController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  String? errorMessage; // To store any error message

  Future<void> sendOTP(String phoneNumber) async {
    try {
      final response = await http.post(
        Uri.parse('https://api.springbook.in/api/sessauth/otp'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'phone': phoneNumber,
        }),
      );

      if (response.statusCode == 200) {
        // Handle successful OTP request
        errorMessage = null; // Clear any previous error
        Navigator.pushNamed(context, 'verify');
      } else {
        // Handle error response
        errorMessage = 'Error sending OTP: ${response.statusCode}';
        setState(() {}); // Update UI to show the error message
      }
    } catch (error) {
      errorMessage = 'Error: $error';
      setState(() {});
    }
  }

  @override
  void initState() {
    countryCodeController.text = "+91";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(left: 25, right: 25),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "lib/assets/images/img.png",
                width: 150,
                height: 150,
              ),
              const SizedBox(
                height: 25,
              ),
              const Text(
                'Phone Verification',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'We need to register your Phone before getting Started !',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 30,
              ),
              Container(
                height: 55,
                decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.grey),
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      width: 48,
                      child: TextField(
                        controller: countryCodeController,
                        decoration:
                            const InputDecoration(border: InputBorder.none),
                      ),
                    ),
                    const Text(
                      "|",
                      style: TextStyle(fontSize: 33, color: Colors.grey),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: TextField(
                        controller: phoneNumberController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Phone",
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 40,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    String phoneNumber = countryCodeController.text.trim() +
                        phoneNumberController.text.trim();
                    sendOTP(phoneNumber);
                    Navigator.pushNamed(context, "verify");
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade600,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  child: const Text(
                    "Send the code",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
