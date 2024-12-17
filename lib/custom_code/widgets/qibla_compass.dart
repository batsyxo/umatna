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

import 'index.dart'; // Imports other custom widgets

import 'index.dart'; // Imports other custom widgets

import 'index.dart'; // Imports other custom widgets

import 'package:prayers_times/prayers_times.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:latlong2/latlong.dart' as latLng2;
import 'package:flutter_map/flutter_map.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lat_lng_to_timezone/lat_lng_to_timezone.dart' as tzmap;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math' as math;

class QiblaCompass extends StatefulWidget {
  const QiblaCompass({
    super.key,
    this.width,
    this.height,
  });

  final double? width;
  final double? height;

  @override
  State<QiblaCompass> createState() => _QiblaCompassState();
}

class _QiblaCompassState extends State<QiblaCompass> {
  double? qiblaDirection;
  double? currentHeading;

  @override
  void initState() {
    super.initState();
    _calculateQiblaFromStoredLocation();
    _startCompass();
  }

  Future<void> _calculateQiblaFromStoredLocation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    double? latitude = prefs.getDouble('cachedLatitude');
    double? longitude = prefs.getDouble('cachedLongitude');

    if (latitude != null && longitude != null) {
      Coordinates coordinates = Coordinates(latitude, longitude);

      setState(() {
        qiblaDirection = Qibla.qibla(coordinates);
      });
    } else {
      print("Location data not found in SharedPreferences.");
    }
  }

  void _startCompass() {
    FlutterCompass.events?.listen((CompassEvent event) {
      setState(() {
        currentHeading = event.heading;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double? difference;
    Color glowColor = Colors.red;

    if (qiblaDirection != null && currentHeading != null) {
      difference = (qiblaDirection! - currentHeading! + 180) % 360 - 180;
      double absDifference = difference.abs();

      if (absDifference <= 10) {
        glowColor = const Color.fromARGB(255, 76, 175, 102);
      } else if (absDifference <= 45) {
        glowColor = const Color.fromARGB(255, 255, 206, 59);
      } else {
        glowColor = const Color.fromARGB(255, 229, 117, 109);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Qibla Compass'),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/kaaba_pic_3.png',
              fit: BoxFit.cover,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: glowColor.withOpacity(0.7),
                      blurRadius: 15,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Transform.rotate(
                  angle: (((qiblaDirection ?? 0) - (currentHeading ?? 0)) *
                              (math.pi / 180) +
                          math.pi)
                      .toDouble(), // Starts upside down with math.pi
                  child: Image.asset(
                    'assets/images/mecca_pin1.png',
                    width: 100, // Adjust the size of the image
                    height: 100, // Adjust the size of the image
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
