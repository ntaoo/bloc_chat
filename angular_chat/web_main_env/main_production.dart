import 'package:angular/angular.dart';
import 'package:angular_chat/app_component.dart' as c show FirebaseOptions;
import 'package:angular_chat/app_component.template.dart' as ng;
import 'package:angular_router/angular_router.dart';
import 'package:angular_chat/src/firebase/firebase.dart' as firebase;
import 'main.template.dart' as self;

class FirebaseOptions implements c.FirebaseOptions {
  final String apiKey = "AIzaSyD6OwUmsXkjWyVQLuwFebWEdQ3QRAB2PdQ";
  final String authDomain = "blocchat-7c6a0.firebaseapp.com";
  final String databaseURL = "https://blocchat-7c6a0.firebaseio.com";
  final String projectId = "blocchat-7c6a0";
  final String storageBucket = "";
  final String messagingSenderId = "";
  const FirebaseOptions();
}

const config =
    Module(provide: [ValueProvider(c.FirebaseOptions, FirebaseOptions())]);

@GenerateInjector([routerProviders, config])
final InjectorFactory injector = self.injector$Injector;

void main() {
  firebase.initialize(FirebaseOptions());
  runApp(ng.AppComponentNgFactory, createInjector: injector);
}
