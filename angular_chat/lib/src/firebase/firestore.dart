import 'package:firebase/firebase.dart';
import 'package:firebase/firestore.dart' as fs;
import 'package:model/chat.dart';

class FirestoreImpl implements Firestore {
  FirestoreImpl() : ref = firestore();
  final fs.Firestore ref;

  fs.FieldValue get serverTimestamp => fs.FieldValue.serverTimestamp();
}
