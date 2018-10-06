import 'dart:async';
import 'dart:collection';

import 'package:model/src/component/auth/auth_service.dart';
import 'package:model/src/gateway/firestore/collections.dart';
import 'package:rxdart/rxdart.dart';

import 'messages_service.dart';
import 'view_model/message.dart';

export 'view_model/message.dart';

/// BLoC pattern facade for Angular and Flutter client.
class MessagesBloc {
  MessagesBloc(AuthService authService, MessagesCollection messagesCollection)
      : _messagesService =
            MessagesService(authService.currentUser, messagesCollection) {
    _addMessageController.stream.listen(_addMessage);
    _updateMessageController.stream.listen(_updateMessage);
    _deleteMessageController.stream.listen(_deleteMessage);
    _startEditingMessageController.stream.listen(_startEditing);
    _cancelEditingMessageController.stream.listen(_cancelEditing);

    _messagesService.onMessagesChanged.listen(_emitMessages);
  }

  final MessagesService _messagesService;

  // Input controllers
  final StreamController<String> _addMessageController = StreamController();
  final StreamController<String> _startEditingMessageController =
      StreamController();
  final StreamController<Null> _cancelEditingMessageController =
      StreamController();
  final StreamController<String> _updateMessageController = StreamController();
  final StreamController<String> _deleteMessageController = StreamController();

  // Output controllers
  final BehaviorSubject<UnmodifiableListView<MessageView>> _messagesSubject =
      BehaviorSubject(seedValue: UnmodifiableListView([]));
  final BehaviorSubject<String> _newMessageSubject = BehaviorSubject();
  final BehaviorSubject<bool> _isEditingMessageSubject = BehaviorSubject();
  final BehaviorSubject<String> _editingMessageContentSubject =
      BehaviorSubject();

  // Input signals
  Sink<String> get addMessage => _addMessageController.sink;
  Sink<String> get startEditingMessage => _startEditingMessageController.sink;
  Sink<Null> get cancelEditingMessage => _cancelEditingMessageController.sink;
  Sink<String> get updateMessage => _updateMessageController.sink;
  Sink<String> get deleteMessage => _deleteMessageController.sink;

  // Output streams
  Stream<UnmodifiableListView<MessageView>> get messages =>
      _messagesSubject.stream;
  Stream<String> get newMessageContent => _newMessageSubject.stream;
  Stream<bool> get isEditingMessage => _isEditingMessageSubject.stream;
  Stream<String> get editingMessageContent =>
      _editingMessageContentSubject.stream;

  void _addMessage(messageContent) async {
    await _messagesService.addMessage(messageContent);
    _newMessageSubject.add('');
  }

  void _startEditing(String messageId) {
    _messagesService.startEditingMessage(messageId);
    _isEditingMessageSubject.add(true);
    _editingMessageContentSubject.add(_messagesService.editingMessageContent);
  }

  void _cancelEditing(_) {
    _messagesService.cancelEditing();
    _isEditingMessageSubject.add(false);
  }

  void _updateMessage(String messageContent) async {
    await _messagesService.updateContent(messageContent);
    _isEditingMessageSubject.add(false);
  }

  void _deleteMessage(String messageId) {
    _messagesService.deleteMessage(messageId);
    if (_messagesService.isEditingFor(messageId)) _cancelEditing(null);
  }

  void _emitMessages(UnmodifiableListView<MessageDocument> messages) {
    _messagesSubject
        .add(UnmodifiableListView<MessageView>(messages.map(_toViewModel)));
  }

  MessageView _toViewModel(MessageDocument message) => MessageView(
      message.id,
      message.content,
      _messagesService.isEditableMessage(message),
      message.createdTime);
}
