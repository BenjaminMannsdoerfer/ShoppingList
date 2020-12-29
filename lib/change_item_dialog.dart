import 'package:flutter/material.dart';

class ChangeItemDialog extends StatefulWidget {
  final void Function(String oldKey, bool status, String num) changeEntry;
  final void Function(String oldKey) deleteItem;
  final bool status;
  final String num;
  final String oldKey;

  const ChangeItemDialog(this.changeEntry, this.status, this.num, this.deleteItem, this.oldKey);

  @override
  _ChangeItemDialogState createState() => _ChangeItemDialogState();
}

class _ChangeItemDialogState extends State<ChangeItemDialog> {
  final GlobalKey<FormState> formKey = GlobalKey();
  String key;
  bool status;
  String num;
  String oldKey;

  void save() {
    if (formKey.currentState.validate()) {
      status = widget.status;
      num = widget.num;
      oldKey = widget.oldKey;
      widget.changeEntry(key, status, num);
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
