import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:model/chat.dart';

class EditMessagePage extends StatefulWidget {
  final MessagesBloc messageBloc;

  EditMessagePage({@required this.messageBloc, Key key}) : super(key: key);

  @override
  createState() => EditMessagePageState(messagesBloc: messageBloc);
}

class EditMessagePageState extends State<EditMessagePage> {
  EditMessagePageState({@required this.messagesBloc});

  final MessagesBloc messagesBloc;

  final TextEditingController _editingMessageTextController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit message')),
      body: Column(
        children: <Widget>[
          Container(
              decoration: BoxDecoration(color: Theme.of(context).cardColor),
              child: _buildTextComposer())
        ],
      ),
    );
  }

  Widget _buildTextComposer() {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).accentColor),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: <Widget>[
            Flexible(
              child: StreamBuilder(
                stream: messagesBloc.editingMessageContent,
                builder: (context, snapshot) {
                  _editingMessageTextController.text = snapshot.data;
                  return TextField(
                    controller: _editingMessageTextController,
                    autofocus: true,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    onSubmitted: (text) => messagesBloc.updateMessage.add(text),
                    decoration: InputDecoration.collapsed(
                        hintText: "Edit this message"),
                  );
                },
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.0),
              child: IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () => messagesBloc.updateMessage
                      .add(_editingMessageTextController.text)),
            ),
          ],
        ),
      ), //new
    );
  }
}

enum MessageCommands { edit, delete }
