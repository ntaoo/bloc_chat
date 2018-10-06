import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_chat/src/ui/rooms/rooms_component.dart';
import 'package:angular_router/angular_router.dart';
import 'package:model/chat.dart';

@Component(
    selector: 'home-page',
    styleUrls: ['home_page_component.css'],
    templateUrl: 'home_page_component.html',
    directives: [RoomsComponent])
class HomePageComponent implements CanActivate {
  HomePageComponent(this._authService);

  final AuthService _authService;

  Future<bool> canActivate(RouterState _, RouterState __) =>
      _authService.isUserAuthenticated;
}
