import 'package:flutter/material.dart';
import 'package:fridge_shopping_list/categories.dart';

class AddItemDialog extends StatefulWidget {
  final void Function(String key, String num, String cat) addItem;

  const AddItemDialog(this.addItem);

  @override
  _AddItemDialogState createState() => _AddItemDialogState();
}

class _AddItemDialogState extends State<AddItemDialog> {
  final GlobalKey<FormState> formKey = GlobalKey();
  String item;
  String num;

  List<Categories> dropdownCategories = [
    Categories(1, "Gemüse"),
    Categories(2, "Obst"),
    Categories(3, "Getränke"),
    Categories(4, "Milchprodukte"),
    Categories(5, "Fleisch"),
    Categories(6, "Trockenprodukte"),
    Categories(7, "Süßigkeiten"),
    Categories(8, "Drogerieprodukte"),
    Categories(9, "Backwaren/Müsli")
  ];

  List<DropdownMenuItem<Categories>> dropdownMenuCategories;
  Categories selectedCategory;

  void initState() {
    super.initState();
    dropdownMenuCategories = buildDropDownMenuItems(dropdownCategories);
    selectedCategory = dropdownMenuCategories[0].value;
  }

  List<DropdownMenuItem<Categories>> buildDropDownMenuItems(
      List listCategories) {
    List<DropdownMenuItem<Categories>> items = [];
    for (Categories i in listCategories) {
      items.add(
        DropdownMenuItem(
          child: Text(i.name),
          value: i,
        ),
      );
    }
    return items;
  }

  void save() {
    if (formKey.currentState.validate()) {
      widget.addItem(item, num, selectedCategory.name);
      print(selectedCategory.name);
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
              Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: DropdownButton<Categories>(
                    value: selectedCategory,
                    items: dropdownMenuCategories,
                    onChanged: (Categories value) =>
                      setState(() =>
                        selectedCategory = value),
                  )),
              RaisedButton(
                onPressed: save,
                color: Colors.orange,
                child: Text('Save', style: TextStyle(color: Colors.white)),
              ),
            ],
          )),
    );
  }

  @override
  void dispose() {
    print('Item removed');
    super.dispose();
  }
}
