import 'package:angular_chat/src/config/config.dart';
import 'package:firebase/firebase.dart' as fb;

void initialize(FirebaseOptions options) {
  fb.initializeApp(
      apiKey: options.apiKey,
      authDomain: options.authDomain,
      databaseURL: options.databaseURL,
      projectId: options.projectId,
      storageBucket: options.storageBucket,
      messagingSenderId: options.messagingSenderId);
  fb.auth().signInAnonymously();
}
