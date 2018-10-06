import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:rxdart/rxdart.dart';
import 'package:model/chat.dart';

class AuthImpl implements Auth {
  final fb.FirebaseAuth _auth;

  AuthImpl() : _auth = fb.FirebaseAuth.instance {
    _authSetup();
  }

  final BehaviorSubject<AnonymousUser> _onSignedInAsAnonymousUserSubject =
      BehaviorSubject();

  Stream<AnonymousUser> get onSignedInAsAnonymousUser =>
      _onSignedInAsAnonymousUserSubject.stream;

  Future signInAsAnonymousUser() => _auth.signInAnonymously();

  AnonymousUser _toAnonymousUser(fb.FirebaseUser event) =>
      AnonymousUser(event.uid);

  void _authSetup() => _auth.onAuthStateChanged
      .where((e) => e != null && e.isAnonymous)
      .map(_toAnonymousUser)
      .pipe(_onSignedInAsAnonymousUserSubject);
}
