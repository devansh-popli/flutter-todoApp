import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pizzeria/pages/home.dart';
import 'package:pizzeria/pages/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? tokenJson = prefs.getString('authToken');
  String? userJson = prefs.getString('user');
  Map<String, dynamic> userMap = {};
  String token = "";
  if (userJson != null) {
    try {
      userMap = jsonDecode(userJson);
    } catch (e) {
      userMap = {}; // fallback to empty if parsing fails
    }
  }
  if (tokenJson != null) {
    try {
      token = tokenJson;
    } catch (e) {
      token = ""; // fallback to empty if parsing fails
    }
  }
  runApp(
    MyApp(
      isLoggedIn: tokenJson != null ? true : false,
      user: userMap,
      token: token,
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  final Map<String, dynamic> user;
  final String token;
  const MyApp({
    super.key,
    required bool this.isLoggedIn,
    required this.user,
    required this.token,
  });

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: isLoggedIn ? Home(userData: user, token: token!) : const Login(),
    );
  }
}
