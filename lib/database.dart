import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String userID;
  String shareID = 'share';
  DatabaseService(this.userID);

  final CollectionReference shoppingList = Firestore.instance.collection('shoppingList');

  Future setItem(String key, bool value, String num) async {
    return await shoppingList
        .document(userID)
        .setData({'$key': {'Status': '$value', 'Number': '$num' + 'x'}}, merge: true);
  }

  Future updateItem(String key, bool value, String num) async {
    return await shoppingList
        .document(userID)
        .updateData({'$key': {'Status': '$value', 'Number': '$num'}});
  }

  Future updateNumber(String key, bool value, String num) async {
    return await shoppingList
        .document(userID)
        .updateData({'$key': {'Status': '$value', 'Number': '$num' + 'x'}});
  }

  Future deleteItem(String key) async {
    return await shoppingList.document(userID).updateData({
      key: FieldValue.delete()
    });
  }

  Future checkIfUserExists() async {
    if((await shoppingList.document(userID).get()).exists) {
      return true;
    } else {
      return false;
    }
  }

  Stream getItem() {
    return shoppingList.document(userID).snapshots();
  }
}