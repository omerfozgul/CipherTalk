import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flash_chat/components/rounded_button.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void onLoginPressed() {
    String username = emailController.text.trim();
    String password = passwordController.text;

    // Basit doğrulama için kullanıcı adı ve şifre kontrolü
    if ((username == 'bob' && password == '1234') ||
        (username == 'alice' && password == '1234')) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatScreen(loggedUser: username),
        ),
      );
    } else {
      // Doğrulama başarısızsa bir hata mesajı göster
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("Login Failed"),
            content: new Text("Invalid username or password."),
            actions: <Widget>[
              new TextButton(
                child: new Text("Close"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Hero(
              tag: 'logo',
              child: Container(
                height: 200.0,
                child: Image.asset('images/logo.png'),
              ),
            ),
            SizedBox(height: 48.0),
            TextField(
              controller: emailController,
              decoration:
                  kTextFieldDecoration.copyWith(hintText: 'Enter your name'),
            ),
            SizedBox(height: 8.0),
            TextField(
              controller: passwordController,
              decoration: kTextFieldDecoration.copyWith(
                  hintText: 'Enter your password'),
              obscureText: true, // Şifreyi gizle
            ),
            SizedBox(height: 24.0),
            RoundedButton(
              title: 'Log In',
              colour: Colors.lightBlueAccent,
              onPressed: onLoginPressed,
            ),
          ],
        ),
      ),
    );
  }
}
