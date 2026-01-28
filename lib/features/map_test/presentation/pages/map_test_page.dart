import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapTestPage extends StatefulWidget {
  const MapTestPage({super.key});

  @override
  State<MapTestPage> createState() => _MapTestPageState();
}

class _MapTestPageState extends State<MapTestPage> {
  static const CameraPosition _initialCameraPosition = CameraPosition(
    target: LatLng(30.0444, 31.2357), // Example: Cairo
    zoom: 14,
  );

  GoogleMapController? _mapController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Google Maps Test')),
      body: GoogleMap(
        initialCameraPosition: _initialCameraPosition,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        onMapCreated: (controller) {
          _mapController = controller;
        },
      ),
    );
  }
}
