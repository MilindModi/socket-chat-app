import 'package:socket_chat_app/model/user.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class API {

  //Connection string and urls for connections
  // static const BASE_URL = 'http://192.168.0.102:3000';
  static const BASE_URL = 'https://socket-chat-server-minato.herokuapp.com';

  //routes
  static const Register = '/user/register';
  static const LOGIN = '/user/login';

  //creating socket connection
  IO.Socket getSocketConnection(User user){
    return IO
        .io(
        API.BASE_URL,
        IO.OptionBuilder()
            .setTransports(['websocket']) // for Flutter or Dart VM
            .disableAutoConnect() // disable auto-connection
            .setExtraHeaders({'authorization': user.token})
            .build())
        .connect();
  }
}
