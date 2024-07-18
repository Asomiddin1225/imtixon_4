import 'package:flutter/material.dart';
import 'package:imtixon_4/models/event.dart';
import 'package:imtixon_4/views/widgets/confirmation_screen.dart';

class BookingScreen extends StatefulWidget {
  final Event event;

  const BookingScreen({super.key, required this.event});

  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  int seats = 0;
  String paymentMethod = 'Click';

  void _incrementSeats() {
    setState(() {
      seats++;
    });
  }

  void _decrementSeats() {
    setState(() {
      if (seats > 0) seats--;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text("Tafsilotlar", style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Ro\'yxatdan O\'tish',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            Text('Joylar sonini tanlang', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                    onPressed: _decrementSeats, icon: Icon(Icons.remove)),
                Text('$seats', style: TextStyle(fontSize: 24)),
                IconButton(onPressed: _incrementSeats, icon: Icon(Icons.add)),
              ],
            ),
            SizedBox(height: 16),
            Text('To\'lov turini tanlang', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            ListTile(
              title: Text('Click'),
              leading: Radio(
                value: 'Click',
                groupValue: paymentMethod,
                onChanged: (value) {
                  setState(() {
                    paymentMethod = value.toString();
                  });
                },
              ),
            ),
            ListTile(
              title: Text('Payme'),
              leading: Radio(
                value: 'Payme',
                groupValue: paymentMethod,
                onChanged: (value) {
                  setState(() {
                    paymentMethod = value.toString();
                  });
                },
              ),
            ),
            ListTile(
              title: Text('Naqd'),
              leading: Radio(
                value: 'Naqd',
                groupValue: paymentMethod,
                onChanged: (value) {
                  setState(() {
                    paymentMethod = value.toString();
                  });
                },
              ),
            ),
            SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ConfirmationScreen()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
                child: Text('Keyingi', style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
