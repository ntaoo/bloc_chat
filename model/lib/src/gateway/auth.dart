import 'dart:async';

import 'package:model/src/component/auth/user.dart';

abstract class Auth {
  Stream<AnonymousUser> get onSignedInAsAnonymousUser;
  Future signInAsAnonymousUser();
}
