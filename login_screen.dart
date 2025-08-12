import 'package:flutter/material.dart';
import 'booking_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Diagnostic Lab - Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _phoneController, decoration: InputDecoration(labelText: 'Phone (+91...)')),
            SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                // For starter, skip OTP and go to booking screen
                Navigator.push(context, MaterialPageRoute(builder: (_) => BookingScreen()));
              },
              child: Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }
}
