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
import 'package:shared_preferences/shared_preferences.dart';
import 'package:latlong2/latlong.dart' as latLng2;
import '/custom_code/widgets/location_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

class CurrentNextPrayerWidget extends StatefulWidget {
  const CurrentNextPrayerWidget({
    super.key,
    this.width,
    this.height,
  });

  final double? width;
  final double? height;

  @override
  State<CurrentNextPrayerWidget> createState() =>
      _CurrentNextPrayerWidgetState();
}

class _CurrentNextPrayerWidgetState extends State<CurrentNextPrayerWidget> {
  PrayerTimes? prayerTimes;
  String? currentPrayer;
  String? nextPrayer;
  DateTime? currentPrayerTime;
  DateTime? nextPrayerTime;
  String? timeUntilNextPrayer;
  SunnahInsights? sunnahInsights;

  @override
  void initState() {
    super.initState();
    _calculatePrayerTimes();
    _startPrayerCountdown();
  }

  String _capitalizeFirstLetter(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  void _calculatePrayerTimes() async {
    // Get the SharedPreferences instance
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Retrieve latitude, longitude, and timezone from SharedPreferences
    double? latitude = prefs.getDouble('cachedLatitude');
    double? longitude = prefs.getDouble('cachedLongitude');
    String? timezone = prefs.getString('cachedTimezone');

    // Check if the values are available
    if (latitude == null || longitude == null || timezone == null) {
      print("Location or timezone not found in SharedPreferences");
      return;
    }
    // Define geographical coordinates
    Coordinates coordinates = Coordinates(latitude, longitude);

    // Specify the calculation parameters for prayer times
    PrayerCalculationParameters params = PrayerCalculationMethod.northAmerica();
    params.madhab = PrayerMadhab.shafi;

    // Create a PrayerTimes instance for the specified location
    prayerTimes = PrayerTimes(
      coordinates: coordinates,
      calculationParameters: params,
      precision: true,
      locationName: timezone,
    );
    sunnahInsights = SunnahInsights(prayerTimes!);

    DateTime now = DateTime.now();

    if (now.isAfter(sunnahInsights!.lastThirdOfTheNight) &&
        now.isBefore(prayerTimes!.fajrStartTime!)) {
      currentPrayer = 'Tahajud';
      nextPrayer = 'Fajr';
      currentPrayerTime = sunnahInsights!.lastThirdOfTheNight;
      nextPrayerTime = prayerTimes!.fajrStartTime!;

      ///
    } else if (now.isAfter(prayerTimes!.fajrStartTime!) &&
        now.isBefore(prayerTimes!.sunrise!)) {
      currentPrayer = 'Fajr';
      nextPrayer = 'Duha';
      currentPrayerTime = prayerTimes!.fajrStartTime!;
      nextPrayerTime = prayerTimes!.sunrise!.add(Duration(minutes: 15));

      ///
    } else if (now.isAfter(prayerTimes!.sunrise!.add(Duration(minutes: 15))) &&
        now.isBefore(prayerTimes!.dhuhrStartTime!)) {
      currentPrayer = 'Duha';
      nextPrayer = 'dhuhr';
      currentPrayerTime = prayerTimes!.sunrise!.add(Duration(minutes: 15));
      nextPrayerTime = prayerTimes!.dhuhrStartTime!;

      ///
    } else if (now.isAfter(prayerTimes!.ishaStartTime!) &&
        now.isBefore(sunnahInsights!.lastThirdOfTheNight)) {
      currentPrayer = 'Isha';
      nextPrayer = 'Tahajud';
      currentPrayerTime = prayerTimes!.ishaStartTime!;
      nextPrayerTime = sunnahInsights!.lastThirdOfTheNight;

      ///
    } else {
      currentPrayer = prayerTimes!.currentPrayer();
      nextPrayer = prayerTimes!.nextPrayer();
      currentPrayerTime = prayerTimes!.timeForPrayer(currentPrayer!);
      nextPrayerTime = prayerTimes!.timeForPrayer(nextPrayer!);
    }
    nextPrayer = _capitalizeFirstLetter(nextPrayer!);
    _updateTimeUntilNextPrayer(); // Update the countdown

    setState(() {});
  }

  void _startPrayerCountdown() {
    // Recalculate the time until the next prayer every second
    Future.delayed(Duration(seconds: 1), () {
      _calculatePrayerTimes();
      _startPrayerCountdown();
    });
  }

  void _updateTimeUntilNextPrayer() {
    if (nextPrayerTime != null) {
      Duration timeDifference = nextPrayerTime!.difference(DateTime.now());

      if (timeDifference.isNegative) {
        // Recalculate next prayer, this should prevent negative countdowns
        _calculatePrayerTimes();
      } else {
        int hours = timeDifference.inHours;
        int minutes = timeDifference.inMinutes % 60;
        int seconds = timeDifference.inSeconds % 60;

        List<String> parts = [];

        if (hours > 0) {
          parts.add('$hours ${hours == 1 ? 'hour' : 'hours'}');
        }
        if (minutes > 0) {
          parts.add('$minutes ${minutes == 1 ? 'minute' : 'minutes'}');
        }
        if (seconds > 0) {
          parts.add('$seconds ${seconds == 1 ? 'second' : 'seconds'}');
        }

        timeUntilNextPrayer =
            parts.join(', '); // Join the non-empty parts with commas

        setState(() {}); // Update the UI
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      padding: const EdgeInsets.all(5),
      color: Colors.white,
      child: prayerTimes == null
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${nextPrayer ?? 'N/A'} starts in:',
                    style: FlutterFlowTheme.of(context)
                        .bodyMedium
                        .copyWith(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    timeUntilNextPrayer ?? 'Calculating...',
                    style: FlutterFlowTheme.of(context)
                        .bodyMedium
                        .copyWith(fontSize: 16),
                  ),
                ],
              ),
            ),
    );
  }
}
