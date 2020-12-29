import 'package:flutter/material.dart';

class AddItemDialog extends StatefulWidget {
  final void Function(String key, String num) addItem;
  const AddItemDialog(this.addItem);

  @override
  _AddItemDialogState createState() => _AddItemDialogState();
}

class _AddItemDialogState extends State<AddItemDialog> {
  final GlobalKey<FormState> formKey = GlobalKey();
  String item;
  String num;

  void save() {
    if (formKey.currentState.validate()) {
      widget.addItem(item, num);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                onChanged: (String txt) => item = txt,
                onFieldSubmitted: (String txt) => save(),
                validator: (String value) {
                  if (value.isEmpty) {
                    return 'Bitte ein Produkt eingeben';
                  }
                  return null;
                },
              ),
              TextFormField(
                onChanged: (String txt) => num = txt,
                onFieldSubmitted: (String txt) => save(),
                validator: (String value) {
                  if (value.isEmpty) {
                    return 'Bitte die Anzahl des Produktes angeben';
                  }
                  return null;
                },
              ),
              RaisedButton(
                onPressed: save,
                color: Colors.orange,
                child: Text('Save', style: TextStyle(color: Colors.white)),
              )
            ],
          )
      ),
    );
  }

  @override
  void dispose() {
    print('Item removed');
    super.dispose();
  }
}
