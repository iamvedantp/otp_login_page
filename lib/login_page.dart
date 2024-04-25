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

  Future<void> _handleOTPRequest() async {
    final handle = handleController.text.trim();
    if (handle.isEmpty) {
      _showError('Please enter an email');
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('http://172.17.0.1:8080/api/sessauth/otp'),
        body: {'handle': handle},
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData is Map<String, dynamic> &&
            responseData.containsKey('otp')) {
          setState(() {
            otpController.text = responseData['otp'].toString();
          });
          _showSnackBar('OTP sent successfully');
        } else {
          _showError('Invalid OTP response from server');
        }
      } else {
        _showError(
            'Failed to generate OTP. Server responded with ${response.statusCode}',
            lineNumber:
                40); // Line number example: Update with actual line number
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
        Uri.parse('http://localhost:8080/api/sessauth/login'),
        body: {'handle': handle, 'otp': otp},
      );

      if (response.statusCode == 200) {
        // Login successful, navigate to home page
        Navigator.pushReplacementNamed(context, 'home');
      } else {
        _showError('Failed to login. Invalid credentials',
            lineNumber:
                66); // Line number example: Update with actual line number
      }
    } catch (error, stackTrace) {
      _showError('Error during login: $error', stackTrace: stackTrace);
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void _showError(String message, {StackTrace? stackTrace, int? lineNumber}) {
    debugPrint('Error: $message\nLine number: $lineNumber');
    if (stackTrace != null) {
      debugPrint('Stack trace:\n$stackTrace');
    }
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text('$message\nLine number: $lineNumber'),
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
              if (otpController.text.isNotEmpty)
                TextField(
                  controller: otpController,
                  decoration: InputDecoration(labelText: 'OTP'),
                ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: otpController.text.isEmpty
                    ? _handleOTPRequest
                    : _handleLoginRequest,
                child: Text(otpController.text.isEmpty ? 'Get OTP' : 'Login'),
              ),
              if (otpController.text.isNotEmpty)
                TextButton(
                  onPressed: () {
                    setState(() {
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
