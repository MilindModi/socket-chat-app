import 'package:flutter/material.dart';
import 'package:socket_chat_app/api/util.dart';
import 'package:socket_chat_app/model/user.dart';
import 'package:socket_chat_app/util/shared_preference_util.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

// returns true if valid login
Future<bool> loginApi(
    {@required String email, @required String password}) async {
  var valid;
  print("login up api");

  print("Login URL generated :" + API.BASE_URL + API.LOGIN);
  var url = Uri.parse(API.BASE_URL + API.LOGIN);
  //calliing to api
  await http
      .post(
    url,
    headers: {
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode({
      'email': email,
      'password': password,
    }),
  )
      .then((response) async {
    //if successful response
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      valid = jsonResponse['response'];
      if (jsonResponse['user'] != null) {
        // if user registered

        jsonResponse['user']['token'] = jsonResponse['token'];

        //removing already exists user from shared
        await MySharedPreferences.instance.removeValue("user");

        //adding new user in shared
        await MySharedPreferences.instance
            .setObjectValue("user", jsonResponse['user']);

        //Checking if stored or not
        Map userMap = jsonDecode(
            await MySharedPreferences.instance.getStringValue("user"));
        User fetch = User.fromJson(userMap);
        print("Fetched user : " + fetch.toJson().toString());
      }
    } else {
      valid = false;
    }
  }).catchError((error) {
    print("error occurred Login api: ");
    print(error);
    valid = false;
  });
  return valid;
}
