import 'dart:async';
import 'dart:collection';

import 'package:model/src/component/auth/user.dart';
import 'package:model/src/gateway/firestore/documents/message_document.dart';
import 'package:model/src/gateway/firestore/collections.dart';
import 'package:rxdart/rxdart.dart';

/// Stateful service to handle messages and perform actions on messages with Firebase.
class MessagesService {
  MessagesService(this._currentUser, this._messagesCollection) {
    _messagesCollection
      ..onAdded.listen(_handleMessageAdded)
      ..onUpdated.listen(_handleMessageUpdated)
      ..onDeleted.listen(_handleMessageDeleted);
  }

  final AnonymousUser _currentUser;
  final List<MessageDocument> _messages = [];

  final MessagesCollection _messagesCollection;

  final BehaviorSubject<UnmodifiableListView<MessageDocument>>
      _onMessagesChangedSubject = BehaviorSubject();

  _EditingMessage _editingMessage;

  Stream<UnmodifiableListView<MessageDocument>> get onMessagesChanged =>
      _onMessagesChangedSubject.stream;

  String get editingMessageId => _editingMessage?.id;
  String get editingMessageContent => _editingMessage?.content;

  Future addMessage(String messageContent) async {
    if (messageContent.isEmpty) return;

    _messagesCollection.add(MessageDocumentAddRequest(
        uid: _currentUser.id, content: messageContent));
    // I skipped the failure case handling on this demo app. I would add "Stream<Result> addedResult", and add a crush reporting.
  }

  void startEditingMessage(String messageId) {
    final message = _messages.firstWhere((e) => e.id == messageId);

    assert(message.uid == _currentUser.id);

    _editingMessage = _EditingMessage(message.id, message.content);
  }

  void cancelEditing() {
    _editingMessage = null;
  }

  bool isEditingFor(String messageId) => messageId == _editingMessage?.id;

  Future updateContent(String messageContent) async {
    if (messageContent.isEmpty) return;

    assert(_editingMessage != null);
    assert(_messages.firstWhere((e) => e.id == _editingMessage.id).uid ==
        _currentUser.id);

    await _messagesCollection.update(MessageDocumentContentUpdateRequest(
        _editingMessage.id,
        content: messageContent));

    // I skipped the failure case handling on this demo app. I would add "Stream<Result> updatedResult", and add a crush reporting.

    _editingMessage = null;
  }

  Future deleteMessage(String messageId) async {
    _messagesCollection.delete(messageId);
  }

  bool isEditableMessage(MessageDocument message) =>
      message.uid == _currentUser.id;

  void _handleMessageAdded(List<MessageDocument> messages) {
    _messages.addAll(messages);
    _emitMessages();
  }

  void _handleMessageUpdated(List<MessageDocument> messages) {
    messages.forEach((updated) {
      int index = _messages.indexWhere((e) => e.id == updated.id);
      _messages[index] = updated;
    });
    _emitMessages();
  }

  void _handleMessageDeleted(List<MessageDocument> messages) {
    final ids = messages.map((e) => e.id);
    _messages.removeWhere((e) => ids.contains(e.id));

    _emitMessages();
  }

  void _emitMessages() {
    _onMessagesChangedSubject
        .add(UnmodifiableListView<MessageDocument>(_messages));
  }
}

class _EditingMessage {
  _EditingMessage(this.id, this.content);

  final String id;
  String content;
}
