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

import 'package:prayers_times/prayers_times.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:latlong2/latlong.dart' as latLng2;
import '/custom_code/widgets/location_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz; // Timezone package for Dart
import 'package:timezone/data/latest.dart'
    as tz_data; // Initialize the timezone database

class PrayerTimeWidget extends StatefulWidget {
  const PrayerTimeWidget({
    super.key,
    this.width,
    this.height,
    required this.prayerTimeName, // Add prayerTimeName parameter
  });

  final double? width;
  final double? height;
  final String prayerTimeName; // Prayer time name (e.g., "Fajr", "Dhuhr", etc.)

  @override
  State<PrayerTimeWidget> createState() => _PrayerTimeWidgetState();
}

class _PrayerTimeWidgetState extends State<PrayerTimeWidget> {
  PrayerTimes? prayerTimes;
  SunnahInsights? sunnahInsights;

  @override
  void initState() {
    super.initState();
    _calculatePrayerTimes();
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
    // Define the geographical coordinates from AppState
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

    // Create Sunnah Insights instance to calculate Sunnah times like Tahajud
    sunnahInsights = SunnahInsights(prayerTimes!);

    // Update the state to reflect the calculated times
    setState(() {});
  }

  DateTime? getPrayerTime() {
    if (prayerTimes == null) return null;

    switch (widget.prayerTimeName.toLowerCase()) {
      case 'fajr':
        return prayerTimes!.fajrStartTime!;
      case 'dhuhr':
        return prayerTimes!.dhuhrStartTime!;
      case 'asr':
        return prayerTimes!.asrStartTime!;
      case 'maghrib':
        return prayerTimes!.maghribStartTime!;
      case 'isha':
        return prayerTimes!.ishaStartTime!;
      case 'sunrise':
        return prayerTimes!.sunrise!;
      case 'tahajud':
        return sunnahInsights!.lastThirdOfTheNight;
      case 'duha': // Duha case (15 minutes after sunrise)
        return prayerTimes!.sunrise?.add(Duration(minutes: 15));
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime? prayerTime = getPrayerTime();

    return Container(
      width: widget.width,
      height: widget.height,
      padding: EdgeInsets.all(0),
      color: Colors.white,
      child: prayerTimes == null
          ? Center(child: CircularProgressIndicator())
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    '${prayerTime != null ? DateFormat.jm().format(prayerTime) : 'N/A'}'),
              ],
            ),
    );
  }
}
