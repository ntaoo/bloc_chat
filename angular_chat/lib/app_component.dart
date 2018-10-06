import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_router/angular_router.dart';
import 'package:model/chat.dart';
import 'package:angular_chat/src/firebase/auth.dart';
import 'package:angular_chat/src/firebase/firestore.dart';
import 'package:angular_chat/src/firebase/rooms_collection.dart';
import 'package:angular_chat/src/page/routes.dart';
export 'src/config/config.dart';

@Component(
    selector: 'my-app',
    styleUrls: ['app_component.css'],
    templateUrl: 'app_component.html',
    directives: [routerDirectives],
    providers: [
      materialProviders,
      ClassProvider(Firestore, useClass: FirestoreImpl),
      ClassProvider(RoomsCollection, useClass: RoomsCollectionImpl),
      ClassProvider(Auth, useClass: AuthImpl),
      ClassProvider(AuthService),
    ],
    exports: [RoutePaths, Routes])
class AppComponent {
  AppComponent(AuthService authService, Auth auth) {
    authService.signInAsAnonymousUser();
  }
}
