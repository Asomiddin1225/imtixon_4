import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _controller;
  LatLng _initialPosition = LatLng(37.77483, -122.41942); // Default position
  LatLng? _pickedPosition;

  void _onMapCreated(GoogleMapController controller) {
    _controller = controller;
  }

  void _onTap(LatLng position) {
    setState(() {
      _pickedPosition = position;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Joylashuvni tanlash'),
        actions: [
          TextButton(
            onPressed: _pickedPosition == null
                ? null
                : () {
                    Navigator.pop(context, _pickedPosition);
                  },
            child: Text(
              'Tanlash',
              style: TextStyle(
                  color: _pickedPosition == null ? Colors.green : Colors.red),
            ),
          ),
        ],
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _initialPosition,
          zoom: 10.0,
        ),
        onTap: _onTap,
        markers: _pickedPosition == null
            ? {}
            : {
                Marker(
                  markerId: MarkerId('picked-location'),
                  position: _pickedPosition!,
                ),
              },
      ),
    );
  }
}
