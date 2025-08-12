import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BookingScreen extends StatefulWidget {
  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final _fire = FirebaseFirestore.instance;
  final _testController = TextEditingController();
  DateTime? _selectedDate;

  void _saveBooking() async {
    final userId = 'demoUser'; // replace with real user id
    await _fire.collection('bookings').add({
      'user_id': userId,
      'test_name': _testController.text,
      'date': _selectedDate?.toIso8601String() ?? DateTime.now().toIso8601String(),
      'status': 'requested',
      'created_at': FieldValue.serverTimestamp(),
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Booking placed')));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Book Test')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _testController, decoration: InputDecoration(labelText: 'Test name')),
            SizedBox(height: 12),
            ElevatedButton(
                onPressed: () async {
                  final date = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime.now(), lastDate: DateTime.now().add(Duration(days: 30)));
                  if (date != null) setState(() => _selectedDate = date);
                },
                child: Text(_selectedDate == null ? 'Pick Date' : _selectedDate!.toLocal().toString().split(' ')[0])),
            Spacer(),
            ElevatedButton(onPressed: _saveBooking, child: Text('Confirm Booking'))
          ],
        ),
      ),
    );
  }
}
