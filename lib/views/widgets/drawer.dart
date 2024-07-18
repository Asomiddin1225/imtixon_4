import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:imtixon_4/views/screens/event_list_screen.dart';
import 'package:imtixon_4/views/screens/login_screen.dart';
import 'package:imtixon_4/views/widgets/change_language.dart';
import 'package:imtixon_4/views/widgets/kun_tun.dart';
import 'package:imtixon_4/views/widgets/profil_screen.dart';

class MyDrawer extends StatefulWidget {
  final String email;
  final String name;
  final String id;

  // MyDrawers({required this.id});

  MyDrawer(
      {super.key, required this.email, required this.name, required this.id});

  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  late String name;
  late String email;

  @override
  void initState() {
    super.initState();
    name = widget.name;
    email = widget.email;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: Colors.orange,
            ),
            currentAccountPicture: CircleAvatar(
              backgroundImage: AssetImage('assets/logotadbir.png'),
            ),
            accountName: Text(
              name,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            accountEmail: Text(
              email,
              style: TextStyle(color: Colors.white70),
            ),
            onDetailsPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileEditScreen(
                    email: email,
                    name: name,
                  ),
                ),
              );
              if (result != null) {
                setState(() {
                  name = result['name'];
                  email = result['email'];
                });
              }
            },
          ),
          ListTile(
            title: Row(
              children: [
                Text('My events'.tr()),
                Spacer(),
                Icon(Icons.event),
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EventListScreen()),
              );
            },
          ),
          ListTile(
            title: Row(
              children: [
                Text("Profile Information".tr()),
                Spacer(),
                Icon(Icons.person),
              ],
            ),
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileEditScreen(
                    email: email,
                    name: name,
                  ),
                ),
              );
              if (result != null) {
                setState(() {
                  name = result['name'];
                  email = result['email'];
                });
              }
            },
          ),
          ListTile(
            title: Row(
              children: [
                Text("Change the language".tr()),
                Spacer(),
                Icon(Icons.language),
              ],
            ),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return ChangeLanguageScreen();
              }));
            },
          ),
          ListTile(
            title: Row(
              children: [
                Text('Night/Day mode'.tr()),
                Spacer(),
                Icon(Icons.nightlight_round),
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage()),
              );
            },
          ),
          ListTile(
            title: Row(
              children: [
                Text('Exit'.tr()),
                Spacer(),
                Icon(Icons.logout, color: Colors.red),
              ],
            ),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}



/* MyEvents()  ga o'tganda  ko'rsadsin  manshu dasturga kirish user kirtgan 
tadbirlarni fail besdan olib kirib  agar boshqa user tadbir kirtgan bo'lsa uni tadbirlari ko'rinmasin 
boshqa user bilan kirsa shu user kirtgan tadbir ko'rinsin. dadbirlarni o'chirish o'zgartirish imkoni bo'lsin 1-rasm dek va ishtrok etgan qilish bekor qilingan qish imkoni bo'lsin  
  Add icon bosganda Failbesga tadbir qo'shsin  
2-rasimdek  Tadbir nomi, datatim bilan kuni  vaxri   Image icon bossa galeradan rasiolib shuni , 
camera icon bossa cameradan rasim olib shuni   va haritadan  locatsiya icon bilan manzil tanlasin va shumanzilni qo'shni .2-rasm dek 
fayilarni aloxida yoz*/