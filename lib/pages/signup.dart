import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pizzeria/model/user.dart';
import 'package:pizzeria/pages/home.dart';
import 'package:pizzeria/pages/login.dart';
import 'package:pizzeria/services/database.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  User user = new User("", "", "");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(left: 20, right: 20),
                decoration: BoxDecoration(
                  color: Colors.purple,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(80),
                    bottomRight: Radius.circular(80),
                  ),
                  boxShadow: [BoxShadow(blurRadius: 20, color: Colors.black)],
                ),
                height: MediaQuery.of(context).size.height * 0.8,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    SizedBox(height: 100),
                    Text(
                      "Register Page",
                      style: GoogleFonts.pacifico(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 40,
                      ),
                    ),
                    SizedBox(height: 40),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Name",
                        style: GoogleFonts.roboto(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    TextFormField(
                      style: TextStyle(color: Colors.white),
                      controller: TextEditingController(text: user.name),
                      onChanged: (value) {
                        user.name = value;
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'name cant be empty';
                        } else
                          return '';
                      },
                      decoration: InputDecoration(
                        hintText: "Enter Name",
                        hintStyle: TextStyle(color: Colors.white),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Email",
                        style: GoogleFonts.roboto(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    TextFormField(
                      style: TextStyle(color: Colors.white),
                      controller: TextEditingController(text: user.email),
                      onChanged: (value) {
                        user.email = value;
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'email cant be empty';
                        } else
                          return '';
                      },
                      decoration: InputDecoration(
                        hintText: "Enter Email",
                        hintStyle: TextStyle(color: Colors.white),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Password",
                        style: GoogleFonts.roboto(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    TextFormField(
                      controller: TextEditingController(text: user.password),
                      onChanged: (value) {
                        user.password = value;
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'password cant be empty';
                        } else
                          return '';
                      },
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "Enter Password",
                        hintStyle: TextStyle(color: Colors.white),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(height: 50),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Login()),
                        );
                      },
                      child: Text(
                        "Already have a account?",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 50),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.all(20),
                  backgroundColor: Colors.purple, // Purple background
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      60,
                    ), // Slightly rounded corners
                  ),
                ),
                onPressed: () async {
                  print(user.email + " " + user.password);
                  var res = await DatabaseMethods().registerUser(user);
                  print(res.body);
                  if (res.statusCode == 201) {
                    // You can add additional response checks if needed (e.g., success field in body)
                    var userData = jsonDecode(res.body);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => Login()),
                    );
                  } else {
                    // Optional: show error to user
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Center(
                          child: Text("Register failed. Please try again."),
                        ),
                      ),
                    );
                  }
                },
                child: Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                ), // Optional: white icon
              ),
            ],
          ),
        ),
      ),
    );
  }
}
