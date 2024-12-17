import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'location_request_prompt_model.dart';
export 'location_request_prompt_model.dart';

class LocationRequestPromptWidget extends StatefulWidget {
  const LocationRequestPromptWidget({super.key});

  @override
  State<LocationRequestPromptWidget> createState() =>
      _LocationRequestPromptWidgetState();
}

class _LocationRequestPromptWidgetState
    extends State<LocationRequestPromptWidget> {
  late LocationRequestPromptModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => LocationRequestPromptModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400.0,
      height: 100.0,
      child: custom_widgets.LocationPermission11(
        width: 400.0,
        height: 100.0,
      ),
    );
  }
}
