import 'dart:async';
import 'package:firebase/firestore.dart' as fs;
import 'package:model/chat.dart';

class RoomsCollectionImpl implements RoomsCollection {
  RoomsCollectionImpl(this._firestore) : _ref = _firestore.ref as fs.Firestore;

  final Firestore _firestore;
  final fs.Firestore _ref;

  Stream<List<RoomDocument>> get onAdded => _docChangeOfType('added');
  
  Future<RoomDocument> get(String id) =>
      _collection.doc(id).get().then(_toModel);

  Future add(DocumentAddRequest<RoomDocument> request) {
    final data = request.toJson(serverTimestamp: _firestore.serverTimestamp);
    return _collection.add(data);
  }

  fs.CollectionReference get _collection => _ref.collection('rooms');

  Stream<List<RoomDocument>> _docChangeOfType(String type) => _collection
      .orderBy('createdTime', 'desc')
      .onSnapshot
      .map((s) => s
          .docChanges()
          .where((fs.DocumentChange e) => e.type == type)
          .map((e) => _toModel(e.doc))
          .toList())
      .where((dcs) => dcs.isNotEmpty);

  RoomDocument _toModel(fs.DocumentSnapshot documentSnapshot) {
    final data = documentSnapshot.data()..['id'] = documentSnapshot.id;
    return RoomDocument.fromJson(data);
  }
}
