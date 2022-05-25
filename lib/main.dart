import 'package:flutter/material.dart';
import 'package:practica4/screens/authentication.dart';
import 'package:practica4/screens/login_page.dart';

final auth = Authentication();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'SanFrancisco',
      ),
      home: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: const Color.fromRGBO(40, 38, 56, 1),
        body: LoginScreen(),
        bottomNavigationBar: BottomAppBar(
            color: Colors.transparent,
            elevation: 0,
            child: Container(
              padding: EdgeInsets.all(20),
              child: Text(
                "UTN - FRLP",
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            )),
      ),
    );
  }
}
