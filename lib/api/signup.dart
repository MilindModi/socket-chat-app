import 'package:flutter/material.dart';
import 'package:socket_chat_app/api/util.dart';
import 'package:socket_chat_app/model/user.dart';
import 'package:socket_chat_app/util/shared_preference_util.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<bool> signUpApi(
    {@required String email, @required String password}) async {
  var valid;
  print("Sign up api");
  print("Register URL generated :" + API.BASE_URL + API.Register);
  var url = Uri.parse(API.BASE_URL + API.Register);
  await http
      .post(
    url,
    headers:{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode({
      'email': email,
      'password': password,
    }),
  )
      .then((response) async {
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      valid = jsonResponse['response'];
      if( jsonResponse['user'] != null){
        jsonResponse['user']['token'] = jsonResponse['token']  ;
        await MySharedPreferences.instance.removeValue("user");
        await MySharedPreferences.instance.setObjectValue("user", jsonResponse['user']);
        Map userMap = jsonDecode(await MySharedPreferences.instance.getStringValue("user"));
        User fetch = User.fromJson(userMap);
        print("Fetched user : "+fetch.toJson().toString());
      }

    } else {
      valid = false;
    }
  }).catchError((error) {
    print("error occurred Sign up api : ");
    print( error);
    valid = false;
  });
  return valid;
}
