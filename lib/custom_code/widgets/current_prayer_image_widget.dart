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
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:prayers_times/prayers_times.dart';
import 'package:latlong2/latlong.dart' as latLng2;

class CurrentPrayerImageWidget extends StatefulWidget {
  const CurrentPrayerImageWidget({
    super.key,
    this.width,
    this.height,
  });

  final double? width;
  final double? height;

  @override
  State<CurrentPrayerImageWidget> createState() =>
      _CurrentPrayerImageWidgetState();
}

class _CurrentPrayerImageWidgetState extends State<CurrentPrayerImageWidget> {
  PrayerTimes? prayerTimes;
  String? currentPrayer;
  SunnahInsights? sunnahInsights;
  Timer? timer; // Add a Timer to periodically check prayer times

  Map<String, String> prayerImages = {
    'fajr':
        'https://images.unsplash.com/photo-1509023464722-18d996393ca8?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHNlYXJjaHwyfHxtb3JuaW5nJTIwZGFya3xlbnwwfHx8fDE3MjMzMzIzMzB8MA&ixlib=rb-4.0.3&q=80&w=1080',
    'Sunrise':
        'https://images.unsplash.com/photo-1514241516423-6c0a5e031aa2?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHNlYXJjaHw3fHxzdW5yaXNlfGVufDB8fHx8MTcyMzMzMjI0N3ww&ixlib=rb-4.0.3&q=80&w=1080',
    'Duha':
        'https://images.unsplash.com/photo-1484766280341-87861644c80d?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHNlYXJjaHw0fHxzdW58ZW58MHx8fHwxNzI0NTEzNjA4fDA&ixlib=rb-4.0.3&q=80&w=1080',
    'dhuhr':
        'https://images.unsplash.com/photo-1504386106331-3e4e71712b38?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHNlYXJjaHwxMHx8c3VufGVufDB8fHx8MTcyMzMzMjQzM3ww&ixlib=rb-4.0.3&q=80&w=1080',
    'asr':
        'https://images.unsplash.com/photo-1639600861808-839928aba6ca?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHNlYXJjaHwyMnx8c3VufGVufDB8fHx8MTcyMzMzMjQzM3ww&ixlib=rb-4.0.3&q=80&w=1080',
    'maghrib':
        'https://images.unsplash.com/photo-1490682143684-14369e18dce8?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHNlYXJjaHwxM3x8c3Vuc2V0fGVufDB8fHx8MTcyMzMyNjA3Nnww&ixlib=rb-4.0.3&q=80&w=1080',
    'isha':
        'https://images.unsplash.com/photo-1514897575457-c4db467cf78e?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHNlYXJjaHwyfHxtb29ufGVufDB8fHx8MTcyMzMzMjc0OHww&ixlib=rb-4.0.3&q=80&w=1080',
    'Tahajud':
        'https://images.unsplash.com/photo-1476111021705-ac3b3304fe20?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHNlYXJjaHwyMXx8bmlnaHQlMjBza3l8ZW58MHx8fHwxNzI0NDkzNTA0fDA&ixlib=rb-4.0.3&q=80&w=1080',
  };

  @override
  void initState() {
    super.initState();
    _calculatePrayerTimes();
    _startPrayerTimeUpdater(); // Start the timer when the widget is initialized
  }

  @override
  void dispose() {
    timer?.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  void _calculatePrayerTimes() async {
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

    prayerTimes = PrayerTimes(
      coordinates: coordinates,
      calculationParameters: params,
      precision: true,
      locationName: timezone,
    );
    sunnahInsights = SunnahInsights(prayerTimes!);
    currentPrayer = prayerTimes!.currentPrayer();

    if (DateTime.now().isBefore(prayerTimes!.dhuhrStartTime!) &&
        DateTime.now()
            .isAfter(prayerTimes!.sunrise!.add(Duration(minutes: 15)))) {
      currentPrayer = 'Duha';
    } else if (DateTime.now().isAfter(prayerTimes!.sunrise!) &&
        DateTime.now()
            .isBefore(prayerTimes!.sunrise!.add(Duration(minutes: 15)))) {
      currentPrayer = 'Sunrise';
    } else if (DateTime.now().isAfter(sunnahInsights!.lastThirdOfTheNight) &&
        DateTime.now().isBefore(prayerTimes!.fajrStartTime!)) {
      currentPrayer = 'Tahajud';
    } else {
      currentPrayer = prayerTimes!.currentPrayer();
    }

    setState(() {});
  }

  void _startPrayerTimeUpdater() {
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      _calculatePrayerTimes(); // Check prayer times every minute
    });
  }

  @override
  Widget build(BuildContext context) {
    String? imageUrl = prayerImages[currentPrayer];

    return Container(
      width: widget.width,
      height: widget.height,
      color: Colors.white,
      child: imageUrl != null
          ? ClipRRect(
              borderRadius:
                  BorderRadius.circular(16.0), // Adjust the radius as needed
              child: Image.network(
                imageUrl,
                width: widget.width,
                height: widget.height,
                fit: BoxFit.cover,
              ),
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}
