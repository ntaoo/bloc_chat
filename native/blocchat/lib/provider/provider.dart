import 'package:flutter/widgets.dart';
import 'package:model/chat.dart';

class RootProvider extends InheritedWidget {
  final RootProviderModels rootProviderModels;

  RootProvider(
      {Key key, @required Widget child, @required this.rootProviderModels})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;

  static RootProviderModels of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(RootProvider) as RootProvider)
        .rootProviderModels;
  }
}

class RootProviderModels {
  RootProviderModels(
      {@required this.roomsCollection,
      @required this.authService,
      @required this.firestore});

  final RoomsCollection roomsCollection;
  final AuthService authService;
  final Firestore firestore;
}
