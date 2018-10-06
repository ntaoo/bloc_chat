import 'package:blocchat/firebase/messages_collection.dart';
import 'package:blocchat/page/rooms/room/edit_message_page.dart';
import 'package:blocchat/provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:model/chat.dart';

class RoomPage extends StatefulWidget {
  final String roomId;

  RoomPage({@required this.roomId, Key key}) : super(key: key);

  @override
  createState() => RoomPageState(roomId: roomId);
}

class RoomPageState extends State<RoomPage> {
  RoomPageState({@required this.roomId});

  final String roomId;
  RoomsCollection _roomsCollection;
  MessagesBloc _messageBloc;
  RoomDocument _room;

  final TextEditingController _newMessageTextController =
      TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final root = RootProvider.of(context);
    _messageBloc = MessagesBloc(
        root.authService, MessagesCollectionImpl(roomId, root.firestore));
    _messageBloc.newMessageContent
        .listen((e) => _newMessageTextController.text = e);

    _roomsCollection = root.roomsCollection;
    _roomsCollection.get(roomId).then((room) {
      setState(() {
        this._room = room;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_room == null ? '' : _room.name)),
      body: Column(
        children: <Widget>[
          Flexible(
            child: _buildMessages(),
          ),
          Divider(height: 1.0),
          Container(
              decoration: BoxDecoration(color: Theme.of(context).cardColor),
              child: _buildTextComposer())
        ],
      ),
    );
  }

  StreamBuilder<List<MessageView>> _buildMessages() {
    return StreamBuilder(
        stream: _messageBloc.messages,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Text('Loading...');
          return ListView.builder(
              padding: EdgeInsets.all(8.0),
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                final MessageView message = snapshot.data[index];
                if (message.isEditable) {
                  return ListTile(
                    title: Text(message.content),
                    subtitle: Text(message.createdTime),
                    trailing: _buildActionOnMessagePopupMenuButton(message),
                  );
                } else {
                  return ListTile(
                    title: Text(message.content),
                    subtitle: Text(message.createdTime),
                  );
                }
              });
        });
  }

  Widget _buildTextComposer() {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).accentColor),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: <Widget>[
            Flexible(
              child: TextField(
                controller: _newMessageTextController,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                onSubmitted: (text) {
                  _messageBloc.addMessage.add(text);
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                decoration:
                    InputDecoration.collapsed(hintText: "Send a message"),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.0),
              child: IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    _messageBloc.addMessage.add(_newMessageTextController.text);
                    FocusScope.of(context).requestFocus(FocusNode());
                  }),
            ),
          ],
        ),
      ), //new
    );
  }

  void _openEditMessagePage() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) =>
                EditMessagePage(messageBloc: _messageBloc)));
  }

  Widget _buildActionOnMessagePopupMenuButton(MessageView message) {
    return PopupMenuButton<MessageCommands>(
      // overflow menu
      onSelected: (MessageCommands result) {
        switch (result) {
          case MessageCommands.edit:
            _messageBloc.startEditingMessage.add(message.id);
            _openEditMessagePage();
            break;
          case MessageCommands.delete:
            _messageBloc.deleteMessage.add(message.id);
            break;
        }
      },
      itemBuilder: (BuildContext context) {
        return <PopupMenuEntry<MessageCommands>>[
          PopupMenuItem(child: Text('Edit'), value: MessageCommands.edit),
          PopupMenuItem(child: Text('Delete'), value: MessageCommands.delete)
        ];
      },
    );
  }
}

enum MessageCommands { edit, delete }
