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

import 'package:latlong2/latlong.dart' as latLng2;
import 'package:flutter_map/flutter_map.dart';

class LocationDpad extends StatefulWidget {
  const LocationDpad({
    super.key,
    this.width,
    this.height,
  });

  final double? width;
  final double? height;

  @override
  State<LocationDpad> createState() => _LocationDpadState();
}

class _LocationDpadState extends State<LocationDpad>
    with AutomaticKeepAliveClientMixin {
  latLng2.LatLng userLocation =
      latLng2.LatLng(43.255203, -79.843826); // Default location
  final MapController _mapController = MapController();
  double moveDistance = 0.01; // Adjust the distance of each movement
  double currentZoomLevel = 9.2; // Set initial zoom level

  @override
  void initState() {
    super.initState();

    // Initialize with the map centering on the default location
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _mapController.move(userLocation, currentZoomLevel);
    });
  }

  void _updateLocation(double latitudeDelta, double longitudeDelta) {
    setState(() {
      userLocation = latLng2.LatLng(
        userLocation.latitude + latitudeDelta,
        userLocation.longitude + longitudeDelta,
      );
      _mapController.move(userLocation, currentZoomLevel);
    });
  }

  void _updateZoom(double zoomDelta) {
    setState(() {
      currentZoomLevel += zoomDelta;
      _mapController.move(userLocation, currentZoomLevel);
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required when using AutomaticKeepAliveClientMixin

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Use D-pad to Move Location',
            style: FlutterFlowTheme.of(context).bodyMedium,
          ),
        ),
        Expanded(
          child: FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: userLocation,
              initialZoom: currentZoomLevel,
              onPositionChanged: (position, hasGesture) {
                if (hasGesture) {
                  setState(() {
                    currentZoomLevel = position.zoom ?? currentZoomLevel;
                  });
                }
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.app',
                maxNativeZoom: 19,
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: userLocation,
                    width: 30,
                    height: 30,
                    child: Icon(
                      Icons.my_location,
                      color: Colors.red,
                      size: 30.0,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_drop_up),
                    onPressed: () => _updateLocation(moveDistance, 0.0),
                    iconSize: 40,
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_left),
                        onPressed: () => _updateLocation(0.0, -moveDistance),
                        iconSize: 40,
                      ),
                      IconButton(
                        icon: Icon(Icons.arrow_drop_down),
                        onPressed: () => _updateLocation(-moveDistance, 0.0),
                        iconSize: 40,
                      ),
                      IconButton(
                        icon: Icon(Icons.arrow_right),
                        onPressed: () => _updateLocation(0.0, moveDistance),
                        iconSize: 40,
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                children: [
                  IconButton(
                    icon: Icon(Icons.zoom_in),
                    onPressed: () => _updateZoom(0.5), // Zoom in
                    iconSize: 40,
                  ),
                  IconButton(
                    icon: Icon(Icons.zoom_out),
                    onPressed: () => _updateZoom(-0.5), // Zoom out
                    iconSize: 40,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // This keeps the widget alive when navigating back to it
  @override
  bool get wantKeepAlive => true;
}
