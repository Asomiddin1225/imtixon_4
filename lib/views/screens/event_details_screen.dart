import 'package:flutter/material.dart';
import 'package:imtixon_4/models/event.dart';
import 'package:imtixon_4/services/firebase_service.dart';
import 'package:provider/provider.dart';
import 'booking_screen.dart';

class EventDetailsScreen extends StatefulWidget {
  final Event event;

  const EventDetailsScreen({super.key, required this.event});

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text("Tadbir Haqida Ma'lumodlar",
            style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image.network(event.imageUrl, fit: BoxFit.cover),
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Image.network(
                    widget.event.imageUrl,
                    width: 400,
                    height: 400,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Text("Nomi: ",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  Text(widget.event.name,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.green)),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.calendar_month_rounded),
                  SizedBox(width: 8),
                  Text(widget.event.date),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.location_on),
                  SizedBox(width: 8),
                  Text(widget.event.location),
                ],
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Text("Tadbir haqida Ma'lumodlar",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Icon(Icons.arrow_downward_outlined),
                  // SizedBox(width: 8),
                ],
              ),
              Container(
                height: 200,
                width: 400,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                    width: 2.0,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                      widget.event.description ?? "No description available."),
                ),
              ),

              SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            BookingScreen(event: widget.event),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  ),
                  child:
                      Text("Ro'yxatdan O'tish", style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
