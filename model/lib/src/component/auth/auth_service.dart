import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:stream_transform/stream_transform.dart';

import 'package:model/src/component/auth/user.dart';
import 'package:model/src/gateway/auth.dart';

export 'package:model/src/component/auth/user.dart';

class AuthService {
  AuthService(this._auth) {
    _auth.onSignedInAsAnonymousUser
        .transform(tap((user) => _currentUser = user))
        .pipe(_onSignedInAsAnonymousUserSubject);
  }

  final Auth _auth;
  AnonymousUser _currentUser;

  final BehaviorSubject<AnonymousUser> _onSignedInAsAnonymousUserSubject =
      BehaviorSubject();

  Stream<AnonymousUser> get onSignedInAsAnonymousUser =>
      _onSignedInAsAnonymousUserSubject.stream;

  AnonymousUser get currentUser => _currentUser;

  Future<void> signInAsAnonymousUser() => _auth.signInAsAnonymousUser();

  // Note. This getter doesn't consider unauthenticated case
  // since, on this app, a user should automatically sign in on app booting and does never sign out.
  Future<bool> get isUserAuthenticated async {
    if (_currentUser != null) return true;
    final c = Completer<bool>();
    _onSignedInAsAnonymousUserSubject.stream.listen((_) => c.complete(true));
    return c.future;
  }
}
