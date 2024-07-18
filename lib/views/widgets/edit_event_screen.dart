import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:imtixon_4/models/event.dart';
import 'package:imtixon_4/services/firebase_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:imtixon_4/views/widgets/google_map.dart';

class EditEventScreen extends StatefulWidget {
  final Event event;

  EditEventScreen({required this.event});

  @override
  _EditEventScreenState createState() => _EditEventScreenState();
}

class _EditEventScreenState extends State<EditEventScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _dateController;
  late TextEditingController _timeController;
  late TextEditingController _descriptionController;
  late TextEditingController _locationController;
  late TextEditingController _userIdController;
  String? _imageUrl;
  LatLng? _pickedLocation;

  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.event.name);
    _dateController = TextEditingController(text: widget.event.date);
    _timeController = TextEditingController(text: widget.event.time);
    _descriptionController =
        TextEditingController(text: widget.event.description);
    _imageUrl = widget.event.imageUrl;
    _locationController = TextEditingController(text: widget.event.location);
    _userIdController = TextEditingController(text: widget.event.userId);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _userIdController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = pickedFile;
    });
  }

  Future<void> _pickCameraImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      _imageFile = pickedFile;
    });
  }

  Future<void> _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.parse(widget.event.date),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        _dateController.text =
            '${pickedDate.year}-${pickedDate.month}-${pickedDate.day}';
      });
    }
  }

  Future<void> _pickTime() async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(
        hour: int.parse(widget.event.time.split(":")[0]),
        minute: int.parse(widget.event.time.split(":")[1]),
      ),
    );
    if (pickedTime != null) {
      setState(() {
        _timeController.text = pickedTime.format(context);
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
        _locationController.text = '${result.latitude}, ${result.longitude}';
      });
    }
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Event updatedEvent = Event(
        id: widget.event.id,
        name: _nameController.text,
        date: _dateController.text,
        time: _timeController.text,
        description: _descriptionController.text,
        imageUrl: _imageUrl ?? widget.event.imageUrl,
        location: _locationController.text,
        userId: _userIdController.text,
      );
      await Provider.of<FirebaseService>(context, listen: false).updateEvent(
          updatedEvent, _imageFile != null ? File(_imageFile!.path) : null);
      Navigator.pop(context, true);

     Future.delayed(Duration.zero, () async {
      await context.read<FirebaseService>().getUserEvents();
    });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Event'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Nomi'),
                  validator: (value) =>
                      value!.isEmpty ? 'Ismni kiriting' : null,
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _dateController,
                        decoration: InputDecoration(labelText: 'Kuni'),
                        readOnly: true,
                        onTap: _pickDate,
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
                        controller: _timeController,
                        decoration: InputDecoration(labelText: 'Vaqti'),
                        readOnly: true,
                        onTap: _pickTime,
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
                  controller: _descriptionController,
                  decoration: InputDecoration(labelText: 'Tafsiya'),
                  onSaved: (value) => _descriptionController.text = value!,
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
                        : _imageUrl != null
                            ? Image.network(
                                _imageUrl!,
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
                        controller: _locationController,
                        decoration:
                            InputDecoration(labelText: 'Event Location'),
                        readOnly: true,
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
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submit,
                  child: Text("Saqlash"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
