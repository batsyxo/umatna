import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';
import '/backend/schema/enums/enums.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ProfilephotoRecord extends FirestoreRecord {
  ProfilephotoRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "profilephoto" field.
  String? _profilephoto;
  String get profilephoto => _profilephoto ?? '';
  bool hasProfilephoto() => _profilephoto != null;

  void _initializeFields() {
    _profilephoto = snapshotData['profilephoto'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('profilephoto');

  static Stream<ProfilephotoRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => ProfilephotoRecord.fromSnapshot(s));

  static Future<ProfilephotoRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => ProfilephotoRecord.fromSnapshot(s));

  static ProfilephotoRecord fromSnapshot(DocumentSnapshot snapshot) =>
      ProfilephotoRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static ProfilephotoRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      ProfilephotoRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'ProfilephotoRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is ProfilephotoRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createProfilephotoRecordData({
  String? profilephoto,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'profilephoto': profilephoto,
    }.withoutNulls,
  );

  return firestoreData;
}

class ProfilephotoRecordDocumentEquality
    implements Equality<ProfilephotoRecord> {
  const ProfilephotoRecordDocumentEquality();

  @override
  bool equals(ProfilephotoRecord? e1, ProfilephotoRecord? e2) {
    return e1?.profilephoto == e2?.profilephoto;
  }

  @override
  int hash(ProfilephotoRecord? e) =>
      const ListEquality().hash([e?.profilephoto]);

  @override
  bool isValidKey(Object? o) => o is ProfilephotoRecord;
}
