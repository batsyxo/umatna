import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as latLng2;
import 'package:geolocator/geolocator.dart';
import 'dart:async';

class LocationTest extends StatefulWidget {
  const LocationTest({
    Key? key,
    this.width,
    this.height,
  }) : super(key: key);

  final double? width;
  final double? height;

  @override
  State<LocationTest> createState() => _LocationTestState();
}

class _LocationTestState extends State<LocationTest> {
  final MapController _mapController = MapController();
  latLng2.LatLng? userLocation;
  bool showMosques = false;
  double currentZoomLevel = 9.2;
  bool _isLiveUpdateEnabled = false;

  // Add these variables for search bar and filter chips
  String searchQuery = '';
  String selectedFilter = '';

  final List<Map<String, dynamic>> allLocations = [
    {"name": "Home", "category": "Home"},
    {"name": "Restaurant A", "category": "Restaurants"},
    {"name": "Gas Station", "category": "Gas"},
    {"name": "Shopping Mall", "category": "Shopping"},
  ];

  List<Map<String, dynamic>> displayedLocations = [];

  @override
  void initState() {
    super.initState();
    displayedLocations = List.from(allLocations); // Show all locations initially
    _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      final position = await Geolocator.getCurrentPosition();
      setState(() {
        userLocation = latLng2.LatLng(position.latitude, position.longitude);
      });
    }
  }

  void searchLocations(String query) {
    setState(() {
      searchQuery = query;
      displayedLocations = allLocations
          .where((location) =>
              location['name'].toLowerCase().contains(query.toLowerCase()) &&
              (selectedFilter.isEmpty || location['category'] == selectedFilter))
          .toList();
    });
  }

  void filterLocations(String category) {
    setState(() {
      selectedFilter = category;
      displayedLocations = allLocations
          .where((location) =>
              (searchQuery.isEmpty ||
                  location['name']
                      .toLowerCase()
                      .contains(searchQuery.toLowerCase())) &&
              (category.isEmpty || location['category'] == category))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Map Widget
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter:
                userLocation ?? latLng2.LatLng(43.255203, -79.843826),
            initialZoom: currentZoomLevel,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.app',
            ),
          ],
        ),

        // Rounded Search Bar
        Positioned(
          top: 50,
          left: 10,
          right: 10,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 4.0,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(Icons.search, color: Colors.grey),
                SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 18),
                    decoration: InputDecoration(
                      hintText: "Search here",
                      hintStyle: TextStyle(fontSize: 18),
                      border: InputBorder.none,
                    ),
                    onChanged: (value) {
                      searchLocations(value);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),

        // Filter Chips
        Positioned(
          top: 110,
          left: 10,
          right: 10,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                SizedBox(width: 8),
                FilterChip(
                  label: Row(
                    children: [
                      Icon(Icons.home, color: Colors.black),
                      SizedBox(width: 4),
                      Text('Home', style: TextStyle(color: Colors.black)),
                    ],
                  ),
                  backgroundColor: Colors.white,
                  selected: selectedFilter == 'Home',
                  selectedColor: Colors.grey[300],
                  onSelected: (_) => filterLocations('Home'),
                ),
                SizedBox(width: 8),
                FilterChip(
                  label: Row(
                    children: [
                      Icon(Icons.restaurant, color: Colors.black),
                      SizedBox(width: 4),
                      Text('Restaurants', style: TextStyle(color: Colors.black)),
                    ],
                  ),
                  backgroundColor: Colors.white,
                  selected: selectedFilter == 'Restaurants',
                  selectedColor: Colors.grey[300],
                  onSelected: (_) => filterLocations('Restaurants'),
                ),
                SizedBox(width: 8),
                FilterChip(
                  label: Row(
                    children: [
                      Icon(Icons.local_gas_station, color: Colors.black),
                      SizedBox(width: 4),
                      Text('Gas', style: TextStyle(color: Colors.black)),
                    ],
                  ),
                  backgroundColor: Colors.white,
                  selected: selectedFilter == 'Gas',
                  selectedColor: Colors.grey[300],
                  onSelected: (_) => filterLocations('Gas'),
                ),
                SizedBox(width: 8),
                FilterChip(
                  label: Row(
                    children: [
                      Icon(Icons.shopping_cart, color: Colors.black),
                      SizedBox(width: 4),
                      Text('Shopping', style: TextStyle(color: Colors.black)),
                    ],
                  ),
                  backgroundColor: Colors.white,
                  selected: selectedFilter == 'Shopping',
                  selectedColor: Colors.grey[300],
                  onSelected: (_) => filterLocations('Shopping'),
                ),
              ],
            ),
          ),
        ),

        // Floating Action Buttons
        Positioned(
          right: 16,
          bottom: 150,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FloatingActionButton(
                onPressed: () {
                  if (userLocation != null) {
                    _mapController.move(userLocation!, currentZoomLevel);
                  }
                },
                backgroundColor: Colors.white,
                child: Icon(Icons.navigation, color: Colors.blue),
              ),
              SizedBox(height: 16),
              FloatingActionButton(
                onPressed: () {
                  print("Mosque FAB pressed...");
                },
                backgroundColor: Colors.white,
                child: Icon(Icons.mosque, color: Colors.green),
              ),
              SizedBox(height: 16),
              FloatingActionButton(
                onPressed: () {
                  print("Get directions FAB pressed...");
                },
                backgroundColor: Colors.white,
                child: Icon(Icons.directions, color: Colors.red),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
