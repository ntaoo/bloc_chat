import 'package:cloud_firestore/cloud_firestore.dart' as fs;
import 'package:model/chat.dart';

class FirestoreImpl implements Firestore {
  FirestoreImpl() : ref = fs.Firestore();
  final fs.Firestore ref;

  fs.FieldValue get serverTimestamp => fs.FieldValue.serverTimestamp();
}
