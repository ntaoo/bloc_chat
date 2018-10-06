import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_chat/src/page/route_paths.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_router/angular_router.dart';
import 'package:model/chat.dart';

@Component(
    selector: 'chat-rooms',
    styleUrls: ['rooms_component.css'],
    templateUrl: 'rooms_component.html',
    directives: [
      coreDirectives,
      routerDirectives,
      MaterialIconComponent,
      materialInputDirectives,
      MaterialButtonComponent,
    ],
    pipes: [AsyncPipe])
class RoomsComponent implements CanActivate {
  RoomsComponent(this._roomsCollection, this._authService) {
    _roomsCollection.onAdded.listen((e) => rooms.insertAll(0, e));
  }

  final RoomsCollection _roomsCollection;
  final AuthService _authService;

  final List<RoomDocument> rooms = [];
  String newRoomName = '';
  bool adding = false;

  Future<bool> canActivate(RouterState _, RouterState __) =>
      _authService.isUserAuthenticated;

  String roomPath(RoomDocument room) =>
      RoutePaths.room.toUrl(parameters: {'id': room.id});

  Future addRoom() async {
    if (newRoomName.isEmpty) return;

    adding = true;

    await _roomsCollection.add(RoomDocumentAddRequest(name: newRoomName));

    newRoomName = '';
    adding = false;
  }
}
