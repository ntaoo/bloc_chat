import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart' as fs;
import 'package:model/chat.dart';

class MessagesCollectionImpl implements MessagesCollection {
  MessagesCollectionImpl(this._roomId, this._firestore)
      : _ref = _firestore.ref as fs.Firestore;

  final String _roomId;
  final Firestore _firestore;
  final fs.Firestore _ref;

  Stream<List<MessageDocument>> get onAdded =>
      _docChangeOfType(fs.DocumentChangeType.added);

  Stream<List<MessageDocument>> get onUpdated =>
      _docChangeOfType(fs.DocumentChangeType.modified);

  Stream<List<MessageDocument>> get onDeleted =>
      _docChangeOfType(fs.DocumentChangeType.removed);

  fs.CollectionReference get _collection =>
      _ref.collection('rooms').document(_roomId).collection('messages');

  Future add(DocumentAddRequest<MessageDocument> request) async {
    final data = request.toJson(serverTimestamp: _firestore.serverTimestamp);

    try {
      await _collection.add(data);
    } catch (e) {
      print('error on adding a message');
      print(e);
    }
  }

  Future update(DocumentUpdateRequest<MessageDocument> request) async {
    final ss = await _collection.document(request.documentId).get();
    try {
      await ss.reference.updateData(
          request.toJson(serverTimestamp: _firestore.serverTimestamp));
    } catch (e) {
      print('error on updating a message');
      print(e);
    }
  }

  Future delete(String messageId) async {
    try {
      final ss = await _collection.document(messageId).get();
      await ss.reference.delete();
    } catch (e) {
      print('error on deleting a message');
      print(e);
    }
  }

  MessageDocument _toModel(fs.DocumentSnapshot documentSnapshot) {
    final data = documentSnapshot.data..['id'] = documentSnapshot.documentID;
    return MessageDocument.fromJson(data);
  }

  Stream<List<MessageDocument>> _docChangeOfType(fs.DocumentChangeType type) =>
      _collection
          .orderBy('createdTime')
          .snapshots()
          .map((s) => s.documentChanges
              .where((fs.DocumentChange e) => e.type == type)
              .map((e) => _toModel(e.document))
              .toList())
          .where((dcs) => dcs.isNotEmpty);

  Stream<List<MessageDocument>> get changes {
    return _collection.orderBy('createdTime').snapshots().map(
        (s) => s.documentChanges.map((dc) => _toModel(dc.document)).toList());
  }
}
