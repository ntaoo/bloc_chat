import 'dart:async';
import 'package:firebase/firestore.dart' as fs;

import 'package:model/chat.dart';

class MessagesCollectionImpl implements MessagesCollection {
  MessagesCollectionImpl(this._roomId, this._firestore)
      : _ref = _firestore.ref as fs.Firestore;

  final String _roomId;
  final Firestore _firestore;
  final fs.Firestore _ref;

  Stream<List<MessageDocument>> get onAdded => _docChangeOfType('added');
  Stream<List<MessageDocument>> get onUpdated => _docChangeOfType('modified');
  Stream<List<MessageDocument>> get onDeleted => _docChangeOfType('removed');

  fs.CollectionReference get _collection =>
      _ref.collection('rooms').doc(_roomId).collection('messages');

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
    final data = request.toJson(serverTimestamp: _firestore.serverTimestamp);
    final ss = await _collection.doc(request.documentId).get();
    try {
      await ss.ref.update(data: data);
    } catch (e) {
      print('error on updating a message');
      print(e);
    }
  }

  Future delete(String messageId) async {
    try {
      final ss = await _collection.doc(messageId).get();
      await ss.ref.delete();
    } catch (e) {
      print('error on deleting a message');
      print(e);
    }
  }

  MessageDocument _toModel(fs.DocumentSnapshot documentSnapshot) {
    final data = documentSnapshot.data()..['id'] = documentSnapshot.id;
    return MessageDocument.fromJson(data);
  }

  Stream<List<MessageDocument>> _docChangeOfType(String type) => _collection
      .orderBy('createdTime')
      .onSnapshot
      .map((s) => s
          .docChanges()
          .where((fs.DocumentChange e) => e.type == type)
          .map((e) => _toModel(e.doc))
          .toList())
      .where((dcs) => dcs.isNotEmpty);
}
