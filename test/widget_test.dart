import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:otp_login_page/login.dart';
import 'package:otp_login_page/get_otp.dart';
import 'package:pinput/pinput.dart';

void main() {
  testWidgets('MyOtp widget test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MaterialApp(
      home: MyOtp(),
    ));

    // Verify that the widgets are present.
    expect(find.text('Phone Verification'), findsOneWidget);
    expect(find.text('We need to register your Phone before getting Started !'),
        findsOneWidget);
    expect(find.byType(Pinput), findsOneWidget);
    expect(find.text('Verify Phone Number'), findsOneWidget);
  });

  testWidgets('MyPhone widget test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MaterialApp(
      home: MyPhone(),
    ));

    // Verify that the widgets are present.
    expect(find.text('Phone Verification'), findsOneWidget);
    expect(find.text('We need to register your Phone before getting Started !'),
        findsOneWidget);
    expect(find.byType(TextField), findsWidgets);
    expect(find.text('Send the code'), findsOneWidget);
  });
}
