import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // For Firestore
import 'package:firebase_auth/firebase_auth.dart'; // For Firebase Auth

class CalendarWidget extends StatefulWidget {
  const CalendarWidget({super.key});

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  // Controllers for event inputs
  final TextEditingController eventTitleController = TextEditingController();
  final TextEditingController eventDescriptionController = TextEditingController();
  bool shareWithFriends = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: custom_widgets.Customcalendardart(),
            ),
          ],
        ),
      ),
    );
  }
}