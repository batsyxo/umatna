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

import 'package:jhijri/jHijri.dart';
import 'package:prayers_times/prayers_times.dart'; // Import your prayer times package
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async'; // Import for Timer

class HijriDateAndPrayer extends StatefulWidget {
  const HijriDateAndPrayer({
    super.key,
    this.width,
    this.height,
  });

  final double? width;
  final double? height;

  @override
  State<HijriDateAndPrayer> createState() => _HijriDateAndPrayerState();
}

class _HijriDateAndPrayerState extends State<HijriDateAndPrayer> {
  String hijriDate = '';
  String currentPrayer = '';
  String prayerTime = '';
  Timer? timer;

  @override
  void initState() {
    super.initState();
    _getHijriDate();
    _getCurrentPrayerAndTime();
    _startAutoUpdate(); // Start the timer to update the data periodically
  }

  @override
  void dispose() {
    timer?.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  void _getHijriDate() {
    final jhijri = JHijri.now();
    final String monthName =
        englishHMonth(jhijri.month); // English Hijri month name
    final int day = jhijri.day; // Hijri day number
    final int year = jhijri.year; // Hijri year

    setState(() {
      hijriDate = '$monthName $day $year AH';
    });
  }

  String _capitalizeFirstLetter(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  void _getCurrentPrayerAndTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    double? latitude = prefs.getDouble('cachedLatitude');
    double? longitude = prefs.getDouble('cachedLongitude');
    String? timezone = prefs.getString('cachedTimezone');

    if (latitude == null || longitude == null || timezone == null) {
      print("Location or timezone not found in SharedPreferences");
      return;
    }

    Coordinates coordinates = Coordinates(latitude, longitude);
    PrayerCalculationParameters params = PrayerCalculationMethod.northAmerica();
    params.madhab = PrayerMadhab.shafi;

    PrayerTimes prayerTimes = PrayerTimes(
      coordinates: coordinates,
      calculationParameters: params,
      precision: true,
      locationName: timezone,
    );

    DateTime now = DateTime.now();
    DateTime? currentPrayerTime;
    SunnahInsights sunnahInsights = SunnahInsights(prayerTimes);

    if (now.isBefore(prayerTimes.dhuhrStartTime!) &&
        now.isAfter(prayerTimes.sunrise!.add(Duration(minutes: 15)))) {
      currentPrayer = 'Duha';
      currentPrayerTime = prayerTimes.sunrise!.add(Duration(minutes: 15));
    } else if (now.isAfter(prayerTimes.sunrise!) &&
        now.isBefore(prayerTimes.sunrise!.add(Duration(minutes: 15)))) {
      currentPrayer = 'Sunrise';
      currentPrayerTime = prayerTimes.sunrise!;
    } else if (now.isAfter(sunnahInsights.lastThirdOfTheNight) &&
        now.isBefore(prayerTimes.fajrStartTime!)) {
      currentPrayer = 'Tahajud';
      currentPrayerTime = sunnahInsights.lastThirdOfTheNight;
    } else {
      currentPrayer = prayerTimes.currentPrayer();
      currentPrayerTime = prayerTimes.timeForPrayer(currentPrayer);
    }

    currentPrayer = _capitalizeFirstLetter(currentPrayer);
    prayerTime = currentPrayerTime != null
        ? DateFormat.jm().format(currentPrayerTime)
        : 'N/A';

    setState(() {});
  }

  void _startAutoUpdate() {
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      _getHijriDate();
      _getCurrentPrayerAndTime();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional(-1, 0),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: '$hijriDate\n',
              style: FlutterFlowTheme.of(context).headlineSmall.override(
                    fontFamily: 'Urbanist',
                    fontSize: 21, // Make Hijri date smaller
                    color: Colors.black,
                    letterSpacing: 0.0,
                  ),
            ),
            TextSpan(
              text: '$currentPrayer ',
              style: FlutterFlowTheme.of(context).headlineSmall.override(
                    fontFamily: 'Urbanist',
                    fontWeight: FontWeight.bold, // Bold the current prayer
                    fontSize: 26, // Slightly larger than Hijri date
                    color: Colors.black,
                    letterSpacing: 0.0,
                  ),
            ),
            TextSpan(
              text: prayerTime,
              style: FlutterFlowTheme.of(context).headlineSmall.override(
                    fontFamily: 'Urbanist',
                    fontWeight: FontWeight.bold, // Bold the prayer time
                    fontSize: 26, // Match size with current prayer
                    color: Colors.black,
                    letterSpacing: 0.0,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}