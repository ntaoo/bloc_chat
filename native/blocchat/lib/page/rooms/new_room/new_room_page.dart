import 'dart:async';

import 'package:blocchat/provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:model/chat.dart';

class NewRoomPage extends StatefulWidget {
  NewRoomPage({Key key}) : super(key: key);

  @override
  createState() => NewRoomPageState();
}

class NewRoomPageState extends State<NewRoomPage> {
  final TextEditingController _textController = TextEditingController();

  RoomsCollection _roomsCollection;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final root = RootProvider.of(context);
    _roomsCollection = root.roomsCollection;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(icon: Icon(Icons.close), onPressed: _closePage),
          actions: <Widget>[
            MaterialButton(
                textColor: Colors.white,
                child: Text('Add Room'),
                onPressed: _add)
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(30.0),
          child: TextField(
            autofocus: true,
            decoration: InputDecoration(hintText: 'Enter a new room name.'),
            controller: _textController,
          ),
        ));
  }

  Future _add() async {
    if (_textController.text.isEmpty) return;

    await _roomsCollection
        .add(RoomDocumentAddRequest(name: _textController.text));

    _textController.clear();
    _closePage();
  }

  void _closePage() => Navigator.pop(context);
}
