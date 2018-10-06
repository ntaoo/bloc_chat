import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart' as fs;
import 'package:model/chat.dart';

class RoomsCollectionImpl implements RoomsCollection {
  RoomsCollectionImpl(this._firestore) : _ref = _firestore.ref as fs.Firestore;

  final Firestore _firestore;
  final fs.Firestore _ref;

  Stream<List<RoomDocument>> get onAdded =>
      _docChangeOfType(fs.DocumentChangeType.added);

  Future<RoomDocument> get(String id) =>
      _collection.document(id).get().then(_toModel);

  Future add(DocumentAddRequest<RoomDocument> request) {
    final data = request.toJson(serverTimestamp: _firestore.serverTimestamp);
    return _collection.add(data);
  }

  fs.CollectionReference get _collection => _ref.collection('rooms');

  Stream<List<RoomDocument>> _docChangeOfType(fs.DocumentChangeType type) =>
      _collection
          .orderBy('createdTime')
          .snapshots()
          .map((s) => s.documentChanges
              .where((fs.DocumentChange e) => e.type == type)
              .map((e) => _toModel(e.document))
              .toList())
          .where((dcs) => dcs.isNotEmpty);

  RoomDocument _toModel(fs.DocumentSnapshot documentSnapshot) {
    final data = documentSnapshot.data..['id'] = documentSnapshot.documentID;
    return RoomDocument.fromJson(data);
  }
}
