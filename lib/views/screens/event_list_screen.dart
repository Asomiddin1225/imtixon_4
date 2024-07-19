import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
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

// EventListScreen uchun holatni boshqaradi
class _EventListScreenState extends State<EventListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  //  dastlabki sozlamalarni amalga oshiradi
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    // FirebaseService orqali foydalanuvchi tadbirlarini olish
    Future.delayed(Duration.zero, () async {
      await context.read<FirebaseService>().getUserEvents();
    });
  }

  // tadbirlarni berilgan filtrga qarab ajratib beradi
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
        title: Text('My events'.tr()),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Main'.tr()),
            Tab(text: 'Recently'.tr()),
            Tab(text: 'Participated'.tr()),
            Tab(text: 'cancelled'.tr()),
          ],
        ),
      ),
      //  FirebaseService orqali tadbirlarni yuklash
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
                buildEventList(filterEvents(snapshot.data!, 'Main'.tr())),
                buildEventList(filterEvents(snapshot.data!, 'Recently'.tr())),
                buildEventList(
                    filterEvents(snapshot.data!, 'Participated'.tr())),
                buildEventList(filterEvents(snapshot.data!, 'cancelled'.tr())),
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

  //  tadbirlar ro'yxatini yaratadi
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
              //  tadbirni tahrirlash, o'chirish yoki bekor qilish uchun
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
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  //  - tadbirni bekor qilish
  Future<void> cancelEvent(Event event) async {
    event.isCancelled = true;
    await Provider.of<FirebaseService>(context, listen: false)
        .updateEvent(event.id as Event, event as File?);
    setState(() {}); // UI ni yangilash uchun
  }
}
