import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:socket_chat_app/model/message.dart';
import 'package:socket_chat_app/util/file_util.dart';

class MessageItem extends StatelessWidget {
  final Message data;
  final bool sentByMe;

  MessageItem({@required this.data, @required this.sentByMe});

  @override
  Widget build(BuildContext context) {
    Color color = this.sentByMe ? Colors.blue : Colors.grey;
    return Align(
      alignment: sentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        margin: EdgeInsets.symmetric(vertical: 3, horizontal: 10),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
        child: this.data.isFile == false ? textMessage() : fileMessage(),
      ),
    );
  }

  //If message type is text this widget will be rendered
  Widget textMessage() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(
          this.data.message,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        SizedBox(
          width: 5,
        ),
        Text(
          this.data.time,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  //if message type is file this Widget will be rendered
  Widget fileMessage() {
    //saving the file  on local device
    saveFile();
    return Container(
      height: 80,
      width: 200,
      child: ListTile(
        onTap: openFile,
        title: Text(
          this.data.message ?? 'File',
          // This will display file name on message if not File
          style: TextStyle(color: Colors.white),
        ),
        tileColor: Colors.red,
      ),
    );
  }

  //this will call utility function to Save file on disk
  void saveFile() async {
    FileUtil.saveFile(this.data);
  }

  //this will call utility function to open file from disk
  void openFile() async {
    FileUtil.openFile(this.data);
  }
}
