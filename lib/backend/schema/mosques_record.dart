import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';
import '/backend/schema/enums/enums.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class MosquesRecord extends FirestoreRecord {
  MosquesRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "coordinates" field.
  List<LatLng>? _coordinates;
  List<LatLng> get coordinates => _coordinates ?? const [];
  bool hasCoordinates() => _coordinates != null;

  void _initializeFields() {
    _coordinates = getDataList(snapshotData['coordinates']);
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('mosques');

  static Stream<MosquesRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => MosquesRecord.fromSnapshot(s));

  static Future<MosquesRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => MosquesRecord.fromSnapshot(s));

  static MosquesRecord fromSnapshot(DocumentSnapshot snapshot) =>
      MosquesRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static MosquesRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      MosquesRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'MosquesRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is MosquesRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createMosquesRecordData() {
  final firestoreData = mapToFirestore(
    <String, dynamic>{}.withoutNulls,
  );

  return firestoreData;
}

class MosquesRecordDocumentEquality implements Equality<MosquesRecord> {
  const MosquesRecordDocumentEquality();

  @override
  bool equals(MosquesRecord? e1, MosquesRecord? e2) {
    const listEquality = ListEquality();
    return listEquality.equals(e1?.coordinates, e2?.coordinates);
  }

  @override
  int hash(MosquesRecord? e) => const ListEquality().hash([e?.coordinates]);

  @override
  bool isValidKey(Object? o) => o is MosquesRecord;
}
