import 'package:flutter/material.dart';
import 'package:imtixon_4/services/firebase_auth_service.dart';
import 'package:imtixon_4/views/widgets/helpers.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmationController = TextEditingController();

  void submit() async {
    if (emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        passwordConfirmationController.text.isNotEmpty &&
        passwordController.text == passwordConfirmationController.text) {
      try {
        User? user = await context.read<FirebaseAuthService>().register(
              emailController.text,
              passwordController.text,
            );
        if (user != null) {
          Navigator.pop(context);
        } else {
          TestHelpers.showErrorDialog(context, "Ro'yxatdan o'tishda xatolik");
        }
      } on FirebaseAuthException catch (error) {
        TestHelpers.showErrorDialog(context, error.message ?? "Xatolik");
      } catch (e) {
        TestHelpers.showErrorDialog(context, "Tizimda xatolik");
      }
    } else {
      TestHelpers.showErrorDialog(context, "Parollar bir xil bo'lishi kerak");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
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
              "Ro'yxatdan O'tish",
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                filled: true,
                border: OutlineInputBorder(),
                labelText: "Email",
                labelStyle: const TextStyle(color: Colors.orange, fontSize: 18),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                filled: true,
                border: OutlineInputBorder(),
                labelText: "Parol",
                labelStyle: const TextStyle(color: Colors.orange, fontSize: 18),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: passwordConfirmationController,
              decoration: InputDecoration(
                filled: true,
                border: OutlineInputBorder(),
                labelText: "Parolni tasdiqlash",
                labelStyle: const TextStyle(color: Colors.orange, fontSize: 18),
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
                child: const Text("Ro'yxatdan O'tish"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
