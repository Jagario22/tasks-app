import 'package:flutter/material.dart';

class CustomListTle extends StatelessWidget {
  final bool selected;
  final Function onTap;
  final Widget title;
  final Color selectedColor;
  final Widget selectedTrailing;
  final Widget trailing;
  final Widget selectedTitle;
  final Widget leading;
  final Color tileColor;
  final Function onLongPress;

  const CustomListTle({
    Key key,
    this.selected,
    this.onTap,
    this.title,
    this.selectedColor,
    this.selectedTrailing,
    this.selectedTitle,
    this.leading,
    this.trailing,
    this.tileColor, this.onLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return selected ? _buildSelectedListTile(context) : buildListTile(context);
  }

  Widget _buildSelectedListTile(BuildContext context) {
    return ListTile(
      onTap: () {
        if (onTap != null) onTap();
      },
      contentPadding: EdgeInsets.fromLTRB(5, 0, 5, 0),
      title: selectedTitle == null ? title : selectedTitle,
      selected: true,
      onLongPress: () {
        onLongPress();
      },
      selectedTileColor: selectedColor,
      trailing: selectedTrailing == null ? trailing : selectedTrailing,
      leading: leading,
    );
  }

  Widget buildListTile(BuildContext context) {
    return ListTile(
      onTap: () {
        if (onTap != null) onTap();
      },
      onLongPress: () {
        onLongPress();
      },
      contentPadding: EdgeInsets.fromLTRB(5, 0, 5, 0),
      tileColor: tileColor,
      title: title,
      selected: false,
      leading: leading,
      trailing: trailing,
    );
  }
}
