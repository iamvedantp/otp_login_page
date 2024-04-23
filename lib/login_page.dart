import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isOtpGenerated = false;
  TextEditingController handleController = TextEditingController();
  TextEditingController otpController = TextEditingController();

  Future<void> handleOTPRequest() async {
    try {
      final response = await http.post(
        Uri.parse('http://172.17.0.1:8080/api/sessauth/otp'),
        body: {
          'handle': handleController.text.trim(),
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData is Map<String, dynamic> &&
            responseData.containsKey('otp')) {
          setState(() {
            isOtpGenerated = true;
            otpController.text = responseData['otp'].toString(); // Autofill OTP
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('OTP sent successfully')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Invalid response from server')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to generate OTP')),
        );
      }
    } catch (error) {
      print('Error generating OTP: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred')),
      );
    }
  }

  Future<void> handleLoginRequest() async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:8080/api/sessauth/login'),
        body: {
          "handle": handleController.text.trim(),
          "otp": otpController.text.trim(),
        },
      );

      if (response.statusCode == 200) {
        // Login successful, navigate to home page
        Navigator.pushReplacementNamed(context, 'home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to login')),
        );
      }
    } catch (error) {
      print('Error during login: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: handleController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
              SizedBox(height: 20),
              if (isOtpGenerated)
                TextField(
                  controller: otpController,
                  decoration: const InputDecoration(labelText: 'OTP'),
                ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed:
                    isOtpGenerated ? handleLoginRequest : handleOTPRequest,
                child: Text(isOtpGenerated ? 'Login' : 'Get OTP'),
              ),
              if (isOtpGenerated)
                TextButton(
                  onPressed: () {
                    setState(() {
                      isOtpGenerated = false;
                    });
                  },
                  child: const Text('Edit Email'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
