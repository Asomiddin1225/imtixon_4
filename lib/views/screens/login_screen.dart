import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:imtixon_4/services/firebase_auth_service.dart';
import 'home_screns.dart';
import 'register_screen.dart';
import 'package:imtixon_4/views/widgets/helpers.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void submit() async {
    if (nameController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty) {
      try {
     final user=   await context.read<FirebaseAuthService>().login(
              emailController.text,
              passwordController.text,
            );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreens(
            
              email: emailController.text,
              name: nameController.text, 
              id: user!.uid,
            ),
          ),
        );
      } on FirebaseAuthException catch (error) {
        TestHelpers.showErrorDialog(context, error.message ?? "Xatolik");
      } catch (e) {
        TestHelpers.showErrorDialog(context, "Tizimda xatolik");
      }
    } else {
      TestHelpers.showErrorDialog(context, "Ism, email va parolni kiriting");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/logotadbir.png', height: 150),
                const SizedBox(height: 20),
                const Text(
                  "Tadbir",
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Tizimga kirish",
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    filled: true,
                    border: const OutlineInputBorder(),
                    labelText: "Ism",
                    labelStyle:
                        const TextStyle(color: Colors.orange, fontSize: 25),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    filled: true,
                    border: const OutlineInputBorder(),
                    labelText: "Email",
                    labelStyle:
                        const TextStyle(color: Colors.orange, fontSize: 25),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    filled: true,
                    border: const OutlineInputBorder(),
                    labelText: "Parol",
                    labelStyle:
                        const TextStyle(color: Colors.orange, fontSize: 25),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: submit,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      "Kirish",
                      style: TextStyle(color: Colors.orange, fontSize: 20),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (ctx) => const RegisterScreen()),
                    );
                  },
                  child: const Text("Ro'yxatdan O'tish",
                      style: TextStyle(color: Colors.orange, fontSize: 20)),
                ),
              ],
            ),
          )),
    );
  }
}
