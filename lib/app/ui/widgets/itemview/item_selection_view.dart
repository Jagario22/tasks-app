import 'package:flutter/material.dart';

import 'custom_list_tile.dart';

class ItemSelection extends StatelessWidget {
  final Function onTap;
  final String title;
  final bool selected;

  const ItemSelection({Key key, @required this.onTap, @required this.title, @required this.selected}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(2.0),
      child: CustomListTle(
        onTap: () {
         onTap();
        },
        selectedTitle: Text(title,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme
                    .of(context)
                    .primaryColorDark)),
        title: Text(title),
        selected: selected,
        selectedColor: Theme
            .of(context)
            .hoverColor,
        selectedTrailing: Icon(Icons.check),
      ),
    );
  }

}