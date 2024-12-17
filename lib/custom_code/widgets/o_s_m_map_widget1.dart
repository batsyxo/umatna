// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/backend/schema/enums/enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:latlong2/latlong.dart' as latLng2;
import 'package:flutter_map/flutter_map.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';

class OSMMapWidget1 extends StatefulWidget {
  const OSMMapWidget1({
    super.key,
    this.width,
    this.height,
  });

  final double? width;
  final double? height;

  @override
  State<OSMMapWidget1> createState() => _OSMMapWidget1State();
}

class _OSMMapWidget1State extends State<OSMMapWidget1> {
  bool showMosques = false;
  List<Marker> mosqueMarkers = [];
  latLng2.LatLng? userLocation;
  Future<latLng2.LatLng?>? _locationFuture;

  @override
  void initState() {
    super.initState();
    _locationFuture = _getCurrentLocation();
    fetchMosques();
  }

  Future<latLng2.LatLng?> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception("Location services are disabled.");
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception("Location permission denied.");
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception("Location permission denied forever.");
      }

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      userLocation = latLng2.LatLng(position.latitude, position.longitude);
      _trackLocationUpdates();

      return userLocation;
    } catch (e) {
      print("Error getting location: $e");
      return null;
    }
  }

  void _trackLocationUpdates() {
    Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    ).listen((Position position) {
      setState(() {
        userLocation = latLng2.LatLng(position.latitude, position.longitude);
      });
    });
  }

  Future<void> fetchMosques() async {
    try {
      final mosquesCollection =
          FirebaseFirestore.instance.collection('mosques');
      final querySnapshot = await mosquesCollection.get();

      setState(() {
        mosqueMarkers = querySnapshot.docs.map((doc) {
          final data = doc.data();
          final latitude = data['latitude'] as double;
          final longitude = data['longitude'] as double;
          final name = data['name'] as String;

          return Marker(
            point: latLng2.LatLng(latitude, longitude),
            width: 30,
            height: 30,
            child: Tooltip(
              message: name,
              child: Icon(
                Icons.place,
                color: Colors.green,
                size: 30.0,
              ),
            ),
          );
        }).toList();
      });
    } catch (e) {
      print("Error fetching mosques: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<latLng2.LatLng?>(
      future: _locationFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError || !snapshot.hasData) {
          return Center(
              child: Text('Failed to get location or permission denied.'));
        }

        latLng2.LatLng? userLocation = snapshot.data;

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Show Mosques',
                    style: FlutterFlowTheme.of(context).bodyMedium,
                  ),
                  Switch(
                    value: showMosques,
                    onChanged: (value) {
                      setState(() {
                        showMosques = value;
                      });
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: FlutterMap(
                options: MapOptions(
                  initialCenter:
                      userLocation ?? latLng2.LatLng(43.255203, -79.843826),
                  initialZoom: 9.2,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.app',
                    maxNativeZoom: 19,
                  ),
                  if (showMosques) MarkerLayer(markers: mosqueMarkers),
                  if (userLocation != null)
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: userLocation,
                          width: 30,
                          height: 30,
                          child: Icon(
                            Icons.my_location,
                            color: Colors.blue,
                            size: 30.0,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
