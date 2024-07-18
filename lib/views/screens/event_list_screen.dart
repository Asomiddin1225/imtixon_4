import 'dart:io';
import 'package:flutter/material.dart';
import 'package:imtixon_4/models/event.dart';
import 'package:imtixon_4/services/firebase_service.dart';
import 'package:imtixon_4/views/widgets/add_event_screen.dart';
import 'package:imtixon_4/views/widgets/edit_event_screen.dart';
import 'package:provider/provider.dart';

class EventListScreen extends StatefulWidget {
  @override
  _EventListScreenState createState() => _EventListScreenState();
}

class _EventListScreenState extends State<EventListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    Future.delayed(Duration.zero, () async {
      await context.read<FirebaseService>().getUserEvents();
    });
  }

  List<Event> filterEvents(List<Event> events, String filter) {
    final now = DateTime.now();
    if (filter == 'Asosiy') {
      return events;
    } else if (filter == 'Yaqinda') {
      return events.where((event) {
        try {
          final eventDate = DateTime.parse(event.date);
          return eventDate.isAfter(now) &&
              eventDate.isBefore(now.add(Duration(days: 7)));
        } catch (e) {
          print('Error parsing date: ${event.date}');
          return false;
        }
      }).toList();
    } else if (filter == 'Ishtirok etgan') {
      return events.where((event) {
        try {
          final eventDate = DateTime.parse(event.date);
          return eventDate.isBefore(now);
        } catch (e) {
          print('Error parsing date: ${event.date}');
          return false;
        }
      }).toList();
    } else if (filter == 'Bekor qilingan') {
      return events.where((event) => event.isCancelled).toList();
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mening tadbirlarim'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Asosiy'),
            Tab(text: 'Yaqinda'),
            Tab(text: 'Ishtirok etgan'),
            Tab(text: 'Bekor qilgan'),
          ],
        ),
      ),
      body: FutureBuilder<List<Event>>(
        future: Provider.of<FirebaseService>(context).getUserEvents(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Xatolik yuz berdi'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("Tadbirlar yo'q"));
          } else {
            return TabBarView(
              controller: _tabController,
              children: [
                buildEventList(filterEvents(snapshot.data!, 'Asosiy')),
                buildEventList(filterEvents(snapshot.data!, 'Yaqinda')),
                buildEventList(filterEvents(snapshot.data!, 'Ishtirok etgan')),
                buildEventList(filterEvents(snapshot.data!, 'Bekor qilingan')),
              ],
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddEventScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget buildEventList(List<Event> events) {
    return ListView.builder(
      itemCount: events.length,
      itemBuilder: (context, index) {
        Event event = events[index];
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            elevation: 5,
            child: ListTile(
              contentPadding: EdgeInsets.all(10),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Image.network(
                  event.imageUrl,
                  width: 100,
                  height: 150,
                  fit: BoxFit.cover,
                ),
              ),
              title: Text(
                event.name,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 5),
                  Text(
                    '${event.date} ${event.time}',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    event.location,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
              trailing: PopupMenuButton<String>(
                onSelected: (value) async {
                  if (value == 'edit') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditEventScreen(event: event),
                      ),
                    );
                  } else if (value == 'delete') {
                    await Provider.of<FirebaseService>(context, listen: false)
                        .deleteEvent(event.id);
                  } else if (value == 'cancel') {
                    await cancelEvent(event);
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'edit',
                    child: Text('Tahrirlash'),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Text("O'chirish"),
                  ),
                  PopupMenuItem(
                    value: 'cancel',
                    child: Text("Bekor qilish"),
                  ),
                  PopupMenuItem(
                    value: 'cancel',
                    child: Text("Ishtirok"),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> cancelEvent(Event event) async {
    event.isCancelled = true;
    await Provider.of<FirebaseService>(context, listen: false)
        .updateEvent(event.id as Event, event as File?);
    setState(() {}); // To refresh the UI
  }
}
