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
                  flex: 1,
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
            ]),
        trailing: PopupMenuButton(
          itemBuilder: (context) {
            var list = List<PopupMenuEntry<Object>>();
            list.add(
                PopupMenuItem(
                  child: IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () => changeEntry(),
                  ),
                ));
            list.add(
                PopupMenuItem(
                  child: IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () => increment(),
                  ),
                ));
            list.add(
              PopupMenuItem(
                child: IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: () => decrement(),
              ),
            ));
            list.add(
            PopupMenuItem(
              child: IconButton(
                icon: Icon(Icons.delete_outline),
                onPressed: () => remove(),
              ),
            ));
          return list;
            /*list.add(
              PopupMenuDivider(
                height: 10,
              ),
            );*/
            /*list.add(
              CheckedPopupMenuItem(
                  child: IconButton(
                    icon: Icon(Icons.delete_outline),
                    onPressed: () => remove(),
              ),
            ));
            return list;*/
          },
          icon: Icon(
            Icons.auto_fix_normal,
            //size: 20,
            color: Colors.black,
          ),
        ),
        onTap: () => Navigator.push<dynamic>(
            context,
            MaterialPageRoute<dynamic>(
                builder: (BuildContext context) => DetailScreen(title, done))),
      ),
    );
  }
}
