import 'package:flutter/material.dart';

class ChangeItemDialog extends StatefulWidget {
  final void Function(String oldKey, bool status, String num, String cat) changeEntry;
  final void Function(String oldKey) deleteItem;
  final bool status;
  final String num;
  final String oldKey;
  final String cat;

  const ChangeItemDialog(this.changeEntry, this.status, this.num, this.deleteItem, this.oldKey, this.cat);

  @override
  _ChangeItemDialogState createState() => _ChangeItemDialogState();
}

class _ChangeItemDialogState extends State<ChangeItemDialog> {
  final GlobalKey<FormState> formKey = GlobalKey();
  String key;
  bool status;
  String num;
  String oldKey;
  String cat;

  void save() {
    if (formKey.currentState.validate()) {
      status = widget.status;
      num = widget.num;
      oldKey = widget.oldKey;
      cat = widget.cat;
      widget.changeEntry(key, status, num, cat);
      widget.deleteItem(oldKey);
    }
    Navigator.of(context).pop();
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
                onChanged: (String txt) => key = txt,
                onFieldSubmitted: (String txt) => save(),
                validator: (String value) {
                  if (value.isEmpty) {
                    return 'Bitte eine Produkt eingeben';
                  }
                  return null;
                }),
            RaisedButton(
              onPressed: save,
              color: Colors.orange,
              child: Text('Save', style: TextStyle(color: Colors.white)),
            )
          ])),
    );
  }
}
