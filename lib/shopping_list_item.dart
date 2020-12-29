import 'package:flutter/material.dart';
import 'detail_screen.dart';

class ShoppingItem extends StatelessWidget {
  final String title;
  final String num;
  final bool done;
  final Function increment;
  final Function decrement;
  final Function changeEntry;
  final Function remove;
  final Function toogleDone;

  const ShoppingItem(this.title, this.num, this.done, this.increment,
      this.decrement, this.changeEntry, this.remove, this.toogleDone);

  @override
  Widget build(BuildContext context) {
    int index;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 8.0),
        leading: Checkbox(
          value: done,
          onChanged: (bool value) => toogleDone(),
          activeColor: Colors.orange,
        ),
        title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Expanded(
                  flex: 5,
                  child: Text(
                    title,
                    style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600,
                        color: done ? Colors.orange : Colors.black54,
                        decoration: done
                            ? TextDecoration.lineThrough
                            : TextDecoration.none),
                  )),
              Expanded(
                  flex: 2,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () => changeEntry(),
                  )),
              Expanded(
                  flex: 2,
                  child: Text(
                    num,
                    style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600,
                        color: done ? Colors.orange : Colors.black54,
                        decoration: done
                            ? TextDecoration.lineThrough
                            : TextDecoration.none),
                  )),
              Expanded(
                  child: IconButton(
                icon: Icon(Icons.add),
                onPressed: () => increment(),
              )),
              Expanded(
                  child: IconButton(
                icon: Icon(Icons.remove),
                onPressed: () => decrement(),
              ))
            ]),
        trailing: IconButton(
          icon: Icon(Icons.delete_outline),
          onPressed: () => remove(),
        ),
        onTap: () => Navigator.push<dynamic>(
            context,
            MaterialPageRoute<dynamic>(
                builder: (BuildContext context) => DetailScreen(title, done))),
      ),
    );
  }
}
