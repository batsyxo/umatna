// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';
import '/backend/schema/enums/enums.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class SettingsStruct extends FFFirebaseStruct {
  SettingsStruct({
    Device? themeMode,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _themeMode = themeMode,
        super(firestoreUtilData);

  // "theme_mode" field.
  Device? _themeMode;
  Device get themeMode => _themeMode ?? Device.device;
  set themeMode(Device? val) => _themeMode = val;

  bool hasThemeMode() => _themeMode != null;

  static SettingsStruct fromMap(Map<String, dynamic> data) => SettingsStruct(
        themeMode: deserializeEnum<Device>(data['theme_mode']),
      );

  static SettingsStruct? maybeFromMap(dynamic data) =>
      data is Map ? SettingsStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'theme_mode': _themeMode?.serialize(),
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'theme_mode': serializeParam(
          _themeMode,
          ParamType.Enum,
        ),
      }.withoutNulls;

  static SettingsStruct fromSerializableMap(Map<String, dynamic> data) =>
      SettingsStruct(
        themeMode: deserializeParam<Device>(
          data['theme_mode'],
          ParamType.Enum,
          false,
        ),
      );

  @override
  String toString() => 'SettingsStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is SettingsStruct && themeMode == other.themeMode;
  }

  @override
  int get hashCode => const ListEquality().hash([themeMode]);
}

SettingsStruct createSettingsStruct({
  Device? themeMode,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    SettingsStruct(
      themeMode: themeMode,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

SettingsStruct? updateSettingsStruct(
  SettingsStruct? settings, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    settings
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addSettingsStructData(
  Map<String, dynamic> firestoreData,
  SettingsStruct? settings,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (settings == null) {
    return;
  }
  if (settings.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && settings.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final settingsData = getSettingsFirestoreData(settings, forFieldValue);
  final nestedData = settingsData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = settings.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getSettingsFirestoreData(
  SettingsStruct? settings, [
  bool forFieldValue = false,
]) {
  if (settings == null) {
    return {};
  }
  final firestoreData = mapToFirestore(settings.toMap());

  // Add any Firestore field values
  settings.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getSettingsListFirestoreData(
  List<SettingsStruct>? settingss,
) =>
    settingss?.map((e) => getSettingsFirestoreData(e, true)).toList() ?? [];
