import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController handleController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  bool isOtpVisible = false; // Initially hide OTP field
  bool isOtpObscured = true; // Initially obscure OTP field
  Map<String, dynamic>? userData; // User data collected from the backend

  Future<void> _handleOTPRequest() async {
    final handle = handleController.text.trim();
    if (handle.isEmpty) {
      _showError('Please enter an email');
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('http://172.17.0.1:8080/api/sessauth/otp'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'handle': handle,
        }),
      );

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
        _showError(
            'Failed to generate OTP. Server responded with ${response.statusCode}');
      }
    } catch (error, stackTrace) {
      _showError('Error generating OTP: $error', stackTrace: stackTrace);
    }
  }

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
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'handle': handle, 'otp': otp}),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData is Map<String, dynamic>) {
          setState(() {
            userData = responseData; // Save user data
          });
        }
        // Login successful, navigate to home page
        Navigator.pushReplacementNamed(context, 'home', arguments: userData);
      } else {
        _showError('Failed to login. Invalid credentials');
      }
    } catch (error, stackTrace) {
      _showError('Error during login: $error', stackTrace: stackTrace);
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void _showError(String message, {StackTrace? stackTrace}) {
    debugPrint('Error: $message');
    if (stackTrace != null) {
      debugPrint('Stack trace:\n$stackTrace');
    }
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
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
              const SizedBox(height: 20),
              if (isOtpVisible)
                PasswordField(
                  controller: otpController,
                  labelText: 'OTP',
                  isObscured: isOtpObscured,
                  toggleVisibility: () {
                    setState(() {
                      isOtpObscured = !isOtpObscured;
                    });
                  },
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
                      isOtpVisible = false; // Hide OTP field
                      otpController.clear(); // Clear OTP
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

// Custom widget for password field
class PasswordField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final bool isObscured;
  final VoidCallback toggleVisibility;

  const PasswordField({
    required this.controller,
    required this.labelText,
    required this.isObscured,
    required this.toggleVisibility,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: isObscured,
      decoration: InputDecoration(
        labelText: labelText,
        suffixIcon: IconButton(
          onPressed: toggleVisibility,
          icon: Icon(
            isObscured ? Icons.visibility_off : Icons.visibility,
          ),
        ),
      ),
    );
  }
}
