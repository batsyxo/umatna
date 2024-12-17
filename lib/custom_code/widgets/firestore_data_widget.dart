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

import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreDataWidget extends StatefulWidget {
  const FirestoreDataWidget({
    Key? key,
    this.width,
    this.height,
  }) : super(key: key);

  final double? width;
  final double? height;

  @override
  _FirestoreDataWidgetState createState() => _FirestoreDataWidgetState();
}

class _FirestoreDataWidgetState extends State<FirestoreDataWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('mosques').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final mosques = snapshot.data!.docs;

          return ListView.builder(
            itemCount: mosques.length,
            itemBuilder: (context, index) {
              final mosque = mosques[index];
              final data = mosque.data() as Map<String, dynamic>;

              return ListTile(
                title: Text(data['name'] ?? 'No Name'),
                subtitle: Text(
                    'Latitude: ${data['latitude']}, Longitude: ${data['longitude']}'),
              );
            },
          );
        },
      ),
    );
  }
}
// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!
