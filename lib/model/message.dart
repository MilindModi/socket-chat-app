import 'dart:typed_data';

class Message {
  String message;
  String sentByMe;
  List<dynamic> file;
  bool isFile;
  int deleteTime;
  String time;

  Message({this.message, this.sentByMe,this.time,this.file,this.isFile = false,this.deleteTime = 3000});

  Message.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    sentByMe = json['sentByMe'];
    isFile = json['isFile'];
    file = json['file'];
    time = json['time'];
    deleteTime = json['deleteTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['sentByMe'] = this.sentByMe;
    data['isFile'] = this.isFile;
    data['file'] = this.file;
    data['time'] = this.time;
    data['deleteTime'] = this.deleteTime;
    return data;
  }
  @override
  String toString(){
    return '{${this.message},${this.sentByMe},${this.file}';
  }
}