import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  // State variables
  final TextEditingController handleController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  bool isOtpVisible = false; // Initially hide OTP field
  bool isOtpObscured = true; // Initially obscure OTP field
  Map<String, dynamic>? userData;

  // Request OTP
  Future<void> _handleOTPRequest() async {
    final handle = handleController.text.trim();
    if (handle.isEmpty) {
      _showError('Please enter an email');
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('http://172.17.0.1:8080/api/sessauth/otp'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'handle': handle}),
      );

      if (!mounted) return; // Ensure widget is still in the tree

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData is Map<String, dynamic> &&
            responseData.containsKey('otp')) {
          setState(() {
            otpController.text = responseData['otp'].toString();
            isOtpVisible = true; // Show OTP field
          });
          _showSnackBar('OTP sent successfully');
        } else {
          _showError('No user found');
        }
      } else if (response.statusCode == 404) {
        _showError('No user found');
      } else {
        _showError('Failed to generate OTP. Status: ${response.statusCode}');
      }
    } catch (error) {
      _showError('Error generating OTP: $error');
    }
  }

  // Handle Login
  Future<void> _handleLoginRequest() async {
    final handle = handleController.text.trim();
    final otp = otpController.text.trim();

    if (handle.isEmpty || otp.isEmpty) {
      _showError('Please enter email and OTP');
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('http://172.17.0.1:8080/api/sessauth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'handle': handle, 'otp': otp}),
      );

      if (!mounted) return; // Ensure widget is still in the tree

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData is Map<String, dynamic>) {
          setState(() {
            userData = responseData; // Save user data
          });
        }
        Navigator.pushReplacementNamed(context, 'home', arguments: userData);
      } else {
        _showError('Failed to login. Invalid credentials');
      }
    } catch (error) {
      _showError('Error during login: $error');
    }
  }

  // Snackbar Helper
  void _showSnackBar(String message) {
    if (!mounted) return; // Ensure widget is still in the tree
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  // Error Dialog Helper
  void _showError(String message) {
    if (!mounted) return; // Ensure widget is still in the tree
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: handleController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              const SizedBox(height: 20),
              if (isOtpVisible)
                TextField(
                  controller: otpController,
                  obscureText: isOtpObscured,
                  decoration: InputDecoration(
                    labelText: 'OTP',
                    suffixIcon: IconButton(
                      icon: Icon(
                        isOtpObscured ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          isOtpObscured = !isOtpObscured;
                        });
                      },
                    ),
                  ),
                ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (isOtpVisible) {
                    _handleLoginRequest();
                  } else {
                    _handleOTPRequest();
                  }
                },
                child: Text(isOtpVisible ? 'Login' : 'Request OTP'),
              ),
              if (isOtpVisible)
                TextButton(
                  onPressed: () {
                    setState(() {
                      isOtpVisible = false;
                      otpController.clear();
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
