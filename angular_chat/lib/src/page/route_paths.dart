import 'package:angular_router/angular_router.dart';

const idParam = 'id';

class RoutePaths {
  static final home = RoutePath(path: 'home');
  static final rooms = RoutePath(path: 'rooms');
  static final room = RoutePath(path: '${rooms.path}/:$idParam');
}
