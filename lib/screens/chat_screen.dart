import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:socket_chat_app/api/util.dart';
import 'package:socket_chat_app/bloc/message_bloc.dart';
import 'package:socket_chat_app/model/message.dart';
import 'package:socket_chat_app/model/user.dart';
import 'package:socket_chat_app/util/shared_preference_util.dart';
import 'package:socket_chat_app/util/time_util.dart';
import 'package:socket_chat_app/widgets/message_item.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController msgController;
  IO.Socket socket;
  MessageBloc _messageBloc;
  User user;

  @override
  void dispose() {
    super.dispose();
    print("chat screen disposed");
    _messageBloc.dispose(); //disposing the bloc
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("Chat Screen initState");
    _messageBloc = MessageBloc();
    setUpSocketListener(); // setting up socket listeners
  }

  @override
  Widget build(BuildContext context) {
    msgController = new TextEditingController();

    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        child: Column(
          children: [
            chatListArea(),
            attachment(),
            chatBox(),
          ],
        ),
      ),
    );
  }

  //Widget for chat list area
  Widget chatListArea() {
    return Expanded(
      flex: 8,
      child: Container(
        child: StreamBuilder<List<Message>>(
          stream: _messageBloc.messageListStream,
          builder: chatList,
        ),
      ),
    );
  }

  //Widget for list
  Widget chatList(BuildContext context, AsyncSnapshot<List<Message>> snapshot) {
    return (snapshot.data != null)
        ? ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (context, index) {
              return MessageItem(
                data: snapshot.data[index],
                sentByMe: user.email == snapshot.data[index].sentByMe,
              );
            },
          )
        : SizedBox();
  }

  //Widget for attachment icon
  Widget attachment() {
    return IconButton(
      icon: Icon(
        Icons.attach_file,
        color: Colors.white,
        size: 30,
      ),
      onPressed: sendFile,
    );
  }

  //Widget for chat box
  Widget chatBox() {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(10),
        color: Colors.white,
        child: TextField(
          style: TextStyle(
            color: Colors.black,
            fontSize: 25,
          ),
          cursorColor: Colors.green,
          controller: msgController,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: Colors.blue),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue),
              borderRadius: BorderRadius.circular(10),
            ),
            suffixIcon: Container(
              margin: EdgeInsets.only(right: 10, bottom: 4, top: 4),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(25),
              ),
              child: IconButton(
                icon: Icon(
                  Icons.send,
                  color: Colors.blue,
                ),
                onPressed: () {
                  //Send button in Action
                  sendMessage(msgController.text);
                  msgController.text = "";
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  //Setting up the sockets
  Future<void> setUpSocketListener() async {
    //retrieving the sharedpref stored data
    user = User.fromJson(
        jsonDecode(await MySharedPreferences.instance.getStringValue("user")));

    //Util class for getting socket connection
    API api = API();
    socket = api.getSocketConnection(user);
    // socket.onConnect((_) {});

    //setting up listeners
    socket.on('message-receive', messageReceive);
    socket.on('receive-image', receiveImage);
    socket.on('delete-message', deleteMessage);
    socket.on('receive-file', receiveFile);
  }

  //listener method implementation
  void messageReceive(data) {
    print("message received");
    Message msg = Message.fromJson(data);
    _messageBloc.messageAdd.add(msg);
  }

  //listener method implementation
  void receiveImage(data) {
    print("image received" + data['file']);
    Message msg = Message.fromJson(data);
    _messageBloc.messageAdd.add(msg);
  }

  //listener method implementation
  void deleteMessage(data) {
    _messageBloc.messageRemove.add(data['index']);
  }

  //listener method implementation
  void receiveFile(data) {
    print("received");
    print(data);
    Message msg = Message.fromJson(data['data']);
    print(msg.toJson());
    _messageBloc.messageAdd.add(msg);
  }

  //Method for sending message
  sendMessage(String msg) {
    //fetching current time
    String formattedTime = getCurrentTime();

    //Json for sending Data
    var messageJSON = {
      "message": msg,
      "sentByMe": user.email,
      "isFile": false,
      "time": formattedTime
    };
    socket.emit('message', messageJSON); //sending socket message
    _messageBloc.messageAdd
        .add(Message.fromJson(messageJSON)); //Adding to bloc listener
  }

  //Method for broadcasting File on server
  void sendFile() async {
    //pick up file  from the storage
    FilePickerResult result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'pdf', 'doc'],
    );

    //if file is not selected
    if (result != null) {
      print(result.files[0]);
      final myFile = File(result.files[0].path);

      //converting to bytes before sending
      final bytes = await myFile.readAsBytes();

      //delete time from text box and default time if not mentioned
      int time = int.tryParse(msgController.text) ?? 5;

      String formattedTime = getCurrentTime(); //current time

      //Json object for sending data to server
      var data = Message.fromJson({
        "message": result.files[0].name,
        "file": bytes,
        "sentByMe": user.email,
        "deleteTime": time,
        "isFile": true,
        "time": formattedTime
      });
      print(bytes.runtimeType);
      print("File Name : " + data.toJson()['message']);

      msgController.text = "";

      //adding to data socket
      _messageBloc.messageAdd.add(data);
      //sending data to server for broadcast
      socket.emit('send-file', {
        "data": data,
        "index": _messageBloc.messages.length,
      });
    }
  }
}
