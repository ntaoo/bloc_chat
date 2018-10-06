import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_router/angular_router.dart';

import 'package:angular_chat/src/firebase/messages_collection.dart';
import 'package:model/chat.dart';

@Component(
    selector: 'chat-messages',
    styleUrls: ['messages_component.css'],
    templateUrl: 'messages_component.html',
    directives: [
      coreDirectives,
      routerDirectives,
      MaterialIconComponent,
      materialInputDirectives,
      MaterialButtonComponent,
      MaterialTooltipDirective,
    ],
    pipes: [AsyncPipe])
class MessagesComponent implements OnInit {
  MessagesComponent(this._authService, this._firestore);

  @Input()
  String roomId;

  final AuthService _authService;
  final Firestore _firestore;

  MessagesBloc bloc;
  Stream<List<MessageView>> messages;

  bool isEditingAMessage = false;
  String newMessageContent = '';
  String editingMessageContent = '';

  @override
  void ngOnInit() {
    assert(roomId != null);

    bloc =
        MessagesBloc(_authService, MessagesCollectionImpl(roomId, _firestore));
    bloc
      ..newMessageContent.listen((e) => newMessageContent = e)
      ..editingMessageContent.listen((e) => editingMessageContent = e)
      ..isEditingMessage.listen((e) => isEditingAMessage = e);

    // This is necessary because material-button's trigger output doesn't invoke the bound method in ngFor directive with UnmodifiableListView, for some reason.
    messages = bloc.messages.map((messages) => List.unmodifiable(messages));
  }
}
