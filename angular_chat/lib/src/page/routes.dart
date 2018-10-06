import 'package:angular_router/angular_router.dart';
import 'home/home_page_component.template.dart' as home_page_component_template;
import 'room/room_page_component.template.dart' as room_page_component_template;
import 'package:angular_chat/src/page/route_paths.dart';

export 'package:angular_chat/src/page/route_paths.dart';

class Routes {
  static final home = RouteDefinition(
    routePath: RoutePaths.home,
    component: home_page_component_template.HomePageComponentNgFactory,
    useAsDefault: true,
  );
  static final room = RouteDefinition(
    routePath: RoutePaths.room,
    component: room_page_component_template.RoomPageComponentNgFactory,
  );

  static final all = <RouteDefinition>[home, room];
}
