import 'package:flutter/material.dart';
import 'package:fridge_shopping_list/change_item_dialog.dart';
import 'package:fridge_shopping_list/shopping_list_item.dart';
import 'add_item_dialog.dart';
import 'database.dart';
import 'shopping_list_item.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grouped_list/grouped_list.dart';

void main() => runApp(MaterialApp(home: ToDo()));

class ToDo extends StatefulWidget {
  @override
  _ToDoState createState() => _ToDoState();
}

class _ToDoState extends State<ToDo> {
  FirebaseUser user;
  DatabaseService database;

  void addItem(String key, String num, String cat) {
    database.setItem(key, false, num, cat);
    Navigator.pop(context);
  }

  void deleteItem(String key) {
    database.deleteItem(key);
    Navigator.pop(context);
  }

  void toggleDone(String key, bool value, String num, String cat) {
    database.updateItem(key, !value, num, cat);
  }

  void incrementNumber(String key, bool value, String num, String cat) {
    int count = int.parse(num.substring(0, num.length - 1));
    ++count;
    num = count.toString();
    database.updateNumber(key, value, num, cat);
    Navigator.pop(context);
  }

  void decrementNumber(String key, bool value, String num, String cat) {
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
    database.updateNumber(key, value, num, cat);
    Navigator.pop(context);
  }

  void updateItem(String key, bool status, String num, cat) {
    database.updateItem(key, status, num, cat);
  }

  void newEntry() {
    showDialog<AlertDialog>(
        context: context,
        builder: (BuildContext context) {
          return AddItemDialog(addItem);
        });
  }

  void changeEntry(String oldKey, bool status, String num, String cat) {
    showDialog<AlertDialog>(
        context: context,
        builder: (BuildContext context) {
          return ChangeItemDialog(
              updateItem, status, num, deleteItem, oldKey, cat);
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
                    List<dynamic> elements = item.entries.toList();
                    return GroupedListView(
                        elements: elements,
                        groupBy: (shoppingItem) {
                          return shoppingItem.value['Categorie'];
                        },
                        groupHeaderBuilder: (shoppingItem) {
                          return Container(
                            child: Column(
                              children: [
                                Divider(
                                  color: Colors.grey,
                                  thickness: 2,
                                ),
                                Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 0, vertical: 0),
                                    child: Row(children: <Widget>[
                                      Checkbox(
                                        value: true,
                                        onChanged: (bool value) => value = true,
                                        activeColor: Colors.blue,
                                      ),
                                      Text(
                                        shoppingItem.value['Categorie'],
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ])),
                                Divider(
                                  color: Colors.grey,
                                  thickness: 2,
                                )
                              ],
                            ),
                          );
                        },
                        indexedItemBuilder:
                            (context, dynamic shoppingItem, int index) {
                          var selected = shoppingItem.value['Status'];
                          if (selected == 'true')
                            selected = true;
                          else
                            selected = false;
                          return ShoppingItem(
                            shoppingItem.key,
                            shoppingItem.value['Number'],
                            selected,
                            () => incrementNumber(
                                shoppingItem.key,
                                selected,
                                shoppingItem.value['Number'],
                                shoppingItem.value['Categorie']),
                            () => decrementNumber(
                                shoppingItem.key,
                                selected,
                                shoppingItem.value['Number'],
                                shoppingItem.value['Categorie']),
                            () => changeEntry(
                                shoppingItem.key,
                                selected,
                                shoppingItem.value['Number'],
                                shoppingItem.value['Categorie']),
                            () => deleteItem(shoppingItem.key),
                            () => toggleDone(
                                shoppingItem.key,
                                selected,
                                shoppingItem.value['Number'],
                                shoppingItem.value['Categorie']),
                          );
                        });
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
