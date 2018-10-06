import 'package:blocchat/page/splash/splash_page.dart';
import 'package:flutter/material.dart';

import 'package:blocchat/firebase/auth.dart';
import 'package:blocchat/firebase/firestore.dart';
import 'package:blocchat/firebase/rooms_collection.dart';
import 'package:blocchat/provider/provider.dart';
import 'package:blocchat/page/home/home_page.dart';

import 'package:model/chat.dart';

void main() async {
  final firestore = FirestoreImpl();
  final authService = AuthService(AuthImpl());
  final roomsCollection = RoomsCollectionImpl(firestore);

  final rootProviderModels = RootProviderModels(
      roomsCollection: roomsCollection,
      authService: authService,
      firestore: firestore);
  runApp(MyApp(rootProviderModels: rootProviderModels));
}

class MyApp extends StatelessWidget {
  final RootProviderModels rootProviderModels;

  const MyApp({@required this.rootProviderModels});

  @override
  Widget build(BuildContext context) {
    return RootProvider(
        rootProviderModels: rootProviderModels,
        child: MaterialApp(title: 'BLoC Chat', initialRoute: '/', routes: {
          '/': (context) => SplashPage(),
          '/home': (context) => HomePage()
        }));
  }
}
