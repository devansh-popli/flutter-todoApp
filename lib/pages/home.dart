import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pizzeria/pages/login.dart';
import 'package:random_string/random_string.dart';
import '../services/database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  final Map<String, dynamic> userData;
  final String token;
  const Home({super.key, required this.userData, required this.token});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool today = true, tomorrow = false, nextWeek = false;
  bool isLoading = false;
  bool suggest = false;
  TextEditingController textEditingController = new TextEditingController();
  List<Map<String, dynamic>>? dataList;

  getOnLoad() async {
    setState(() {
      isLoading = true;
    });
    var todos = await DatabaseMethods().getAllTodos(widget.userData['userId']);

    dataList =
        todos.where((todo) {
          return todo["description"] ==
              (today
                  ? 'Today'
                  : tomorrow
                  ? 'Tomorrow'
                  : 'NextWeek');
        }).toList();
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    getOnLoad();
    super.initState();
  }

  Widget getAllWork() {
    return dataList != null
        ? ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: dataList!.length,
          itemBuilder: (context, index) {
            var doc = dataList![index];
            return CheckboxListTile(
              value: doc.containsKey("completed") ? doc["completed"] : false,
              activeColor: Colors.purple,
              title: Text(
                doc["title"],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
              onChanged: (newValue) async {
                Map<String, dynamic> req = {
                  "title": doc["title"],
                  "completed": true,
                  "userId": widget.userData['userId'],
                  "description": doc["description"],
                };
                var res = await DatabaseMethods().updateTick(
                  doc["id"],
                  req,
                  widget.token,
                );
                if (res.statusCode == 200) {
                  getOnLoad();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Center(
                        child: Text("Please login again session expired"),
                      ),
                    ),
                  );
                }
                setState(() {});
              },
              controlAffinity: ListTileControlAffinity.leading,
            );
          },
        )
        : Column(
          children: [
            SizedBox(height: 20),
            Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
          ],
        );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add, color: Colors.purple),
            onPressed: () {
              openBox();
            },
          ),
          body: Container(
            padding: EdgeInsets.only(top: 70, left: 20, right: 20),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue, Colors.purple],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "TODOS",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    Container(
                      child: InkWell(
                        onTap: () async {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          await prefs.remove('authToken');
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Login(),
                            ),
                            (Route<dynamic> route) => false,
                          );
                        },
                        child: Icon(
                          Icons.logout,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                Text(
                  "HELLO ${widget.userData['name']}",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  "Good Morning",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        today = true;
                        tomorrow = false;
                        nextWeek = false;
                        await getOnLoad();
                        setState(() {});
                      },
                      child:
                          today
                              ? Material(
                                elevation: 5.0,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.purple,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(20),
                                    ),
                                  ),
                                  child: Text(
                                    "Today",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              )
                              : Text(
                                "Today",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        today = false;
                        tomorrow = true;
                        nextWeek = false;
                        await getOnLoad();
                        setState(() {});
                      },
                      child:
                          tomorrow
                              ? Material(
                                elevation: 5.0,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.purple,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(20),
                                    ),
                                  ),
                                  child: Text(
                                    "Tomorrow",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              )
                              : Text(
                                "Tomorrow",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        today = false;
                        tomorrow = false;
                        nextWeek = true;
                        await getOnLoad();
                        setState(() {});
                      },
                      child:
                          nextWeek
                              ? Material(
                                elevation: 5.0,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.purple,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(20),
                                    ),
                                  ),
                                  child: Text(
                                    "Next Week",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              )
                              : Text(
                                "Next Week",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                    ),
                  ],
                ),
                getAllWork(),
              ],
            ),
          ),
        ),
        if (isLoading)
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Future openBox() => showDialog(
    context: context,
    builder:
        (context) => AlertDialog(
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(Icons.cancel),
                    ),
                    SizedBox(width: 100),
                    Text(
                      "Add the work ToDo",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.purple,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Text("Add Text"),
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    border: Border.all(color: Colors.black38),
                  ),
                  child: TextField(
                    controller: textEditingController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Enter Text",
                    ),
                  ),
                ),
                SizedBox(height: 10),
                GestureDetector(
                  onTap: () async {
                    String id = randomAlphaNumeric(10);
                    Map<String, dynamic> req = {
                      "title": textEditingController.text,
                      "completed": false,
                      "userId": widget.userData['userId'],
                      "description":
                          today
                              ? "Today"
                              : tomorrow
                              ? "Tomorrow"
                              : "NextWeek",
                    };
                    var res = await DatabaseMethods().addTodoWork(
                      req,
                      id,
                      widget.token,
                    );
                    if (res.statusCode == 200) {
                      getOnLoad();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Center(
                            child: Text("Please login again session expired"),
                          ),
                        ),
                      );
                    }
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.purple,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      border: Border.all(color: Colors.black38),
                    ),
                    child: Text(
                      "Submit",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
  );
}
