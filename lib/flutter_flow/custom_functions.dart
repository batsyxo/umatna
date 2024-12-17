import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'lat_lng.dart';
import 'place.dart';
import 'uploaded_file.dart';
import '/backend/backend.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/backend/schema/structs/index.dart';
import '/backend/schema/enums/enums.dart';
import '/auth/firebase_auth/auth_util.dart';

double calculateDistance(
  double lat1,
  double lon1,
  double lat2,
  double lon2,
) {
  const earthRadius = 6371; // Radius of Earth in kilometers
  final dLat = (lat2 - lat1) * (3.141592653589793 / 180.0);
  final dLon = (lon2 - lon1) * (3.141592653589793 / 180.0);
  final a = 0.5 -
      (math.cos(dLat) / 2) +
      math.cos(lat1 * (3.141592653589793 / 180.0)) *
          math.cos(lat2 * (3.141592653589793 / 180.0)) *
          (1 - math.cos(dLon)) /
          2;

  return earthRadius * 2 * math.asin(math.sqrt(a));
}
