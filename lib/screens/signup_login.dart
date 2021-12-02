import "package:flutter/material.dart";
import 'package:socket_chat_app/api/login_api.dart';
import 'package:socket_chat_app/api/signup.dart';
import 'package:socket_chat_app/screens/chat_screen.dart';
import 'package:socket_chat_app/widgets/custom_textbox.dart';

class SignUpLogin extends StatefulWidget {
  @override
  _SignUpLoginState createState() => _SignUpLoginState();
}

class _SignUpLoginState extends State<SignUpLogin> {
  TextEditingController emailController;
  TextEditingController passwordController;
  bool _obscureText = true;
  IconData _suffixIcon = Icons.visibility_off;

  //for invalid credential
  bool error = false;

  @override
  void dispose() {
    super.dispose();
    print("Sign up disposed");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("Sign up initState");
  }

  _SignUpLoginState() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(color: Colors.white),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(80, 80, 80, 50),
              child: Center(
                child: CustomTextBox(
                  editTextController: emailController,
                  hintText: "Email",
                  textInputType: TextInputType.text,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(80, 5, 80, 40),
              child: Center(
                child: CustomTextBox(
                  editTextController: passwordController,
                  hintText: "Password",
                  textInputType: TextInputType.text,
                  suffixBtn: true,
                  suffixIcon: this._suffixIcon,
                  obscureText: this._obscureText,
                  handle: this.viewPassword,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(80, 5, 80, 40),
              child: Center(
                  child: this.error ? Text("Wrong credentials") : SizedBox()),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(80, 5, 80, 80),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      //Login button in action
                      String email = emailController.text;
                      String password = passwordController.text;
                      login(email, password);
                    },
                    child: Text(
                      "Login",
                      style: TextStyle(color: Colors.black),
                    ),
                    style: ElevatedButton.styleFrom(
                        primary: Colors.lightBlue,
                        textStyle: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Sign up button in action
                      String email = emailController.text;
                      String password = passwordController.text;
                      signUp(email, password);
                    },
                    child: Text(
                      "Sign Up",
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.lightBlue,
                      textStyle: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.normal),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

//Call util api method  for login return true if valid login
  void login(String email, String password) {
    // email = "milindmodi11@gmail.com";
    // password = "12345";
    //Call util api method  for login return true if valid login
    loginApi(email: email, password: password).then((value) {
      print(value);
      if (value) {
        chatScreen();
      } else {
        setState(() {
          this.error = true;
        });
      }
    });
  }

//Call util api method  for register return true if valid register
  void signUp(String email, String password) {
    signUpApi(email: email, password: password).then((value) {
      if (value) {
        chatScreen();
      } else {
        setState(() {
          this.error = true;
        });
      }
    });
  }

  //Navigate to next screen
  void chatScreen() {
    // Navigating to Chat screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ChatScreen(),
      ),
    );
  }

  //toggle for view and disable password
  void viewPassword() {
    setState(() {
      _suffixIcon = _obscureText ? Icons.visibility : Icons.visibility_off;
      _obscureText = !_obscureText;
    });
  }
}
