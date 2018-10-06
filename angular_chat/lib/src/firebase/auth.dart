import 'dart:async';

import 'package:firebase/firebase.dart' as fb;
import 'package:rxdart/rxdart.dart';
import 'package:model/chat.dart';

class AuthImpl implements Auth {
  AuthImpl() {
    _authSetup();
  }

  final BehaviorSubject<AnonymousUser> _onSignedInAsAnonymousUserSubject =
      BehaviorSubject();

  Stream<AnonymousUser> get onSignedInAsAnonymousUser =>
      _onSignedInAsAnonymousUserSubject.stream;

  Future signInAsAnonymousUser() => fb.auth().signInAnonymously();

  AnonymousUser _toAnonymousUser(fb.User event) => AnonymousUser(event.uid);

  void _authSetup() => fb
      .auth()
      .onAuthStateChanged
      .where((e) => e != null && e.isAnonymous)
      .map(_toAnonymousUser)
      .pipe(_onSignedInAsAnonymousUserSubject);
}
