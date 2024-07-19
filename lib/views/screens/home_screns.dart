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
  TextEditingController _searchController =
      TextEditingController(); // Qidiruv uchun TextField kontrolleri
  String filterType = 'name'; // Filtr turi ('name' yoki 'location')
  FirebaseService _firebaseService =
      FirebaseService(); // Firebase xizmatlari uchun obyekt

  Future<List<Event>>?
      _eventsFuture; // Tadbirlar ro'yxati uchun kelajakdagi natija

  @override
  void initState() {
    super.initState();
    _eventsFuture =
        _firebaseService.getUserEvents(); // Foydalanuvchi tadbirlarini olish
  }

  void _searchEvents() {
    // Qidiruv funksiyasi
    setState(() {
      if (filterType == 'name') {
        _eventsFuture = _firebaseService.searchEventsByName(
            _searchController.text); // Tadbirlarni nomi bo'yicha qidirish
      } else {
        _eventsFuture = _firebaseService.searchEventsByLocation(
            _searchController.text); // Tadbirlarni joylashuvi bo'yicha qidirish
      }
    });
  }

  void _clearSearch() {
    // Qidiruvni tozalash funksiyasi
    setState(() {
      _searchController.clear();
      _eventsFuture = _firebaseService
          .getUserEvents(); // Foydalanuvchi tadbirlarini qayta yuklash
    });
  }

  // void _filterEventsWithin7Days() {
  //   // Keyingi 7 kun ichidagi tadbirlarni filtrlash funksiyasi
  //   setState(() {
  //     _eventsFuture = _firebaseService.getEventsWithin7Days();
  //   });
  // }

  void _showFilterDialog() {
    // Filtr dialogini ko'rsatish funksiyasi
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Filter Options'), // Dialog sarlavhasi
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('By event name'.tr()), // Tadbir nomi bo'yicha
                leading: Radio(
                  value: 'name',
                  groupValue: filterType,
                  onChanged: (value) {
                    setState(() {
                      filterType =
                          value.toString(); // Filtr turini o'zgartirish
                      _searchEvents(); // Qidiruvni qayta bajarish
                    });
                    Navigator.of(context).pop(); // Dialogni yopish
                  },
                ),
              ),
              ListTile(
                title: Text("Manzil bo'yicha"), // Tadbir joylashuvi bo'yicha
                leading: Radio(
                  value: 'location',
                  groupValue: filterType,
                  onChanged: (value) {
                    setState(() {
                      filterType =
                          value.toString(); // Filtr turini o'zgartirish
                      _searchEvents(); // Qidiruvni qayta bajarish
                    });
                    Navigator.of(context).pop(); // Dialogni yopish
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
          "Main page".tr(),
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
              controller: _searchController, // Qidiruv TextField kontrolleri
              decoration: InputDecoration(
                hintText: 'Search for events...'.tr(), // Qidiruv uchun matn
                prefixIcon: Icon(Icons.search),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.filter_list),
                      onPressed:
                          _showFilterDialog, // Filtr dialogini ko'rsatish
                    ),
                    IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: _clearSearch, // Qidiruvni tozalash
                    ),
                  ],
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchEvents(); // Qidiruvni bajarish
                });
              },
            ),
            SizedBox(height: 10),
            Expanded(
              child: EventListWidget(eventsFuture: _eventsFuture!),
            ),
          ],
        ),
      ),
    );
  }
}
