import 'package:flutter/material.dart';

class ProfileEditScreen extends StatefulWidget {
  final String email;
  final String name;

  const ProfileEditScreen({super.key, required this.email, required this.name});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();

  @override
  void initState() {
    super.initState();

    nameController.text = widget.name;
    emailController.text = widget.email;
  }

  void saveProfile() {
    Navigator.pop(context, {
      'name': nameController.text,
      'email': emailController.text,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profil Ma'lumotlari"),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Ism'),
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: saveProfile,
              child: Text('Saqlash'),
            ),
          ],
        ),
      ),
    );
  }
}
