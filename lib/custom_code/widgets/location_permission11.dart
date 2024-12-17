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
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lat_lng_to_timezone/lat_lng_to_timezone.dart' as tzmap;
import 'package:shared_preferences/shared_preferences.dart';

class LocationPermission11 extends StatefulWidget {
  const LocationPermission11({
    super.key,
    this.width,
    this.height,
  });

  final double? width;
  final double? height;

  @override
  State<LocationPermission11> createState() => _LocationPermission11State();
}

class _LocationPermission11State extends State<LocationPermission11> {
  bool permissionGranted = false;
  bool permissionDenied = false;

  @override
  void initState() {
    super.initState();
    // Check permissions when returning from settings
    _checkPermissionAfterReturn();
  }

  Future<void> _checkPermissionAfterReturn() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      // If permission is now granted, fetch location
      await _fetchAndCacheLocation();
      setState(() {
        permissionGranted = true;
      });
    }
  }

  Future<void> _fetchAndCacheLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setDouble('cachedLatitude', position.latitude);
      await prefs.setDouble('cachedLongitude', position.longitude);
      // Cache timezone if needed
      String timezone =
          tzmap.latLngToTimezoneString(position.latitude, position.longitude);
      await prefs.setString('cachedTimezone', timezone);
      // Now that location is cached, you can proceed to the next screen
      context.pushReplacementNamed('Maps');
    } catch (e) {
      print('Error fetching location: $e');
    }
  }

  Future<void> requestLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      await _fetchAndCacheLocation();
      setState(() {
        permissionGranted = true;
      });
      // Navigate to the "Maps" page after permission is granted
      context.pushReplacementNamed('Maps');
    } else if (permission == LocationPermission.deniedForever) {
      // Permission denied forever, prompt user to go to settings
      _showSettingsDialog();
    } else {
      print("Location permission denied.");
      context.pushReplacementNamed('Maps');
    }
  }

  Future<void> denyLocationPermission() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('locationPermissionGranted', false);
    setState(() {
      permissionDenied = true;
    });
    print("Location access denied.");
    context.pushReplacementNamed('Maps');
  }

  // Show dialog to navigate to app settings
  Future<void> _showSettingsDialog() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Location Permission Required"),
        content: Text(
            "You have denied location access permanently. Please go to settings to enable it manually."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Geolocator.openAppSettings(); // Open app settings
            },
            child: Text("Go to Settings"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Location Permission'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: requestLocationPermission,
              child: Text("Allow Location Access"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: denyLocationPermission,
              child: Text("Deny Location Access"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
