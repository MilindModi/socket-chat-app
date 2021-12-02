import 'dart:io';
import 'dart:typed_data';
import 'package:socket_chat_app/model/message.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

//Util class for files
class FileUtil {
  //saving file with Message model
  static void saveFile(Message message) async {
    print("Saving file");
    //converting dynamic list to uint8List
    List<int> intList = message.file.cast<int>().toList();
    Uint8List data = Uint8List.fromList(intList); //final uint8

    //getting buffer data
    final buffer = data.buffer;
    final appDir = await getTemporaryDirectory();
    File file = File('${appDir.path}/${message.message}');
    file.writeAsBytes(buffer.asUint8List(
        data.offsetInBytes, data.lengthInBytes)); //writing file on disk
  }

  //helps to open file in native application
  static void openFile(Message message) async {
    print("Opening file");
    final appDir = await getTemporaryDirectory();
    File file = File('${appDir.path}/${message.message}');
    print(file.path);
    await OpenFile.open(file.path);
  }

  //delete file from device
  static void deleteFile(Message message) async {
    print("deleting file");
    final appDir = await getTemporaryDirectory();
    File file = File('${appDir.path}/${message.message}');
    file.deleteSync();
  }
}
