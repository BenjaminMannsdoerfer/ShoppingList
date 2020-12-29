import 'package:flutter/material.dart';
import 'package:fridge_shopping_list/change_item_dialog.dart';
import 'package:fridge_shopping_list/shopping_list_item.dart';
import 'add_item_dialog.dart';
import 'database.dart';
import 'shopping_list_item.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() => runApp(MaterialApp(home: ToDo()));

class ToDo extends StatefulWidget {
  @override
  _ToDoState createState() => _ToDoState();
}

class _ToDoState extends State<ToDo> {
  ScrollController _scrollController = new ScrollController();
  FirebaseUser user;
  DatabaseService database;

  void addItem(String key, String num) {
    database.setItem(key, false, num);
    Navigator.pop(context);
  }

  void deleteItem(String key) {
    database.deleteItem(key);
  }

  void toggleDone(String key, bool value, String num) {
    database.updateItem(key, !value, num);
  }

  void incrementNumber(String key, bool value, String num) {
    int count = int.parse(num.substring(0, num.length - 1));
    print(count);
    ++count;
    num = count.toString();
    database.updateNumber(key, value, num);
  }

  void decrementNumber(String key, bool value, String num) {
    int count = int.parse(num.substring(0, num.length - 1));
    if (count > 1) {
      --count;
    } else {
      Fluttertoast.showToast(
          msg:
              "Ein Produkt muss mindestens einmal vorkommen oder entfernt werden!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
    num = count.toString();
    database.updateNumber(key, value, num);
  }

  void updateItem(String key, bool status, String num) {
    database.updateItem(key, status, num);
  }

  void newEntry() {
    showDialog<AlertDialog>(
        context: context,
        builder: (BuildContext context) {
          return AddItemDialog(addItem);
        });
  }

  void changeEntry(String oldKey, bool status, String num) {
    showDialog<AlertDialog>(
        context: context,
        builder: (BuildContext context) {
          return ChangeItemDialog(updateItem, status, num, deleteItem, oldKey);
        });
  }

  Future<void> connectToFirebase() async {
    final FirebaseAuth authenticate = FirebaseAuth.instance;
    AuthResult result = await authenticate.signInAnonymously();
    try {
      user = result.user;
      database = DatabaseService(user.uid);
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Einkaufsliste"),
        backgroundColor: Colors.orange,
      ),
      body: FutureBuilder(
          future: connectToFirebase(),
          builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else {
              return StreamBuilder<DocumentSnapshot>(
                stream: database.getItem(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    Map<String, dynamic> item = snapshot.data.data;
                    return ListView.builder(
                      controller: _scrollController,
                      itemCount: item.length,
                      itemBuilder: (context, i) {
                        String key = item.keys.elementAt(i);
                        var selected = item['$key'].values.elementAt(0);
                        if (selected == 'true')
                          selected = true;
                        else
                          selected = false;
                        String num = item['$key'].values.elementAt(1);
                        return ShoppingItem(
                            key,
                            num,
                            selected,
                            () => incrementNumber(key, selected, num),
                            () => decrementNumber(key, selected, num),
                            () => changeEntry(key, selected, num),
                            () => deleteItem(key),
                            () => toggleDone(key, selected, num));
                      },
                    );
                  }
                },
              );
            }
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: newEntry,
        child: Icon(Icons.add),
        backgroundColor: Colors.orange,
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.orange,
        child: Container(height: 50),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
