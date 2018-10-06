import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';
import 'package:model/chat.dart';
import '../../ui/messages/messages_component.dart';

@Component(
    selector: 'room-page',
    styleUrls: ['room_page_component.css'],
    templateUrl: 'room_page_component.html',
    directives: [MessagesComponent, coreDirectives, routerDirectives])
class RoomPageComponent implements OnActivate {
  RoomPageComponent(this._roomsCollection);

  final RoomsCollection _roomsCollection;
  RoomDocument room;

  @override
  void onActivate(_, RouterState current) async {
    final roomId = current.parameters['id'];
    room = await _roomsCollection.get(roomId);
  }
}
