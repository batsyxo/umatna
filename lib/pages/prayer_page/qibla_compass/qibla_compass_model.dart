import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/pages/prayer_page/qibla/qibla_widget.dart';
import 'qibla_compass_widget.dart' show QiblaCompassWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class QiblaCompassModel extends FlutterFlowModel<QiblaCompassWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for Qibla component.
  late QiblaModel qiblaModel;

  @override
  void initState(BuildContext context) {
    qiblaModel = createModel(context, () => QiblaModel());
  }

  @override
  void dispose() {
    qiblaModel.dispose();
  }
}
