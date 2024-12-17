import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';
import '/backend/schema/enums/enums.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class VolunteerpostsRecord extends FirestoreRecord {
  VolunteerpostsRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "owner" field.
  DocumentReference? _owner;
  DocumentReference? get owner => _owner;
  bool hasOwner() => _owner != null;

  // "project_name" field.
  String? _projectName;
  String get projectName => _projectName ?? '';
  bool hasProjectName() => _projectName != null;

  // "description" field.
  String? _description;
  String get description => _description ?? '';
  bool hasDescription() => _description != null;

  // "time_created" field.
  DateTime? _timeCreated;
  DateTime? get timeCreated => _timeCreated;
  bool hasTimeCreated() => _timeCreated != null;

  // "image" field.
  String? _image;
  String get image => _image ?? '';
  bool hasImage() => _image != null;

  // "postfavs" field.
  List<DocumentReference>? _postfavs;
  List<DocumentReference> get postfavs => _postfavs ?? const [];
  bool hasPostfavs() => _postfavs != null;

  void _initializeFields() {
    _owner = snapshotData['owner'] as DocumentReference?;
    _projectName = snapshotData['project_name'] as String?;
    _description = snapshotData['description'] as String?;
    _timeCreated = snapshotData['time_created'] as DateTime?;
    _image = snapshotData['image'] as String?;
    _postfavs = getDataList(snapshotData['postfavs']);
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('volunteerposts');

  static Stream<VolunteerpostsRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => VolunteerpostsRecord.fromSnapshot(s));

  static Future<VolunteerpostsRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => VolunteerpostsRecord.fromSnapshot(s));

  static VolunteerpostsRecord fromSnapshot(DocumentSnapshot snapshot) =>
      VolunteerpostsRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static VolunteerpostsRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      VolunteerpostsRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'VolunteerpostsRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is VolunteerpostsRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createVolunteerpostsRecordData({
  DocumentReference? owner,
  String? projectName,
  String? description,
  DateTime? timeCreated,
  String? image,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'owner': owner,
      'project_name': projectName,
      'description': description,
      'time_created': timeCreated,
      'image': image,
    }.withoutNulls,
  );

  return firestoreData;
}

class VolunteerpostsRecordDocumentEquality
    implements Equality<VolunteerpostsRecord> {
  const VolunteerpostsRecordDocumentEquality();

  @override
  bool equals(VolunteerpostsRecord? e1, VolunteerpostsRecord? e2) {
    const listEquality = ListEquality();
    return e1?.owner == e2?.owner &&
        e1?.projectName == e2?.projectName &&
        e1?.description == e2?.description &&
        e1?.timeCreated == e2?.timeCreated &&
        e1?.image == e2?.image &&
        listEquality.equals(e1?.postfavs, e2?.postfavs);
  }

  @override
  int hash(VolunteerpostsRecord? e) => const ListEquality().hash([
        e?.owner,
        e?.projectName,
        e?.description,
        e?.timeCreated,
        e?.image,
        e?.postfavs
      ]);

  @override
  bool isValidKey(Object? o) => o is VolunteerpostsRecord;
}
