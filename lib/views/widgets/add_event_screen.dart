import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:imtixon_4/models/event.dart';
import 'package:imtixon_4/services/firebase_service.dart';
import 'package:imtixon_4/views/widgets/google_map.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddEventScreen extends StatefulWidget {
  @override
  _AddEventScreenState createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _date = '';
  String _time = '';
  String _description = '';
  String _imageUrl = '';
  String _location = '';
  LatLng? _pickedLocation;

  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;

  void _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = pickedFile;
    });
  }

  void _pickCameraImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      _imageFile = pickedFile;
    });
  }

  Future<void> _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        _date = '${pickedDate.year}-${pickedDate.month}-${pickedDate.day}';
      });
    }
  }

  Future<void> _pickTime() async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        _time = pickedTime.format(context);
      });
    }
  }

  Future<void> _pickLocation() async {
    final result = await Navigator.push<LatLng>(
      context,
      MaterialPageRoute(builder: (context) => MapScreen()),
    );
    if (result != null) {
      setState(() {
        _pickedLocation = result;
        _location = '${result.latitude}, ${result.longitude}';
      });
    }
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (_imageFile != null) {
        User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          Event newEvent = Event(
            id: '',
            name: _name,
            date: _date,
            time: _time,
            description: _description,
            imageUrl: _imageUrl,
            location: _location,
            userId: user.uid,
          );
          await Provider.of<FirebaseService>(context, listen: false)
              .addEvent(newEvent, File(_imageFile!.path));
          // ignore: use_build_context_synchronously
          Navigator.pop(context);
        }
      }
    }

    Future.delayed(Duration.zero, (){
      context.read<FirebaseService>().getUserEvents();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Tadbir Qo'shish")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'Nomi'),
                  onSaved: (value) => _name = value!,
                  validator: (value) =>
                      value!.isEmpty ? 'Ismni kiriting' : null,
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(labelText: 'Kuni'),
                        readOnly: true,
                        onTap: _pickDate,
                        controller: TextEditingController(text: _date),
                        validator: (value) =>
                            value!.isEmpty ? 'Kunini kiriting' : null,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.calendar_today),
                      onPressed: _pickDate,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(labelText: 'Vaqti'),
                        readOnly: true,
                        onTap: _pickTime,
                        controller: TextEditingController(text: _time),
                        validator: (value) =>
                            value!.isEmpty ? 'Vaqtni kiriting' : null,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.access_time),
                      onPressed: _pickTime,
                    ),
                  ],
                ),
                TextFormField(
                  decoration:
                      InputDecoration(labelText: 'Tadbir haqida malumot'),
                  onSaved: (value) => _description = value!,
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.photo),
                      onPressed: _pickImage,
                    ),
                    IconButton(
                      icon: Icon(Icons.camera),
                      onPressed: _pickCameraImage,
                    ),
                    _imageFile != null
                        ? Image.file(
                            File(_imageFile!.path),
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          )
                        : Container(),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(labelText: 'Joylashuv'),
                        readOnly: true,
                        controller: TextEditingController(text: _location),
                        validator: (value) =>
                            value!.isEmpty ? 'Joylashuvni tanlang' : null,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.location_on),
                      onPressed: _pickLocation,
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: _submit,
                  child: Text("Qo'shish"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
