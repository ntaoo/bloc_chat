import 'package:blocchat/page/rooms/new_room/new_room_page.dart';
import 'package:blocchat/page/rooms/room/room_page.dart';
import 'package:blocchat/provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:model/chat.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  List<RoomDocument> rooms = [];
  RoomsCollection _roomsCollection;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final root = RootProvider.of(context);
    _roomsCollection = root.roomsCollection;

    _roomsCollection.onAdded.listen((rooms) {
      setState(() {
        this.rooms = rooms;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('BLoC Chat')),
      body: _buildRoomListView(),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          tooltip: 'New room',
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return NewRoomPage();
            }));
          }),
    );
  }

  Widget _buildRoomListView() {
    return ListView.builder(
        itemCount: rooms.length,
        itemBuilder: (context, index) {
          final RoomDocument room = rooms[index];
          return ListTile(
              leading: Icon(Icons.chat),
              title: Text(" ${room.name}", style: TextStyle(fontSize: 20.0)),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return RoomPage(roomId: room.id);
                }));
              });
        });
  }
}
