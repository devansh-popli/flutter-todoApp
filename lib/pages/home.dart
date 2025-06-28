import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';
import '../services/database.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool today = true, tomorrow = false, nextWeek = false;
  bool suggest = false;
  TextEditingController textEditingController = new TextEditingController();
  Stream? dataList;
  getOnLoad() async {
    dataList = await DatabaseMethods().getAllTodos(
      today
          ? "Today"
          : tomorrow
          ? "Tomorrow"
          : "NextWeek",
    );
    setState(() {});
  }

  @override
  void initState() {
    getOnLoad();
    super.initState();
  }

  Widget getAllWork() {
    return StreamBuilder(
      stream: dataList,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) {
                var doc =
                    snapshot.data.docs[index].data() as Map<String, dynamic>;
                return CheckboxListTile(
                  value: doc.containsKey("Yes") ? doc["Yes"] : false,
                  activeColor: Colors.purple,
                  title: Text(
                    doc["Work"],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                  onChanged: (newValue) {
                    DatabaseMethods().updateTick(
                      doc["id"],
                      today
                          ? "Today"
                          : tomorrow
                          ? "Tomorrow"
                          : "NextWeek",
                    );
                    setState(() {});
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                );
              },
            )
            : CircularProgressIndicator();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add, color: Colors.purple),
        onPressed: () {
          openBox();
        },
      ),
      body: Container(
        padding: EdgeInsets.only(top: 90, left: 20, right: 20),
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
            Text(
              "HELLO\nDEVANSH",
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
                            borderRadius: BorderRadius.all(Radius.circular(20)),
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
                            borderRadius: BorderRadius.all(Radius.circular(20)),
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
                            borderRadius: BorderRadius.all(Radius.circular(20)),
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
                  onTap: () {
                    String id = randomAlphaNumeric(10);
                    Map<String, dynamic> req = {
                      "Work": textEditingController.text,
                      "id": id,
                      "Yes": false,
                    };
                    today
                        ? DatabaseMethods().addTodayWork(req, id)
                        : tomorrow
                        ? DatabaseMethods().addTomorrowWork(req, id)
                        : DatabaseMethods().addNextWeekWork(req, id);
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
