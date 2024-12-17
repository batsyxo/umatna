import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'qibla_model.dart';
export 'qibla_model.dart';

class QiblaWidget extends StatefulWidget {
  const QiblaWidget({super.key});

  @override
  State<QiblaWidget> createState() => _QiblaWidgetState();
}

class _QiblaWidgetState extends State<QiblaWidget> {
  late QiblaModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => QiblaModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional(0.0, 0.0),
      child: Container(
        width: 400.0,
        height: 540.0,
        child: custom_widgets.QiblaCompass(
          width: 400.0,
          height: 540.0,
        ),
      ),
    );
  }
}
