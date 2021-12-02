import 'package:intl/intl.dart';

//Fetch the current time
String getCurrentTime(){
  DateTime now = DateTime.now();
  return  DateFormat('kk:mm ').format(now);
}
