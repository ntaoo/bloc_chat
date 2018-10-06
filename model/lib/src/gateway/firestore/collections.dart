import 'dart:async';

import 'package:model/src/gateway/firestore/documents/room_document.dart';
import 'package:model/src/gateway/firestore/firestore_base.dart';
import 'package:model/src/gateway/firestore/documents/message_document.dart';

export 'package:model/src/gateway/firestore/documents/room_document.dart'
    show RoomDocument;
export 'package:model/src/gateway/firestore/documents/message_document.dart'
    show MessageDocument;

abstract class RoomsCollection {
  Stream<List<RoomDocument>> get onAdded;
  Future<RoomDocument> get(String documentId);
  Future add(DocumentAddRequest<RoomDocument> request);
}

abstract class MessagesCollection extends FirestoreCollection<MessageDocument> {
  Stream<List<MessageDocument>> get onAdded;
  Stream<List<MessageDocument>> get onUpdated;
  Stream<List<MessageDocument>> get onDeleted;
  Future add(DocumentAddRequest<MessageDocument> request);
  Future update(DocumentUpdateRequest<MessageDocument> request);
  Future delete(String documentId);
}
