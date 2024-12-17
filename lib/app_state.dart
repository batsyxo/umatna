import 'package:flutter/material.dart';
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/backend/schema/enums/enums.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'flutter_flow/flutter_flow_util.dart';

class FFAppState extends ChangeNotifier {
  static FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  static void reset() {
    _instance = FFAppState._internal();
  }

  Future initializePersistedState() async {
    prefs = await SharedPreferences.getInstance();
    _safeInit(() {
      _savedvolunteerpost = prefs
              .getStringList('ff_savedvolunteerpost')
              ?.map((path) => path.ref)
              .toList() ??
          _savedvolunteerpost;
    });
    _safeInit(() {
      _latitude = prefs.getDouble('ff_latitude') ?? _latitude;
    });
    _safeInit(() {
      _longitude = prefs.getDouble('ff_longitude') ?? _longitude;
    });
    _safeInit(() {
      _timezone = prefs.getString('ff_timezone') ?? _timezone;
    });
    _safeInit(() {
      if (prefs.containsKey('ff_settings')) {
        try {
          final serializedData = prefs.getString('ff_settings') ?? '{}';
          _settings =
              SettingsStruct.fromSerializableMap(jsonDecode(serializedData));
        } catch (e) {
          print("Can't decode persisted data type. Error: $e.");
        }
      }
    });
  }

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  late SharedPreferences prefs;

  List<DocumentReference> _savedvolunteerpost = [];
  List<DocumentReference> get savedvolunteerpost => _savedvolunteerpost;
  set savedvolunteerpost(List<DocumentReference> value) {
    _savedvolunteerpost = value;
    prefs.setStringList(
        'ff_savedvolunteerpost', value.map((x) => x.path).toList());
  }

  void addToSavedvolunteerpost(DocumentReference value) {
    savedvolunteerpost.add(value);
    prefs.setStringList('ff_savedvolunteerpost',
        _savedvolunteerpost.map((x) => x.path).toList());
  }

  void removeFromSavedvolunteerpost(DocumentReference value) {
    savedvolunteerpost.remove(value);
    prefs.setStringList('ff_savedvolunteerpost',
        _savedvolunteerpost.map((x) => x.path).toList());
  }

  void removeAtIndexFromSavedvolunteerpost(int index) {
    savedvolunteerpost.removeAt(index);
    prefs.setStringList('ff_savedvolunteerpost',
        _savedvolunteerpost.map((x) => x.path).toList());
  }

  void updateSavedvolunteerpostAtIndex(
    int index,
    DocumentReference Function(DocumentReference) updateFn,
  ) {
    savedvolunteerpost[index] = updateFn(_savedvolunteerpost[index]);
    prefs.setStringList('ff_savedvolunteerpost',
        _savedvolunteerpost.map((x) => x.path).toList());
  }

  void insertAtIndexInSavedvolunteerpost(int index, DocumentReference value) {
    savedvolunteerpost.insert(index, value);
    prefs.setStringList('ff_savedvolunteerpost',
        _savedvolunteerpost.map((x) => x.path).toList());
  }

  double _latitude = 0.0;
  double get latitude => _latitude;
  set latitude(double value) {
    _latitude = value;
    prefs.setDouble('ff_latitude', value);
  }

  double _longitude = 0.0;
  double get longitude => _longitude;
  set longitude(double value) {
    _longitude = value;
    prefs.setDouble('ff_longitude', value);
  }

  String _timezone = '';
  String get timezone => _timezone;
  set timezone(String value) {
    _timezone = value;
    prefs.setString('ff_timezone', value);
  }

  SettingsStruct _settings = SettingsStruct();
  SettingsStruct get settings => _settings;
  set settings(SettingsStruct value) {
    _settings = value;
    prefs.setString('ff_settings', value.serialize());
  }

  void updateSettingsStruct(Function(SettingsStruct) updateFn) {
    updateFn(_settings);
    prefs.setString('ff_settings', _settings.serialize());
  }
}

void _safeInit(Function() initializeField) {
  try {
    initializeField();
  } catch (_) {}
}

Future _safeInitAsync(Function() initializeField) async {
  try {
    await initializeField();
  } catch (_) {}
}
