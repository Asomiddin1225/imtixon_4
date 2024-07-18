import 'package:flutter/material.dart';
import 'package:imtixon_4/models/event.dart';
import 'package:imtixon_4/views/screens/event_details_screen.dart';

class EventListWidget extends StatefulWidget {
  final Future<List<Event>> eventsFuture;

  const EventListWidget({Key? key, required this.eventsFuture})
      : super(key: key);

  @override
  _EventListWidgetState createState() => _EventListWidgetState();
}

class _EventListWidgetState extends State<EventListWidget> {
  final Set<String> _favoritedEvents = Set<String>();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Event>>(
      future: widget.eventsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No events found.'));
        } else {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              Event event = snapshot.data![index];
              final isFavorited = _favoritedEvents.contains(event.id);
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 5,
                child: ListTile(
                  title: Text(
                    "Nomi: ${event.name}",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Sana: ${event.date}',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Text('Joylashuv: ${event.location}'),
                    ],
                  ),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Image.network(
                      event.imageUrl,
                      width: 100,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                  ),
                  trailing: IconButton(
                    icon: Icon(
                        isFavorited ? Icons.favorite : Icons.favorite_border),
                    color: isFavorited ? Colors.red : null,
                    onPressed: () {
                      setState(() {
                        if (isFavorited) {
                          _favoritedEvents.remove(event.id);
                        } else {
                          _favoritedEvents.add(event.id);
                        }
                      });
                    },
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EventDetailsScreen(event: event),
                      ),
                    );
                  },
                ),
              );
            },
          );
        }
      },
    );
  }
}
