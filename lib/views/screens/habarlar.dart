import 'package:flutter/material.dart';

class HabarScreen extends StatefulWidget {
  const HabarScreen({super.key});

  @override
  State<HabarScreen> createState() => _HabarScreenState();
}

class _HabarScreenState extends State<HabarScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("Habar yo'q"),),
    );
  }
}