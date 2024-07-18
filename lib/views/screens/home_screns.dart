import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:imtixon_4/models/event.dart';
import 'package:imtixon_4/services/firebase_service.dart';
import 'package:imtixon_4/views/screens/habarlar.dart';
import 'package:imtixon_4/views/widgets/drawer.dart';
import 'package:imtixon_4/views/widgets/event_list_widget.dart';

class HomeScreens extends StatefulWidget {
  final String email;
  final String name;
  final String id;

  const HomeScreens({
    Key? key,
    required this.email,
    required this.name,
    required this.id,
  }) : super(key: key);

  @override
  State<HomeScreens> createState() => _HomeScreensState();
}

class _HomeScreensState extends State<HomeScreens> {
  TextEditingController _searchController = TextEditingController();
  String filterType = 'name';
  FirebaseService _firebaseService = FirebaseService();

  Future<List<Event>>? _eventsFuture;

  @override
  void initState() {
    super.initState();
    _eventsFuture = _firebaseService.getUserEvents();
  }

  void _searchEvents() {
    setState(() {
      if (filterType == 'name') {
        _eventsFuture =
            _firebaseService.searchEventsByName(_searchController.text);
      } else {
        _eventsFuture =
            _firebaseService.searchEventsByLocation(_searchController.text);
      }
    });
  }

  void _clearSearch() {
    setState(() {
      _searchController.clear();
      _eventsFuture = _firebaseService.getUserEvents();
    });
  }

  void _filterEventsWithin7Days() {
    setState(() {
      _eventsFuture = _firebaseService.getEventsWithin7Days();
    });
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Filter Options'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('By event name'.tr()),
                leading: Radio(
                  value: 'name',
                  groupValue: filterType,
                  onChanged: (value) {
                    setState(() {
                      filterType = value.toString();
                      _searchEvents();
                    });
                    Navigator.of(context).pop();
                  },
                ),
              ),
              ListTile(
                title: Text('Manzil bo\'yicha'),
                leading: Radio(
                  value: 'location',
                  groupValue: filterType,
                  onChanged: (value) {
                    setState(() {
                      filterType = value.toString();
                      _searchEvents();
                    });
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        centerTitle: true,
        title: Text(
          "Bosh Sahifa",
          style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HabarScreen()),
                  );
                },
                icon: Icon(
                  Icons.notifications_none,
                  size: 30,
                )),
          ),
        ],
      ),
      drawer: MyDrawer(
        email: widget.email,
        name: widget.name,
        id: widget.id,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Tadbirlarni izlash...',
                prefixIcon: Icon(Icons.search),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.filter_list),
                      onPressed: _showFilterDialog,
                    ),
                    IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: _clearSearch,
                    ),
                  ],
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchEvents();
                });
              },
            ),
            SizedBox(height: 10),
            Expanded(
              // child:
              child: EventListWidget(eventsFuture: _eventsFuture!),
            ),
          ],
        ),
      ),
    );
  }
}
