import 'dart:async';
import 'package:socket_chat_app/model/message.dart';
import 'package:socket_chat_app/util/file_util.dart';

class MessageBloc {
  List<Message> messages = [];
  final _messageListStreamController = StreamController<List<Message>>();

  final _messageAddController = StreamController<Message>();
  final _messageRemoveController = StreamController<int>();

  Stream<List<Message>> get messageListStream =>
      _messageListStreamController.stream;

  StreamSink<List<Message>> get messageListSink =>
      _messageListStreamController.sink;

  StreamSink<Message> get messageAdd => _messageAddController.sink;

  Stream<Message> get messageRead => _messageAddController.stream;

  StreamSink<int> get messageRemove => _messageRemoveController.sink;

  Stream<int> get messageRemoveRead => _messageRemoveController.stream;

  MessageBloc() {
    _messageListStreamController.add(messages);
    _messageAddController.stream.listen(_newMessage);
    _messageRemoveController.stream.listen(_delMessage);
  }

  _newMessage(Message message) {
    messages.add(message);
    messageListSink.add(messages);
  }

  _delMessage(int index) {
    FileUtil.deleteFile(messages.elementAt(index));
    messages.removeAt(index);
    messageListSink.add(messages);
  }

  void dispose() {
    _messageListStreamController.close();
    _messageAddController.close();
    _messageRemoveController.close();
  }
}
