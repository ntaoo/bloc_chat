import 'package:blocchat/provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SplashPage extends StatefulWidget {
  SplashPage({Key key}) : super(key: key);

  @override
  createState() => SplashPageState();
}

class SplashPageState extends State<SplashPage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final root = RootProvider.of(context);
    root.authService.signInAsAnonymousUser();

    root.authService.onSignedInAsAnonymousUser.listen((_) {
      Navigator.of(context).pushReplacementNamed('/home');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text('BLoC Chat')));
  }
}
